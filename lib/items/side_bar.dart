import 'package:flutter/material.dart';
import 'package:order_up/items/meun_items/logout_dialog.dart';
import 'package:order_up/models/chat.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/chatting_provider.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/chat_component/chats_list_screen.dart';
import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:order_up/widgets/orders_component/order_progres.dart';
import 'package:order_up/widgets/profile_component/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:order_up/widgets/chat_component/Badge.dart' as io;

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late int _confirmedOrderCount;
  List<Chat> _chatsList = [];

  @override
  void initState() {
    super.initState();
    _confirmedOrderCount = getInProgressOrderCount();
    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false).profileData;
    chatProvider.getChatsByUserId(authProvider!.id);
  }

  int getInProgressOrderCount() {
    // Get the orders data using the provider
    final ordersData = Provider.of<Orders>(context, listen: false);
    final inProgressOrders =
        ordersData.orders.where((order) => isOrderInProgress(order)).toList();
    return inProgressOrders.length;
  }

  bool isOrderInProgress(OrdersItem order) {
    // Determine if an order is 'In Progress'
    return order.status == 'In Progress';
  }

  Widget _buildNotificationBadge(int count) {
    return count > 0
        ? CircleAvatar(
            backgroundColor: Colors.red, // Customize badge color
            radius: 10,
            child: Text(
              '$count',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        : SizedBox.shrink();
  }

  Widget buildListTile(String title, IconData icon, VoidCallback onTapHandler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTapHandler,
      trailing: title == 'Orders'
          ? _buildNotificationBadge(_confirmedOrderCount)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context).profileData;
    final chatProvider = Provider.of<ChattingProvider>(context);

    final String? name = authProvider?.name;
    final String? email = authProvider?.email;
    final String? imageURL = authProvider?.image;
    _chatsList = chatProvider.chatsList;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // user info in the side bar
          UserAccountsDrawerHeader(
            accountName: Text(name ?? "Name",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            accountEmail: Text(email ?? "Email",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            currentAccountPicture:
                // CircleAvatar(
                //   child: ClipOval(
                //     child: Image.asset(
                //       'assets/images/imageOffline.png',
                //       fit: BoxFit.cover,
                //       height: 100,
                //       width: 100,
                //     ),
                //   ),
                // ),
                CircleAvatar(
              radius: 60,
              backgroundImage: imageURL == null || imageURL == ''
                  ? NetworkImage('https://via.placeholder.com/150')
                  : NetworkImage(imageURL),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 152, 223, 167),
              image: DecorationImage(
                  image: AssetImage('assets/images/drawerbg.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.6),
            ),
          ),

          // menu list
          buildListTile(
              'Home',
              Icons.home_outlined,
              () => Navigator.of(context)
                  .pushReplacementNamed(ResturantMainPageScreen.routeName)),
          buildListTile(
              'Orders',
              Icons.inventory_outlined,
              () => Navigator.of(context)
                  .pushReplacementNamed(OrderProgres.routeName)),
          Divider(),

          buildListTile(
            'Profile',
            Icons.account_box_outlined,
            () => Navigator.of(context)
                .pushReplacementNamed(ProfileScreen.routeName),
          ),
          ListTile(
            title: Text('Chatting'),
            leading: Icon(Icons.message_outlined),
            onTap: () =>
                Navigator.of(context).pushNamed(ChatsListScreen.routeName),
            trailing: io.Badge(
              value: "${getNumberOfUnseenChats(_chatsList)}",
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Icon(
                // size: 5,
                Icons.navigate_next,
                color: Colors.black,
              ),
            ),
          ),
          Divider(),

          buildListTile(
            'Log Out',
            Icons.login_outlined,
            () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(
          onLogout: () {
            Navigator.of(context).pop(); // Close the dialog
            Future.delayed(Duration(milliseconds: 100), () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            });
          },
        );
      },
    );
  }

  int getNumberOfUnseenChats(List<Chat> chats) {
    // Filter the chats to find those that have at least one unseen message
    var unseenChats = chats.where((chat) {
      return chat.chatMessages.any((message) {
        return message.from == chat.secondUserId && !message.isSeen;
      });
    }).toList();

    // Return the count of unseen chats
    return unseenChats.length;
  }
}
