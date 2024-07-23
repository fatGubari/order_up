import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_up/models/chat.dart';
import 'package:order_up/models/chat_message.dart';
import 'package:firebase_database/firebase_database.dart';

class ChattingProvider with ChangeNotifier {
  List<ChatMessage> _chatMessages = [];

  List<ChatMessage> get chatMessages {
    return [..._chatMessages];
  }

  List<Chat> _chatsList = [];

  List<Chat> get chatsList {
    return [..._chatsList];
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String? chatId,
    required String userId,
    required String receiverId,
    required String text,
  }) async {
    await _firestore
        .collection('chats_messages')
        .doc(chatId)
        .collection('messages')
        .doc()
        .set({
      'text': text,
      'to': receiverId,
      'from': userId,
      'SentAt': DateTime.now(),
      'seen': false,
    });
  }

  Future<void> getChatMessagesByChatId({required String? chatId}) async {
    _chatMessages = [];
    notifyListeners();
    // find chat id first
    try {
      _firestore
          .collection('chats_messages')
          .doc(chatId)
          .collection('messages')
          .orderBy('SentAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        List<ChatMessage> messages = snapshot.docs.map((doc) {
          var data = doc.data();
          return ChatMessage(
            id: doc.id,
            text: data['text'] ?? '',
            sentAt: (data['SentAt'] as Timestamp).toDate(),
            to: data['to'] ?? '',
            from: data['from'] ?? '',
            isSeen: data['seen'] ?? false,
          );
        }).toList();

        if (chatId != null) {
          _updateChatList(chatId, messages);
        }
      });
    } catch (e) {
      // print('_chatMessages error: $e');
    }
  }

  void _updateChatList(String chatId, List<ChatMessage> messages) {
    // Find the index of the chat with the given chatId
    int chatIndex = _chatsList.indexWhere((chat) => chat.id == chatId);

    if (chatIndex != -1) {
      // If the chat exists, update its messages
      _chatsList[chatIndex].chatMessages = messages;
    } else {
      // If the chat does not exist, add a new chat to the list
      _chatsList.add(Chat(id: chatId, chatMessages: messages));
    }

    // Optionally, sort the list to keep the newest chats at the top
    _chatsList.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    // Trigger a state update if using a state management solution
    notifyListeners();
  }

  Future<void> getChatsByUserId(String userId) async {
    try {
      // Query for messages where the user is the sender or receiver
      var query1 = _firestore
          .collectionGroup('messages')
          .where('from', isEqualTo: userId)
          .orderBy('SentAt', descending: true);
      var query2 = _firestore
          .collectionGroup('messages')
          .where('to', isEqualTo: userId)
          .orderBy('SentAt', descending: true);

      var results1 = await query1.get();
      var results2 = await query2.get();

      // Combine results
      var combinedResults = [...results1.docs, ...results2.docs];

      // Group messages by chat ID
      Map<String, List<ChatMessage>> chatMap = {};

      for (var doc in combinedResults) {
        var data = doc.data() as Map<String, dynamic>;
        var chatId = doc.reference.parent.parent?.id;

        if (chatId != null) {
          if (!chatMap.containsKey(chatId)) {
            chatMap[chatId] = [];
          }

          chatMap[chatId]!.add(ChatMessage(
            id: doc.id,
            text: data['text'] ?? '',
            sentAt: (data['SentAt'] as Timestamp).toDate(),
            to: data['to'] ?? '',
            from: data['from'] ?? '',
            isSeen: data['seen'] ?? false,
          ));
        }
      }

      // Create list of Chat objects and sort by the last message time
      List<Chat> chats = await Future.wait(chatMap.entries.map((entry) async {
        String chatId = entry.key;
        List<ChatMessage> messages = entry.value;

        String secondUserId = messages
            .firstWhere((msg) => msg.from != userId,
                orElse: () => messages.first)
            .from;
        if (secondUserId == userId) {
          secondUserId = messages
              .firstWhere((msg) => msg.to != userId,
                  orElse: () => messages.first)
              .to;
        }

        ChatUser? chatUser = await getUserNameAndImage(uId: secondUserId);

        return Chat(
          id: chatId,
          secondUserId: secondUserId,
          chatMessages: messages,
          chatUser: chatUser,
        );
      }).toList());

      // Sort chats by the last message time in descending order
      chats.sort((a, b) =>
          b.chatMessages.last.sentAt.compareTo(a.chatMessages.first.sentAt));
      _chatsList = chats;
      // print('_chatsList: $_chatsList');
      chats.forEach(
        (chat) async {
          await getChatMessagesByChatId(chatId: chat.id);
          // _updateChatList(chat.id, chat.chatMessages);
        },
      );
    } catch (error) {
      // print('chats error: $error');
    }
  }

  Future<String?> getChatId(String userId, String receiverId) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Query for messages from receiverId to userId
    var query1 = _firestore
        .collectionGroup('messages')
        .where('from', isEqualTo: receiverId)
        .where('to', isEqualTo: userId);

    // Query for messages from userId to receiverId
    var query2 = _firestore
        .collectionGroup('messages')
        .where('from', isEqualTo: userId)
        .where('to', isEqualTo: receiverId);

    // Execute both queries
    var results1 = await query1.get();
    var results2 = await query2.get();

    // Combine results and check if any document exists
    var combinedResults = [...results1.docs, ...results2.docs];

    if (combinedResults.isNotEmpty) {
      // If there are results, retrieve the chat ID from the first result
      var chatId = combinedResults.first.reference.parent.parent?.id;
      // print('chat id: $chatId');
      // _chatId = chatId;
      // _getMessagesByChatId(chatId!);
      return chatId!;
    }
    return null;
    // If no chat exists, return nulls
  }

  Future<ChatUser?> getUserNameAndImage({required String uId}) async {
    // print('uId: $uId');
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref('restaurants/$uId');
    DatabaseReference ref2 = database.ref('suppliers/$uId');

    try {
      // Try to fetch from the first reference (restaurants)
      DatabaseEvent event = await ref.once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        return ChatUser(
          name: data['name'] ?? '',
          imageUrl: data['image'] ?? '',
        );
      } else {
        // If the first reference returns null, try the second reference (suppliers)
        DatabaseEvent event2 = await ref2.once();
        if (event2.snapshot.value != null) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(event2.snapshot.value as Map);
          return ChatUser(
            name: data['name'] ?? '',
            imageUrl: data['image'] ?? '',
          );
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }

    // Return null if the user is not found in both references
    return null;
  }
}
