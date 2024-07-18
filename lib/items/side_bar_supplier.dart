import 'package:flutter/material.dart';
import 'package:order_up/items/meun_items/logout_dialog.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:order_up/widgets/manage_product_componenet/manage_product.dart';
import 'package:order_up/widgets/profile_component/profile_screen.dart';
import 'package:order_up/widgets/sales_component/sales_screen.dart';
import 'package:order_up/widgets/supplier_home_componenet/supplier_homepage.dart';
import 'package:provider/provider.dart';

class SideBarSupplier extends StatefulWidget {
  const SideBarSupplier({super.key});

  @override
  State<SideBarSupplier> createState() => _SideBarSupplierState();
}

class _SideBarSupplierState extends State<SideBarSupplier> {
  Widget buildListTile(String title, IconData icon, VoidCallback onTapHandler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTapHandler,
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
                  .pushReplacementNamed(SupplierHomepage.routeName)),
          buildListTile(
              'Manage Product',
              Icons.precision_manufacturing_outlined,
              () => Navigator.of(context)
                  .pushReplacementNamed(ManageProduct.routeName)),
          Divider(),

          buildListTile(
              'Profile',
              Icons.account_box_outlined,
              () => Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName)),
          buildListTile('Chating', Icons.message_outlined,
              () => Navigator.of(context).pushReplacementNamed('/')),
          Divider(),
          buildListTile(
              'Sales',
              Icons.point_of_sale_sharp,
              () => Navigator.of(context)
                  .pushReplacementNamed(SalesScreen.routeName)),
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
