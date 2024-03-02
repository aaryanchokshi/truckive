import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:truckive/driver_details_page.dart';
import 'package:truckive/profile_page.dart';
import 'dart:convert';

import 'package:truckive/reports_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  int _currentIndex = 0;

  Future<LatLng?> _getCoordinates(String address) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$address&limit=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      if (results.isNotEmpty) {
        final lat = double.parse(results[0]["lat"]);
        final lon = double.parse(results[0]["lon"]);
        return LatLng(lat, lon);
      }
    }
    return null;
  }

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse(
        'https://routing.openstreetmap.de/routed-foot/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        adjustMapViewToFitRoute();
      });
    } else {
      print('Failed to load route');
    }
  }

  void adjustMapViewToFitRoute() {
    if (_routePoints.isEmpty) return;
    var bounds = LatLngBounds.fromPoints(_routePoints);
    _mapController.fitBounds(bounds,
        options: FitBoundsOptions(padding: EdgeInsets.all(50.0)));
  }

  //ThemeData theme;
  void _onFindRoutePressed() async {
    final startAddress = _pickupController.text;
    final endAddress = _dropController.text;
    final startCoords = await _getCoordinates(startAddress);
    final endCoords = await _getCoordinates(endAddress);
    if (startCoords != null && endCoords != null) {
      await _fetchRoute(startCoords, endCoords);
    }
  }

  @override
  Widget build(BuildContext context) {
    //theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            SizedBox(height: 10),
            _buildSearchBar(
                'Pick Up Location', Icons.location_pin, _pickupController),
            SizedBox(height: 10),
            _buildSearchBar('Drop Location', Icons.flag, _dropController),
            ElevatedButton(
                onPressed: _onFindRoutePressed, child: Text('Find Route')),
            SizedBox(height: 10),
            _buildMap(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Padding _buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Truckive',
            style: GoogleFonts.lato(
              //color: theme.colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          //IconButton(
          // icon: Icon(Icons.notifications, color: theme.colorScheme.onSurface),
          //onPressed: () {
          // Notification onPressed logic here
          // },
          //),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      String placeholder, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: controller,
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
        onSubmitted: (_) async {
          final start = await _getCoordinates(_pickupController.text);
          final end = await _getCoordinates(_dropController.text);
          if (start != null && end != null) {
            await _fetchRoute(start, end);
          }
        },
      ),
    );
  }

  Expanded _buildMap() {
    return Expanded(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(23.0261076, 72.5565443), // Initial center
          zoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 4.0,
                color: Color.fromARGB(255, 17, 122, 101),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.description), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
        }
        // backgroundColor: theme.colorScheme.background,
        // selectedItemColor: theme.colorScheme.primary,
        // unselectedItemColor: theme.colorScheme.onBackground,
        );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'driver_details_page.dart';
// import 'notification_page.dart'; // Ensure this points to your NotificationsPage
// import 'profile_page.dart';
// import 'reports_page.dart'; // Ensure this points to your TruckiveReportsPage

// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // App Bar
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Truckive',
//                     style: GoogleFonts.lato(
//                       color: theme.colorScheme.onSurface,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.notifications,
//                         color: theme.colorScheme.onSurface),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => NotificationsPage()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             // Search and Destination Input
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.0),
//               child: Column(
//                 children: [
//                   _buildSearchBar(
//                       context, 'Pick Up Location', Icons.location_pin),
//                   SizedBox(height: 10),
//                   _buildSearchBar(context, 'Drop Location', Icons.flag),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             // Map Placeholder
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surfaceVariant,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 margin: EdgeInsets.symmetric(horizontal: 16),
//                 width: double.infinity,
//                 child: Center(
//                   child: FlutterMap(
//                     options: MapOptions(
//                       initialCenter: LatLng(23.0261076, 72.5565443),
//                       initialZoom: 14,
//                     ),
//                     children: [
//                       TileLayer(
//                         urlTemplate:
//                             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                         userAgentPackageName: 'com.example.app',
//                       ),
//                       MarkerLayer(
//                         markers: [
//                           Marker(
//                             point: LatLng(23.0261076, 72.5565443),
//                             width: 80,
//                             height: 80,
//                             child: Image.network(
//                               'https://cdn-icons-png.flaticon.com/512/2344/2344094.png',
//                               width: 20,
//                               height: 20,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assessment),
//             label: 'Reports',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.description),
//             label: 'Details',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: 0, // this will be set when a new tab is tapped
//         onTap: (int index) {
//           switch (index) {
//             case 1: // Navigates to the Reports page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => TruckiveReportsPage()),
//               );
//               break;
//             case 2: // Navigates to the Details page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DriverDetailsPage()),
//               );
//               break;
//             case 3: // Navigates to the Profile page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfilePage()),
//               );
//               break;
//             // Implement navigation for the Home tab as needed
//           }
//         },
//         backgroundColor: theme.colorScheme.background,
//         selectedItemColor: theme.colorScheme.primary,
//         unselectedItemColor: theme.colorScheme.onBackground,
//       ),
//     );
//   }

//   Widget _buildSearchBar(
//       BuildContext context, String placeholder, IconData icon) {
//     return TextField(
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: placeholder,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//     );
//   }
// }
