import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'EditProfilePage.dart';
//import 'edit_profile_page.dart';
//import 'settings_page.dart';
import 'help_support_page.dart';
import 'settings_screen.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Example user image
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 20),
                Text('Alex Johnson',
                    style: GoogleFonts.lato(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('alex.johnson@example.com',
                    style: GoogleFonts.lato(
                        fontSize: 18, color: Colors.grey[600])),
                SizedBox(height: 20),
                _buildProfileOption(context, 'Edit Profile', Icons.edit, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                }),
                _buildProfileOption(context, 'Settings', Icons.settings, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                }),
                _buildProfileOption(context, 'Help & Support', Icons.help, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelpSupportPage()));
                }),
                _buildProfileOption(context, 'Log Out', Icons.exit_to_app, () {
                  // Handle log out
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: GoogleFonts.lato(fontSize: 20)),
        onTap: onTap,
      ),
    );
  }
}
