import 'package:flutter/material.dart';

class SafetyTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Tips'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Safety Tips for Drivers',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text('1. Always verify the identity of your customer.'),
            Text('2. Follow traffic rules and drive safely.'),
            Text('3. Regularly maintain your vehicle.'),
            // Add more safety tips
            SizedBox(height: 16),
            Text(
              'Safety Tips for Customers',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text('1. Share your trip details with someone you trust.'),
            Text('2. Verify the driver and vehicle before starting your trip.'),
            Text('3. Wear your seatbelt.'),
            // Add more safety tips
          ],
        ),
      ),
    );
  }
}
