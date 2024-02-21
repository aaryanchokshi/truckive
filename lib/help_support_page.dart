import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  void _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       labelText: 'Search for help',
          //       suffixIcon: Icon(Icons.search),
          //     ),
          //     onSubmitted: (value) {
          //       // Implement search functionality
          //     },
          //   ),
          // ),
          ListTile(
            title: Text('Contact Support via Email', style: GoogleFonts.lato()),
            leading:
                Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
            onTap: () => _launchURL('mailto:support@truckive.com'),
          ),
          ListTile(
            title: Text('Contact Support via Phone', style: GoogleFonts.lato()),
            leading:
                Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
            onTap: () => _launchURL('tel:+1234567890'),
          ),
          ListTile(
            title: Text('Getting Started', style: GoogleFonts.lato()),
            onTap: () {
              // Navigate to getting started help articles
            },
          ),
          ListTile(
            title:
                Text('Account and Payment Options', style: GoogleFonts.lato()),
            onTap: () {
              // Navigate to account/payment help articles
            },
          ),
          ListTile(
            title: Text('Guide to Truckive', style: GoogleFonts.lato()),
            onTap: () {
              // Navigate to Truckive guide articles
            },
          ),
          ListTile(
            title: Text('Safety Tips', style: GoogleFonts.lato()),
            onTap: () {
              // Navigate to safety tips articles
            },
          ),
        ],
      ),
    );
  }
}
