import 'package:flutter/material.dart';
import 'package:order_up/models/chat.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/chat_component/chat_screen.dart';
import 'package:order_up/widgets/chat_component/Badge.dart' as io;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatItem extends StatelessWidget {
  final Chat chat;
  ChatItem({super.key, required this.chat});
  late String _uid;

  void goToChat(
    BuildContext context,
    String receiverId,
    ChatUser chatUser,
  ) {
    Navigator.of(context).pushNamed(
      // SuppliersScreens.routeName,
      ChatScreen.routeName,
      arguments: {
        'id': receiverId,
        'imageURL': chatUser.imageUrl,
        'name': chatUser.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context).profileData;
    _uid = authProvider!.id;

    return InkWell(
      onTap: () => goToChat(context, chat.secondUserId!, chat.chatUser!),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: ClipOval(
              child: Image.network(
                // 'chat.chatUser.imageUrl == null ?',
                chat.chatUser!.imageUrl,
                // 'https://tinypng.com/images/social/website.jpg',
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
          title: Text(
            chat.chatUser!.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            chat.chatMessages.first.text,
            style: TextStyle(
              color: !chat.chatMessages.first.isSeen &&
                      chat.chatMessages.first.to == _uid
                  ? Theme.of(context).colorScheme.inversePrimary
                  : null,
            ),
          ),
          trailing: budgeValue() > 0
              ? io.Badge(
                  value: budgeValue().toString(),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Icon(
                    // size: 5,
                    Icons.navigate_next,
                    color: Colors.black,
                  ),
                )
              : Icon(
                  // size: 5,
                  Icons.navigate_next,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }

  int budgeValue() {
    // Filter messages to find those from the specific user that are not seen
    var unreadMessages = chat.chatMessages.where((message) {
      return message.from == chat.secondUserId && !message.isSeen;
    }).toList();

    // Return the count of unread messages
    return unreadMessages.length;
  }
}
