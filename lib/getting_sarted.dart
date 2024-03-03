import 'package:flutter/material.dart';

class GettingStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Getting Started with Truckive'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Truckive!',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Text(
              'Follow these steps to get started:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text('1. Create an account.'),
            Text('2. Add your vehicle details.'),
            Text('3. Set up your payment preferences.'),
            Text('4. Read through safety tips.'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to account setup page
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
