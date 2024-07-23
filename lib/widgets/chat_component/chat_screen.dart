import 'package:flutter/material.dart';
import 'package:order_up/models/chat.dart';
import 'package:order_up/models/chat_message.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/chatting_provider.dart';
import 'package:order_up/widgets/chat_component/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  // late Provider<ChattingProvider> _chatProvider;
  List<ChatMessage> _chatMessages = [];

  bool _disableSendButton = true;
  bool _isLoading = true;
  bool _isSending = false;
  String? _chatId;
  late String _uid;
  late String _reciverId;

  Future<void> _loadChat() async {
    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);
    _chatId = await chatProvider.getChatId(_uid, _reciverId);
    await chatProvider.getChatMessagesByChatId(chatId: _chatId);
    _isLoading = false;
    setState(() {});
  }

  Future<void> _onSendMessage() async {
    _isSending = true;

    final text = _textEditingController.text;
    _textEditingController.clear();

    setState(() {});
    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);
    await chatProvider.sendMessage(
      chatId: _chatId,
      userId: _uid,
      receiverId: _reciverId,
      text: text,
    );
    setState(() {
      // _messageText = _textEditingController.text;
      _isSending = false;
      _disableSendButton = true;
    });
    print('_onSendMessage');
  }

  Future<void> _setMessagesAsSeen() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch messages that need to be updated
    QuerySnapshot querySnapshot = await firestore
        .collection('chats_messages')
        .doc(_chatId)
        .collection('messages')
        .where('from', isEqualTo: _reciverId)
        .where('to', isEqualTo: _uid)
        .where('seen', isEqualTo: false) // Only fetch unseen messages
        .get();

    // Update each message to set 'seen' to true
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'seen': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final reciverData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final authProvider = Provider.of<Auth>(context).profileData;
    final chatProvider = Provider.of<ChattingProvider>(context);
    final chat = chatProvider.chatsList.firstWhere(
      (chat) => chat.id == _chatId,
      orElse: () => Chat(id: '', chatMessages: []),
    );
    _chatMessages = chat.chatMessages;

    _uid = authProvider!.id;
    _reciverId = reciverData['id']!;

    if (!_isLoading) _setMessagesAsSeen();
    // if (_chatId == null) {
    //   _findChatId(_uid, _reciverId);
    // }
    if (_chatId == null) _loadChat();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 23.0,
              backgroundImage: NetworkImage(reciverData['imageURL']!),
              onBackgroundImageError: (exception, stackTrace) => exception,
            ),
            const SizedBox(width: 5),
            Text(
              reciverData['name']!,
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                _isLoading
                    ? LinearProgressIndicator()
                    : Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          reverse: true,
                          child: ListView(
                            shrinkWrap: true,
                            cacheExtent: 99999999,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50, top: 30),
                            children: [
                              if (_chatMessages != null)
                                ...(_chatMessages).map((message) {
                                  return MessageBubble(
                                    message: message,
                                  );
                                }),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(-3, 2),
                ),
              ],
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
            child: Row(
              children: <Widget>[
                // if (!_isIconVisible) cleanIcon(),
                // AnimatedSwitcher(
                //   duration: const Duration(milliseconds: 200),
                //   child: _isIconVisible ? null : cleanIcon(),
                // ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    maxLines: 4,
                    maxLength: 256,
                    minLines: 1,
                    cursorHeight: 20,
                    cursorColor: Theme.of(context).colorScheme.inversePrimary,
                    controller: _textEditingController,
                    onChanged: _changeTextFiledIcon,
                    // enabled: !_isSending,

                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(
                    //     RegExp('[a-z A-Z 0-9 ? . ,]'),
                    //   )
                    // ],
                    decoration: InputDecoration(
                      counterText: '',
                      //...........
                      hintText: 'Send message ..',
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        // child: _isIconVisible ? _sendButton() : _recordButton(),
                        child: _sendButton(),
                      ),

                      suffixIconConstraints: const BoxConstraints(maxWidth: 50),

                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      ),

                      border: InputBorder.none,
                      filled: true,
                      // fillColor: Theme.of(context).colorScheme.secondary,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 20, bottom: 10, top: 10, right: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeTextFiledIcon(var value) {
    if (value.toString().trim().isNotEmpty) {
      _disableSendButton = false;
    } else {
      _disableSendButton = true;
    }
    setState(() {});
  }

  Widget _sendButton() {
    return InkWell(
      onTap: _disableSendButton || _isSending
          ? null
          : () {
              _onSendMessage();
            },
      // onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: CircleAvatar(
          backgroundColor: _disableSendButton || _isSending
              ? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)
              : Theme.of(context).colorScheme.inversePrimary,
          // Theme.of(context).primaryColor.withOpacity(0.9),
          child: _isSending
              ? CircularProgressIndicator()
              : Icon(
                  Icons.send,
                  size: 23,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
