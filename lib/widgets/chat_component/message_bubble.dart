import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_up/models/chat_message.dart';
import 'package:order_up/providers/auth.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late String _uid;
  @override
  Widget build(BuildContext context) {
    _uid = Provider.of<Auth>(context).profileData!.id;
    // Provider.of<ChatMessage>(context);
    return _uid == widget.message.from
        ? _userMessageBubble(widget.message)
        : _chatMessageBubble(widget.message);

    // return _userMessageBubble("widget.message");
  }

  Widget _userMessageBubble(ChatMessage message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              key: widget.key,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              constraints: const BoxConstraints(
                minWidth: 80.0,
                maxWidth: 280.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22.0),
                    topRight: Radius.circular(22.0),
                    bottomLeft: Radius.circular(22.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(3, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 16.0,
                  // fontFamily: 'Myriad Pro Regular',
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              right: 27,
              child: Row(
                children: [
                  if (message.isSeen)
                    Icon(
                      Icons.remove_red_eye,
                      size: 11,
                      color: Colors.black45,
                    ),
                  SizedBox(width: 1),
                  Text(
                    '${DateFormat.jm().format(message.sentAt)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11.0,
                      // fontFamily: 'Myriad Pro Regular',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _chatMessageBubble(ChatMessage message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              key: widget.key,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              constraints: const BoxConstraints(
                minWidth: 80.0,
                maxWidth: 280.0,
              ),
              // width: MediaQuery.of(context).size.width * 0.72,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(22.0),
                    bottomLeft: Radius.circular(22.0),
                    bottomRight: Radius.circular(22.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(3, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      // fontFamily: 'Myriad Pro Regular',
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 14,
              right: 35,
              child: Text(
                '' + DateFormat.jm().format(message.sentAt),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11.0,
                  // fontFamily: 'Myriad Pro Regular',
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
