import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'privacy.dart';
import 'ride_history_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // ListTile(
          //   title: Text('Personal Information', style: GoogleFonts.lato()),
          //   leading: Icon(Icons.person,
          //       color: Theme.of(context).colorScheme.primary),
          //   onTap: () {
          //     // Navigate to personal information settings
          //   },
          // ),
          SwitchListTile(
            title: Text('Enable Notifications', style: GoogleFonts.lato()),
            value: true, // Bind this value to your user settings
            onChanged: (bool value) {
              // Update and save the setting
            },
            secondary: Icon(Icons.notifications,
                color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            title: Text('Ride History', style: GoogleFonts.lato()),
            leading: Icon(Icons.history,
                color: Theme.of(context).colorScheme.primary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RideHistoryPage()),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Settings', style: GoogleFonts.lato()),
            leading: Icon(Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacySettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
