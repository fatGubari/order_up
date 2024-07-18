import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/profile_component/change_image.dart';
import 'package:order_up/widgets/profile_component/change_location.dart';
import 'package:provider/provider.dart';

class EditProfileDialog {
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditProfile(),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String selectedLocation = 'New York, USA';
  LatLng? selectedLocationLatLng;

  @override
  void initState() {
    super.initState();
    nameController.text =
        Provider.of<Auth>(context, listen: false).profileData!.name;
    emailController.text =
        Provider.of<Auth>(context, listen: false).profileData!.email;
    phoneNumberController.text =
        Provider.of<Auth>(context, listen: false).profileData!.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChangeImage(),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
            ),
            SizedBox(height: 10),
            ChangeLocation(
              selectedLocationMap: selectedLocation,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveChanges(context),
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveChanges(BuildContext context) {
    // final String location = locationController.text;
    final String newName = nameController.text.trim();
    final String newEmail = emailController.text.trim();
    final String newPhoneNumber = phoneNumberController.text.trim();

    if (!_isEmailValid(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email address.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (!_isPhoneNumberValid(newPhoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid phone number.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Update user profile data in your Auth provider or backend service
    final authProvider = Provider.of<Auth>(context, listen: false);
    final String? userType = authProvider.userType;
    authProvider.updateUserProfile(
      newName: newName,
      newEmail: newEmail,
      newPhoneNumber: newPhoneNumber,
      userType: userType,
    );

    Navigator.of(context).pop();
  }

  bool _isEmailValid(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    final RegExp regex = RegExp(r'^\+?[0-9]{1,3} ?-?[0-9]{6,12}$');
    return regex.hasMatch(phoneNumber);
  }
}
