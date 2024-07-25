import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_up/models/profile_data.dart';
import 'package:order_up/providers/auth.dart';
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
  // final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String? selectedLocation;
  // LatLng? selectedLocationLatLng;
  File? _storedImage;

  @override
  void initState() {
    super.initState();
    ProfileData profileData =
        Provider.of<Auth>(context, listen: false).profileData as ProfileData;
    nameController.text = profileData.name;
    emailController.text = profileData.email;
    phoneNumberController.text = profileData.phoneNumber;
    selectedLocation = profileData.location;
  }

  Future<void> _saveChanges(BuildContext context) async {
    // final String location = locationController.text;
    final String newName = nameController.text.trim();
    final String newEmail = emailController.text.trim();
    final String newPhoneNumber = phoneNumberController.text.trim();
    String? newImage = imageURL;
    final authProvider = Provider.of<Auth>(context, listen: false);
    try {
      // final String uid = FirebaseAuth.instance.currentUser!.uid;
      if (_storedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child('${authProvider.userId}.jpg');
        await ref.putFile(_storedImage!).whenComplete(() => print('completed'));
        newImage = await ref.getDownloadURL();
      } else {
        // newImage = appUser.imageUrl;
      }
      //
    } catch (e) {
      print('addUser error: $e');
    }

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
    final String? userType = authProvider.userType;
    authProvider.updateUserProfile(
      newName: newName,
      newEmail: newEmail,
      newPhoneNumber: newPhoneNumber,
      newLocation: selectedLocation,
      userType: userType,
      newImage: newImage,
    );

    Navigator.of(context).pop();
  }

  late String? imageURL;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context).profileData;
    imageURL = authProvider?.image;

    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ChangeImage(),
            _imageInput(),
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
              setLocation: _setLocation,
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

  void _setLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _storedImage = File(pickedImage.path);
      });
    }
  }

  Widget _imageInput() {
    ImageProvider<Object>? image = Image(image: AssetImage('')).image;
    if (_storedImage != null) {
      image = FileImage(_storedImage!);
    } else if (imageURL != null) {
      image = NetworkImage(imageURL!);
    } else {
      image = null;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image,
          child: image == null
              ? Icon(
                  Icons.person,
                  size: 50,
                )
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 15,
              child: Icon(
                image == null ? Icons.add : Icons.edit,
                size: 19,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
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
