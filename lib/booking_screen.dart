import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book a Truck')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                suffixIcon: Icon(Icons.location_on),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Dropoff Location',
                suffixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
