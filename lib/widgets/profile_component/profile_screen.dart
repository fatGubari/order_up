import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/profile_component/change_password.dart';
import 'package:order_up/widgets/profile_component/edit_profile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context).profileData;
    final authProviderUserType = Provider.of<Auth>(context);
    // Get user information from Auth provider
    final String? name = authProvider?.name;
    final String? email = authProvider?.email;
    final String? location = authProvider?.location;
    final String? imageURL = authProvider?.image;
    final String? phoneNumber = authProvider?.phoneNumber;
    final String? userType = authProviderUserType.userType;

    return Scaffold(
      drawer: userType == 'restaurant' ? SideBar() : SideBarSupplier(),
      appBar: AppBar(
        title: Text('User Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageURL == null || imageURL == ''
                        ? NetworkImage('https://via.placeholder.com/150')
                        : NetworkImage(imageURL),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: $name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Text(
                    'Location: $location',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Functionality to change password
                      ChangePasswordDialog().show(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).iconTheme.color),
                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                    ),
                    child: Text('Change Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Functionality to edit profile
                      EditProfileDialog().show(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).iconTheme.color),
                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
