import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Assume these are bound to actual user data
  final TextEditingController _nameController =
      TextEditingController(text: "User Name");
  final TextEditingController _emailController =
      TextEditingController(text: "user@example.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.lato()),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save changes
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
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
