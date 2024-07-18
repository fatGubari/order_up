import 'package:flutter/material.dart';
import 'package:order_up/items/meun_items/logout_dialog.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:order_up/widgets/orders_component/order_progres.dart';
import 'package:order_up/widgets/profile_component/profile_screen.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late int _confirmedOrderCount;

  @override
  void initState() {
    super.initState();
    _confirmedOrderCount = getInProgressOrderCount();
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // user info in the side bar
          UserAccountsDrawerHeader(
            accountName: Text("Name",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            accountEmail: Text("Email",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/imageOffline.png',
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 152, 223, 167),
              image: DecorationImage(
                  image: AssetImage('assets/images/orange_wallpaper.jpg'),
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
                  .pushReplacementNamed(ProfileScreen.routeName)),
          buildListTile('Chating', Icons.message_outlined,
              () => Navigator.of(context).pushReplacementNamed('')),
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
}
