import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For using Clipboard
import 'package:firebase_database/firebase_database.dart';

class OrderConfirmedPage extends StatefulWidget {
  final String orderId;

  const OrderConfirmedPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderConfirmedPageState createState() => _OrderConfirmedPageState();
}

class _OrderConfirmedPageState extends State<OrderConfirmedPage> {
  Map<String, dynamic>? orderDetails;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final snapshot =
        await databaseReference.child('orders/${widget.orderId}').get();

    if (snapshot.exists) {
      setState(() {
        orderDetails = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmed'),
      ),
      body: orderDetails == null
          ? Center(child: CircularProgressIndicator())
          : buildOrderDetails(),
    );
  }

  Widget buildOrderDetails() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/ic_launcher.jpg', // Replace with your actual logo asset path
                  width: 100, // Adjust the size as needed
                  height: 100, // Adjust the size as needed
                ),
                SizedBox(height: 20), // Space between logo and text
                Text(
                  'Order Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                detailText('Order ID:', widget.orderId),
                detailText('Full Name:', orderDetails!['fullName']),
                detailText('Contact Number:', orderDetails!['contactNumber']),
                detailText('Pickup Location:', orderDetails!['pickupLocation']),
                detailText(
                    'Drop-off Location:', orderDetails!['dropOffLocation']),
                detailText('Date of Pickup:', orderDetails!['dateOfPickup']),
                detailText('Special Instructions:',
                    orderDetails!['specialInstructions'] ?? 'N/A'),
                detailText('Truck Type:', orderDetails!['truckType']),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.orderId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order ID copied to clipboard!'),
                      ),
                    );
                  },
                  child: Text('Copy Order ID'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child:
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
