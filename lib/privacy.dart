import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _shareData = true;
  bool _locationTracking = true;
  bool _receiveNotifications = true;
  bool _allowCookies = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings', style: GoogleFonts.lato()),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Share Data with Third Parties'),
            subtitle:
                Text('Allow us to share your data with trusted third parties.'),
            value: _shareData,
            onChanged: (bool value) {
              setState(() {
                _shareData = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Location Tracking'),
            subtitle:
                Text('Allow us to access your location for improved services.'),
            value: _locationTracking,
            onChanged: (bool value) {
              setState(() {
                _locationTracking = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Receive Notifications'),
            subtitle: Text('Receive updates and notifications.'),
            value: _receiveNotifications,
            onChanged: (bool value) {
              setState(() {
                _receiveNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Allow Cookies'),
            subtitle:
                Text('Allow us to store cookies for better service delivery.'),
            value: _allowCookies,
            onChanged: (bool value) {
              setState(() {
                _allowCookies = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
