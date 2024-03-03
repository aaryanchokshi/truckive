import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class RideHistoryPage extends StatefulWidget {
  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  final databaseRef =
      FirebaseDatabase.instance.reference(); // Reference to the database

  // List of rides with Indian locations and fare in INR
  final List<Map<String, dynamic>> rides = [
    {
      'id': '1',
      'date': '2024-03-01',
      'origin': 'India Gate',
      'destination': 'Lotus Temple',
      'fare': '150',
    },
    {
      'id': '2',
      'date': '2024-03-02',
      'origin': 'Gateway of India',
      'destination': 'Marine Drive',
      'fare': '200',
    },
    {
      'id': '3',
      'date': '2024-03-03',
      'origin': 'Victoria Memorial',
      'destination': 'Howrah Bridge',
      'fare': '250',
    },
    {
      'id': '4',
      'date': '2024-03-04',
      'origin': 'Charminar',
      'destination': 'Golconda Fort',
      'fare': '180',
    },
    {
      'id': '5',
      'date': '2024-03-05',
      'origin': 'Mysore Palace',
      'destination': 'Brindavan Gardens',
      'fare': '220',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Normally, you'd call a method here to fetch ride history from Firebase
    // For demonstration, we're using static data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride History', style: GoogleFonts.lato()),
      ),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          return ListTile(
            title: Text('${ride['origin']} to ${ride['destination']}'),
            subtitle: Text('${ride['date']} - ₹${ride['fare']}'),
            leading: Icon(Icons.local_shipping),
          );
        },
      ),
    );
  }

  // Example method to add a ride to Firebase Realtime Database
  void addRideToDatabase(Map<String, dynamic> ride) {
    databaseRef.child('rides').push().set(ride).then((_) {
      print('Ride added to database successfully!');
    }).catchError((error) {
      print('Failed to add ride: $error');
    });
  }
}
