import 'package:flutter/material.dart';
import 'package:order_up/models/chat.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/chatting_provider.dart';
import 'package:order_up/widgets/chat_component/chat_item.dart';
import 'package:provider/provider.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});
  static const routeName = '/chats-list-screen';

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  late String _uid;
  List<Chat> _chatsList = [];
  bool _isStart = false;
  bool _isLoading = true;

  Future<void> _getChats() async {
    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);
    await chatProvider.getChatsByUserId(_uid);
    _isLoading = false;
    _isStart = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context).profileData;
    final chatProvider = Provider.of<ChattingProvider>(context);
    _chatsList = chatProvider.chatsList;
    _uid = authProvider!.id;
    if (!_isStart) {
      _getChats();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? LinearProgressIndicator()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView(
                    shrinkWrap: true,
                    cacheExtent: 99999999,
                    physics: const NeverScrollableScrollPhysics(),
                    // padding: const EdgeInsets.only(bottom: 50, top: 30),
                    children: [
                      if (_chatsList != null)
                        ...(_chatsList).map((chat) {
                          return ChatItem(chat: chat);
                        }).toList(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
