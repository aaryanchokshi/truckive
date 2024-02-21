import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Details', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Example placeholder image
                ),
                Divider(
                    height: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3)),
                Text('John Doe',
                    style: GoogleFonts.lato(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('License No: XYZ123456',
                    style: GoogleFonts.lato(fontSize: 18)),
                SizedBox(height: 5),
                Text('Class: Commercial',
                    style: GoogleFonts.lato(fontSize: 18)),
                SizedBox(height: 5),
                Text('Expires: 12/31/2024',
                    style: GoogleFonts.lato(
                        fontSize: 18, color: Colors.redAccent)),
                SizedBox(height: 10),
                Text('Mobile: +1-202-555-0178',
                    style: GoogleFonts.lato(fontSize: 18)),
                SizedBox(height: 5),
                Text('Truck Model: Freightliner Cascadia',
                    style: GoogleFonts.lato(fontSize: 18)),
                SizedBox(height: 5),
                Text('Plate No: 7BHV355',
                    style: GoogleFonts.lato(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
