import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "User Name");
  final TextEditingController _emailController =
      TextEditingController(text: "user@example.com");
  final TextEditingController _phoneController = TextEditingController(
      text: "1234567890"); // Default or fetched from Firebase

  final databaseRef =
      FirebaseDatabase.instance.reference(); // Reference to the database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.lato()),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save changes to Firebase Realtime Database
              updateProfile();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/userimage.webp'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }

  void updateProfile() {
    // Assuming 'users' is your node and 'user_id' is the id of the user to update
    // You might want to fetch 'user_id' dynamically based on the logged-in user's info
    String userId = "user_id"; // Replace with actual user ID
    databaseRef.child('users/$userId').update({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
        ),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   // Assume these are bound to actual user data
//   final TextEditingController _nameController =
//       TextEditingController(text: "User Name");
//   final TextEditingController _emailController =
//       TextEditingController(text: "user@example.com");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile', style: GoogleFonts.lato()),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () {
//               // Save changes
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage('assets/userimage.webp'),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             // Add more fields as necessary
//           ],
//         ),
//       ),
//     );
//   }
// }
