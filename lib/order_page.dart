import 'package:flutter/material.dart';
import 'track_order_page.dart';
import 'truck_order.dart'; // Ensure this is the correct import for your PlaceOrderPage

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double paddingSize = 16.0; // Define padding size

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(
            paddingSize), // Use padding size for consistent padding
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Track Order Button
                _buildButton(
                  context: context,
                  icon: Icons.track_changes,
                  label: 'Track Order',
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrackOrderPage()),
                    );
                  },
                ),
                SizedBox(
                    height:
                        paddingSize), // Use padding size for consistent spacing
                // Place Order Button
                _buildButton(
                  context: context,
                  icon: Icons.shopping_cart,
                  label: 'Place Order',
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaceOrderPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    double buttonSize = MediaQuery.of(context).size.width * 0.5;

    return Container(
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.all(10),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 40), // Icon size adjusted back to original
        label: Text(label,
            style:
                TextStyle(fontSize: 20)), // Text size adjusted back to original
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color, // Button background color
          onPrimary: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Rounded corners as originally defined
          ),
        ),
      ),
    );
  }
}
