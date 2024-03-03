import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Guide', style: GoogleFonts.lato()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to Truckive - Your Guide',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            Text(
              'Getting Started',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Create or log in to your account to get started.'),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Add your vehicle details in the profile section.'),
            ),
            SizedBox(height: 20),
            Text(
              'Making Deliveries',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Use the map to find delivery requests near you.'),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(
                  'Check the payment details before accepting a delivery.'),
            ),
            SizedBox(height: 20),
            Text(
              'Safety Tips',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Always verify the recipient’s ID for deliveries.'),
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text(
                  'Keep your vehicle well-maintained to avoid breakdowns.'),
            ),
            SizedBox(height: 20),
            Text(
              'Support',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Contact our support team anytime through the app.'),
            ),
          ],
        ),
      ),
    );
  }
}
