import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: 10, // Number of notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification ${index + 1}', style: GoogleFonts.lato()),
            subtitle: Text('This is the detail of notification ${index + 1}.',
                style: GoogleFonts.lato()),
          );
        },
      ),
    );
  }
}
