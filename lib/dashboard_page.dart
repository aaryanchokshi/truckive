import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'driver_details_page.dart';
import 'notification_page.dart'; // Ensure this points to your NotificationsPage
import 'profile_page.dart';
import 'reports_page.dart'; // Ensure this points to your TruckiveReportsPage

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Truckive',
                    style: GoogleFonts.lato(
                      color: theme.colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications,
                        color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Search and Destination Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  _buildSearchBar(
                      context, 'Pick Up Location', Icons.location_pin),
                  SizedBox(height: 10),
                  _buildSearchBar(context, 'Drop Location', Icons.flag),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Map Placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: Center(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(23.0261076, 72.5565443),
                      initialZoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(23.0261076, 72.5565443),
                            width: 80,
                            height: 80,
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/2344/2344094.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // this will be set when a new tab is tapped
        onTap: (int index) {
          switch (index) {
            case 1: // Navigates to the Reports page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TruckiveReportsPage()),
              );
              break;
            case 2: // Navigates to the Details page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverDetailsPage()),
              );
              break;
            case 3: // Navigates to the Profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
            // Implement navigation for the Home tab as needed
          }
        },
        backgroundColor: theme.colorScheme.background,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onBackground,
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, String placeholder, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: placeholder,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
