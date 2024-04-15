import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For using Clipboard
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';

import 'order_confirmed.dart';

class PlaceOrderPage extends StatefulWidget {
  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropOffLocationController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  DateTime? _selectedDate;
  String? _truckType;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _requestPermissions();
  }

  void _initNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestPermissions() async {
    await Permission.phone.request();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
          _dateController.text = DateFormat.yMd().format(pickedDate);
        });
      }
    });
  }

  // Future<void> _placeOrder() async {
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   final orderId = databaseReference.child('orders').push().key;

  //   final orderData = {
  //     'fullName': _fullNameController.text,
  //     'contactNumber': _contactNumberController.text,
  //     'pickupLocation': _pickupLocationController.text,
  //     'dropOffLocation': _dropOffLocationController.text,
  //     'dateOfPickup': _dateController.text,
  //     'specialInstructions': _specialInstructionsController.text,
  //     'truckType': _truckType,
  //     'orderId': orderId,
  //   };

  //   await databaseReference.child('orders/$orderId').set(orderData);

  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'order_confirmation_channel',
  //     'Order Confirmations',
  //     //'Notifications for order confirmations and updates',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   var platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //       0,
  //       'Order Confirmed',
  //       'Your order has been placed successfully! Order ID: $orderId',
  //       platformChannelSpecifics);

  //   // Show a snackbar with the option to copy the Order ID
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Order placed successfully! Order ID: $orderId'),
  //       action: SnackBarAction(
  //         label: 'Copy',
  //         onPressed: () {
  //           Clipboard.setData(ClipboardData(text: orderId!));
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('Order ID copied to clipboard!'),
  //               duration: Duration(seconds: 2),
  //             ),
  //           );
  //         },
  //       ),
  //       duration: Duration(seconds: 4),
  //     ),
  //   );
  // }
  Future<void> _placeOrder() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final orderId = databaseReference.child('orders').push().key;

    if (orderId != null) {
      final orderData = {
        'fullName': _fullNameController.text,
        'contactNumber': _contactNumberController.text,
        'pickupLocation': _pickupLocationController.text,
        'dropOffLocation': _dropOffLocationController.text,
        'dateOfPickup': _dateController.text,
        'specialInstructions': _specialInstructionsController.text,
        'truckType': _truckType,
        'orderId': orderId,
      };

      await databaseReference.child('orders/$orderId').set(orderData);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'order_confirmation_channel',
        'Order Confirmations',
        //'Notifications for order confirmations and updates',
        importance: Importance.max,
        priority: Priority.high,
      );
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Order Confirmed',
          'Your order has been placed successfully! Order ID: $orderId',
          platformChannelSpecifics);

      // Show a snackbar with the option to copy the Order ID
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Order placed successfully! Order ID: $orderId'),
      //     action: SnackBarAction(
      //       label: 'Copy',
      //       onPressed: () {
      //         Clipboard.setData(ClipboardData(text: orderId!));
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             content: Text('Order ID copied to clipboard!'),
      //             duration: Duration(seconds: 2),
      //           ),
      //         );
      //       },
      //     ),
      //     duration: Duration(seconds: 4),
      //   ),
      // );
      // Navigate to OrderConfirmedPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OrderConfirmedPage(orderId: orderId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _contactNumberController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _pickupLocationController,
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dropOffLocationController,
              decoration: InputDecoration(
                labelText: 'Drop-off Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_shipping),
              ),
              value: _truckType,
              hint: Text('Select Truck Type'),
              items: ['Small', 'Medium', 'Large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _truckType = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date of Pickup',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _presentDatePicker,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _specialInstructionsController,
              decoration: InputDecoration(
                labelText: 'Special Instructions (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_add),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _placeOrder,
              child: Text('Place Order'),
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

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _pickupLocationController.dispose();
    _dropOffLocationController.dispose();
    _dateController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }
}
