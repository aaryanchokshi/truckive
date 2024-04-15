import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class TextPage extends StatefulWidget {
  final String orderId;

  const TextPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  String? pickupLocation;
  String? dropOffLocation;

  @override
  void initState() {
    super.initState();
    fetchOrderLocations();
  }

  void fetchOrderLocations() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final snapshot =
        await databaseReference.child('orders/${widget.orderId}').get();

    if (snapshot.exists) {
      final orderData = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        pickupLocation = orderData['pickupLocation'];
        dropOffLocation = orderData['dropOffLocation'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Locations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickupLocation != null && dropOffLocation != null) ...[
              Text('Pickup Location: $pickupLocation'),
              SizedBox(height: 8),
              Text('Drop-off Location: $dropOffLocation'),
            ] else
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
