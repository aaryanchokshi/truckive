import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dashboard_page.dart'; // Assuming this is your dashboard page.

class TrackOrderPage extends StatefulWidget {
  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.ref();

  void _trackOrder() async {
    final orderRef =
        databaseReference.child('orders/${_orderIdController.text.trim()}');
    final snapshot = await orderRef.get();

    if (snapshot.exists && snapshot.value != null) {
      final orderData = Map<String, dynamic>.from(snapshot.value as Map);
      if (orderData['fullName'] == _nameController.text.trim() &&
          orderData['contactNumber'] == _mobileNumberController.text.trim()) {
        _showOrderDetailsDialog(orderData);
      } else {
        _showErrorDialog("Order details do not match.");
      }
    } else {
      _showErrorDialog("Order ID not found.");
    }
  }

  void _showOrderDetailsDialog(Map<String, dynamic> orderData) {
    String orderId = orderData['orderId'] ??
        ''; // Assuming 'orderId' is part of your order data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Found"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Order ID: $orderId found."),
                SizedBox(height: 8),
                Text("Status: ${orderData['status'] ?? 'Not available'}"),
                SizedBox(height: 8),
                Text(
                    "Pickup Location: ${orderData['pickupLocation'] ?? 'Not specified'}"),
                SizedBox(height: 8),
                Text(
                    "Drop-off Location: ${orderData['dropOffLocation'] ?? 'Not specified'}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(orderId: orderId),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _orderIdController,
              decoration: InputDecoration(
                labelText: 'Order ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _trackOrder,
              child: Text('Track Order'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
