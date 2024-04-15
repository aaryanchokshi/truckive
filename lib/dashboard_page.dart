import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:truckive/notification_page.dart';
import 'dart:convert';

import 'driver_details_page.dart';
import 'help_support_page.dart';
import 'profile_page.dart';
import 'reports_page.dart';
import 'settings_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  final String orderId;

  const DashboardScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

enum DriverJourneyPhase {
  headingToPickup,
  headingToDropOff,
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final TextEditingController _pickupController = TextEditingController();
  // final TextEditingController _dropController = TextEditingController();
  String _pickupLocation = '';
  String _dropOffLocation = '';
  bool _isLoading = true;
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  int _currentIndex = 0;
  List<String> _suggestions = [];
  List<String> _suggestions1 = [];
  Timer? _locationUpdateTimer;
  List<Marker> _markers = [];
  bool _isSlideCardVisible = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isPickupNotified = false;
  bool _isDropOffNotified = false;
  LatLng _pickupCityCenter =
      LatLng(0, 0); // Placeholder for the actual location
  LatLng _dropOffCityCenter = LatLng(0, 0);
  DriverJourneyPhase _currentPhase =
      DriverJourneyPhase.headingToPickup; // Add this to your class variables

  @override
  void initState() {
    super.initState();
    _fetchDriverLocationPeriodically();
    fetchOrderLocations();
    _onFindRoutePressed();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'app_icon'); // Ensure you have an app icon
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  // void initNotifications() {
  //   var androidInitialize = new AndroidInitializationSettings('app_icon');
  //   var initializationSettings =
  //       InitializationSettings(android: androidInitialize);
  //   localNotificationsPlugin.initialize(initializationSettings);
  // }

  // Future<void> showNotification(String title, String body) async {
  //   var androidDetails = new AndroidNotificationDetails(
  //     "Channel ID",
  //     "Descriptive channel name",
  //     channelDescription: "Channel Description",
  //     importance: Importance.high,
  //   );
  //   var generalNotificationDetails =
  //       NotificationDetails(android: androidDetails);

  //   await localNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     generalNotificationDetails,
  //   );
  // }

  // Future<void> fetchOrderLocations() async {
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   final snapshot =
  //       await databaseReference.child('orders/${widget.orderId}').get();

  //   if (snapshot.exists && snapshot.value != null) {
  //     final orderData = Map<String, dynamic>.from(snapshot.value as Map);
  //     final pickupLocation = orderData['pickupLocation'];
  //     final dropOffLocation = orderData['dropOffLocation'];

  //     setState(() {
  //       _isLoading = false;
  //       _pickupLocation = pickupLocation ?? 'No pickup location found';
  //       _dropOffLocation = dropOffLocation ?? 'No drop-off location found';
  //     });
  //   } else {
  //     // Handle the case where the order ID doesn't exist or has no locations
  //     setState(() {
  //       _isLoading = false;
  //       _pickupLocation = 'Order details not found';
  //       _dropOffLocation = 'Order details not found';
  //     });
  //   }
  // }

  // Future<void> fetchOrderLocations() async {
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   final snapshot =
  //       await databaseReference.child('orders/${widget.orderId}').get();

  //   if (snapshot.exists && snapshot.value != null) {
  //     final orderData = Map<String, dynamic>.from(snapshot.value as Map);
  //     final pickupLocation = orderData['pickupLocation'];
  //     final dropOffLocation = orderData['dropOffLocation'];

  //     setState(() {
  //       _isLoading = false;
  //       _pickupLocation = pickupLocation ?? 'No pickup location found';
  //       _dropOffLocation = dropOffLocation ?? 'No drop-off location found';
  //     });

  //     // Show notification that the driver has started the journey
  //     showNotification("Journey Started",
  //         "The driver has started the journey from $pickupLocation.");

  //     // Simulate the driver reaching the drop-off location
  //     // In a real app, this would be based on real-time tracking data
  //     Future.delayed(Duration(seconds: 10), () {
  //       showNotification("Journey Completed",
  //           "The driver has reached the drop-off location at $dropOffLocation.");
  //     });
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //       _pickupLocation = 'Order details not found';
  //       _dropOffLocation = 'Order details not found';
  //     });
  //   }
  // }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  // Method to check proximity and notify
  Future<void> _checkProximityAndNotify(LatLng driverLocation) async {
    const double nearDistanceThreshold =
        1000; // Adjust according to your preference, meters.

    // Calculating distances from the driver's current location to pickup and drop-off locations.
    double distanceToPickup = Geolocator.distanceBetween(
      driverLocation.latitude,
      driverLocation.longitude,
      _pickupCityCenter.latitude,
      _pickupCityCenter.longitude,
    );

    double distanceToDropOff = Geolocator.distanceBetween(
      driverLocation.latitude,
      driverLocation.longitude,
      _dropOffCityCenter.latitude,
      _dropOffCityCenter.longitude,
    );

    // Logic to determine whether to send a notification based on the driver's journey phase.
    if (!_isPickupNotified && distanceToPickup <= nearDistanceThreshold) {
      // Notify for approaching the pickup location.
      await showNotification(
          "Approaching Pickup", "You are nearing the pickup location.");
      _isPickupNotified = true; // Prevent repeating the notification.
      _currentPhase =
          DriverJourneyPhase.headingToDropOff; // Update journey phase.
    } else if (!_isDropOffNotified &&
        distanceToDropOff <= nearDistanceThreshold &&
        _currentPhase == DriverJourneyPhase.headingToDropOff) {
      // Notify for approaching the drop-off location.
      await showNotification(
          "Approaching Drop-Off", "You are nearing the drop-off location.");
      _isDropOffNotified = true; // Prevent repeating the notification.
    }
  }

  Future<void> fetchOrderLocations() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final snapshot =
        await databaseReference.child('orders/${widget.orderId}').get();

    if (snapshot.exists && snapshot.value != null) {
      final orderData = Map<String, dynamic>.from(snapshot.value as Map);
      final pickupLocation = orderData['pickupLocation'];
      final dropOffLocation = orderData['dropOffLocation'];

      setState(() {
        _isLoading = false;
        _pickupLocation = pickupLocation ?? 'No pickup location found';
        _dropOffLocation = dropOffLocation ?? 'No drop-off location found';
      });

      // Placeholder: Simulate driver's location being near the pickup and drop-off locations
      // In a real application, you would use the driver's actual GPS location.
      // Here we just simulate the notification by calling the method after a delay.
      // Timer(Duration(seconds: 5), () async {
      //   // Assuming the driver is near the pickup location.
      //   await _checkProximityAndNotify(_pickupCityCenter);

      //   // Simulate the driver moving towards the drop-off location after another delay.
      //   Timer(Duration(minutes: 1), () async {
      //     await _checkProximityAndNotify(_dropOffCityCenter);
      //   });
      // });
      _fetchDriverLocationPeriodically();
    } else {
      setState(() {
        _isLoading = false;
        _pickupLocation = 'Order details not found';
        _dropOffLocation = 'Order details not found';
      });
    }
  }

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
    final startAddress = _pickupLocation;
    final endAddress = _dropOffLocation;
    final startCoords = await _getCoordinates(startAddress);
    final endCoords = await _getCoordinates(endAddress);
    if (startCoords != null && endCoords != null) {
      await _fetchRoute(startCoords, endCoords);
    }
  }

  Future<List> fetchAutoCompleteSuggestions(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List suggestions =
            data.map((result) => result['display_name']).toList();
        return suggestions.take(1).toList();
      } else {
        print(
            'Failed to fetch autocomplete suggestions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching autocomplete suggestions: $e');
      return [];
    }
  }

  Future<void> _suggestLocations(
      String input, TextEditingController controller) async {
    if (input.isEmpty) {
      return;
    }

    try {
      List<String> suggestions =
          (await fetchAutoCompleteSuggestions(input)).cast<String>();
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      print('Error suggesting locations: $e');
    }
  }

  Future<List> fetchAutoCompleteSuggestions1(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List suggestions1 =
            data.map((result) => result['display_name']).toList();
        return suggestions1.take(1).toList();
      } else {
        print(
            'Failed to fetch autocomplete suggestions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching autocomplete suggestions: $e');
      return [];
    }
  }

  Future<void> _suggestLocations1(
      String input, TextEditingController controller) async {
    if (input.isEmpty) {
      return;
    }

    try {
      List<String> suggestions1 =
          (await fetchAutoCompleteSuggestions1(input)).cast<String>();
      setState(() {
        _suggestions1 = suggestions1;
      });
    } catch (e) {
      print('Error suggesting locations: $e');
    }
  }

  Future<LatLng?> _fetchDriverLocation(String driverId) async {
    const String firebaseProjectId = 'truckive-driver-default-rtdb';
    String url =
        'https://$firebaseProjectId.firebaseio.com/driverLocation/g5vLlEYtYWf5JNRg7uK12Riearx1.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LatLng(data['latitude'], data['longitude']);
      } else {
        print('Failed to load driver location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching driver location: $e');
    }
    return null;
  }

  void _fetchDriverLocationPeriodically() {
    const String driverId =
        'g5vLlEYtYWf5JNRg7uK12Riearx1'; // Replace with the actual driver ID
    const duration = Duration(seconds: 5); // Fetch every 30 seconds
    _locationUpdateTimer = Timer.periodic(duration, (Timer timer) async {
      final LatLng? driverLocation = await _fetchDriverLocation(driverId);
      if (driverLocation != null) {
        _updateMapWithDriverLocation(driverLocation);
        await _checkProximityAndNotify(driverLocation);
      }
    });
  }

  void _updateMapWithDriverLocation(LatLng location) {
    setState(() {
      _markers = [
        Marker(
          width: 80,
          height: 80,
          point: location,
          child: Icon(Icons.local_shipping, color: Colors.blue, size: 40),
        ),
      ];
      // Move the map center to the new driver location.
      _mapController.move(location, _mapController.zoom);
    });
  }

  void _showTruckSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Small Truck'),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpSupportPage()));
                  },
                ),
                ElevatedButton(
                  child: const Text('Medium Truck'),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
                ElevatedButton(
                  child: const Text('Large Truck'),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            // SizedBox(height: 10),
            // _buildSearchBar(
            //     'Pick Up Location', Icons.location_pin, _pickupController),
            // SizedBox(height: 10),
            // _buildSearchBar1('Drop Location', Icons.flag, _dropController),
            ElevatedButton(
                onPressed: _onFindRoutePressed, child: Text('Get Live Status')),
            SizedBox(height: 10),
            _buildMap(),
            //_buildSlidingCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSlidingCard() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      bottom: _isSlideCardVisible ? 0 : -100, // Slide up effect
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _truckSelectionButton('Small', Icons.local_shipping),
            _truckSelectionButton('Medium', Icons.local_shipping),
            _truckSelectionButton('Large', Icons.local_shipping),
          ],
        ),
      ),
    );
  }

  Widget _truckSelectionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(label),
      onPressed: () {
        // Handle truck selection here
        print('$label truck selected');
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Background color
        onPrimary: Colors.white, // Text color
      ),
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
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      String placeholder, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: placeholder,
              prefixIcon: Icon(icon, color: Colors.black),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    _suggestions = [];
                  });
                },
              ),
            ),
            onChanged: (input) {
              _suggestLocations(input, controller);
            },
          ),
          SizedBox(height: 10),
          if (_suggestions.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      // Handle selection of suggestion
                      controller.text = _suggestions[index];
                      setState(() {
                        _suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar1(
      String placeholder, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: placeholder,
              prefixIcon: Icon(icon, color: Colors.black),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    _suggestions = [];
                  });
                },
              ),
            ),
            onChanged: (input) {
              _suggestLocations1(input, controller);
            },
          ),
          SizedBox(height: 10),
          if (_suggestions1.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions1.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions1[index]),
                    onTap: () {
                      // Handle selection of suggestion
                      controller.text = _suggestions1[index];
                      setState(() {
                        _suggestions1 = [];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ],
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
                color: Color.fromARGB(255, 70, 62, 62),
              ),
            ],
          ),
          MarkerLayer(
            markers: _markers,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point:
                    _routePoints.isNotEmpty ? _routePoints.first : LatLng(0, 0),
                width: 80,
                height: 80,
                child: Icon(Icons.location_pin,
                    color: const Color.fromARGB(255, 34, 105, 36)),
              ),
              Marker(
                point:
                    _routePoints.isNotEmpty ? _routePoints.last : LatLng(0, 0),
                width: 80,
                height: 80,
                child: Icon(Icons.location_pin, color: Colors.red),
              ),
            ],
          )
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
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;
// import 'test.dart';

// class DashboardScreen extends StatefulWidget {
//   final String orderId;

//   const DashboardScreen({Key? key, required this.orderId}) : super(key: key);

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final MapController _mapController = MapController();
//   List<Marker> _markers = [];
//   bool _isLoading = true; // Added to indicate loading state
//   List<LatLng> _routePoints = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchOrderDetails();
//   }

//   Future<void> _fetchRoute(LatLng start, LatLng end) async {
//     final response = await http.get(Uri.parse(
//         'https://routing.openstreetmap.de/routed-foot/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> coordinates =
//           data['routes'][0]['geometry']['coordinates'];
//       setState(() {
//         _routePoints =
//             coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
//         adjustMapViewToFitRoute();
//       });
//     } else {
//       print('Failed to load route');
//     }
//   }

//   void adjustMapViewToFitRoute() {
//     if (_routePoints.isEmpty) return;
//     var bounds = LatLngBounds.fromPoints(_routePoints);
//     _mapController.fitBounds(bounds,
//         options: FitBoundsOptions(padding: EdgeInsets.all(50.0)));
//   }

//   Future<void> fetchOrderDetails() async {
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final snapshot =
//         await databaseReference.child('orders/${widget.orderId}').get();
//     if (snapshot.exists) {
//       final orderData = Map<String, dynamic>.from(snapshot.value as Map);
//       final pickupLocation = _convertToLatLng(orderData['pickupLocation']);
//       final dropOffLocation = _convertToLatLng(orderData['dropOffLocation']);

//       if (pickupLocation != null && dropOffLocation != null) {
//         setState(() {
//           _markers = [
//             Marker(
//               point: pickupLocation,
//               child: Icon(Icons.location_on, color: Colors.green),
//             ),
//             Marker(
//               point: dropOffLocation,
//               child: Icon(Icons.location_on, color: Colors.red),
//             ),
//           ];
//           _isLoading = false; // Data loaded, stop showing loading indicator
//           // Move the map to show the markers
//           _mapController.move(pickupLocation, 12);
//         });
//       }
//     }
//   }

//   LatLng? _convertToLatLng(String locationStr) {
//     try {
//       final parts = locationStr.split(',');
//       if (parts.length == 2) {
//         return LatLng(double.parse(parts[0]), double.parse(parts[1]));
//       }
//     } catch (e) {
//       print("Error converting location string to LatLng: $e");
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center:
//                     _markers.isNotEmpty ? _markers.first.point : LatLng(0, 0),
//                 zoom: 12.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(markers: _markers),
//               ],
//             ),
//     );
//   }
// }
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;

// class DashboardScreen extends StatefulWidget {
//   final String orderId;

//   const DashboardScreen({Key? key, required this.orderId}) : super(key: key);

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String _pickupLocation = '';
//   String _dropOffLocation = '';
//   bool _isLoading = true;
//   List<LatLng> _routePoints = [];
//   final MapController _mapController = MapController();
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchOrderLocations();
//     _onFindRoutePressed();
//   }

//   void _onFindRoutePressed() async {
//     final startAddress = _pickupLocation;
//     final endAddress = _dropOffLocation;
//     final startCoords = await _getCoordinates(startAddress);
//     final endCoords = await _getCoordinates(endAddress);
//     if (startCoords != null && endCoords != null) {
//       await _fetchRoute(startCoords, endCoords);
//     }
//   }

//   Future<LatLng?> _getCoordinates(String address) async {
//     final url = Uri.parse(
//         'https://nominatim.openstreetmap.org/search?format=json&q=$address&limit=1');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final results = json.decode(response.body);
//       if (results.isNotEmpty) {
//         final lat = double.parse(results[0]["lat"]);
//         final lon = double.parse(results[0]["lon"]);
//         return LatLng(lat, lon);
//       }
//     }
//     return null;
//   }

//   Future<void> _fetchRoute(LatLng start, LatLng end) async {
//     final response = await http.get(Uri.parse(
//         'https://routing.openstreetmap.de/routed-foot/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> coordinates =
//           data['routes'][0]['geometry']['coordinates'];
//       setState(() {
//         _routePoints =
//             coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
//         adjustMapViewToFitRoute();
//       });
//     } else {
//       print('Failed to load route');
//     }
//   }

//   void adjustMapViewToFitRoute() {
//     if (_routePoints.isEmpty) return;
//     var bounds = LatLngBounds.fromPoints(_routePoints);
//     _mapController.fitBounds(bounds,
//         options: FitBoundsOptions(padding: EdgeInsets.all(50.0)));
//   }

//   Future<void> fetchOrderLocations() async {
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final snapshot =
//         await databaseReference.child('orders/${widget.orderId}').get();

//     if (snapshot.exists && snapshot.value != null) {
//       final orderData = Map<String, dynamic>.from(snapshot.value as Map);
//       final pickupLocation = orderData['pickupLocation'];
//       final dropOffLocation = orderData['dropOffLocation'];

//       setState(() {
//         _isLoading = false;
//         _pickupLocation = pickupLocation ?? 'No pickup location found';
//         _dropOffLocation = dropOffLocation ?? 'No drop-off location found';
//       });
//     } else {
//       // Handle the case where the order ID doesn't exist or has no locations
//       setState(() {
//         _isLoading = false;
//         _pickupLocation = 'Order details not found';
//         _dropOffLocation = 'Order details not found';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //theme = Theme.of(context);
//     return Scaffold(
//       body: SafeArea(
//         child: FlutterMap(
//           mapController: _mapController,
//           options: MapOptions(
//             center: LatLng(23.0261076, 72.5565443), // Initial center
//             zoom: 14,
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               subdomains: ['a', 'b', 'c'],
//             ),
//             PolylineLayer(
//               polylines: [
//                 Polyline(
//                   points: _routePoints,
//                   strokeWidth: 4.0,
//                   color: Color.fromARGB(255, 70, 62, 62),
//                 ),
//               ],
//             ),
//             MarkerLayer(
//               markers: _markers,
//             ),
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: _routePoints.isNotEmpty
//                       ? _routePoints.first
//                       : LatLng(0, 0),
//                   width: 80,
//                   height: 80,
//                   child: Icon(Icons.location_pin,
//                       color: const Color.fromARGB(255, 34, 105, 36)),
//                 ),
//                 Marker(
//                   point: _routePoints.isNotEmpty
//                       ? _routePoints.last
//                       : LatLng(0, 0),
//                   width: 80,
//                   height: 80,
//                   child: Icon(Icons.location_pin, color: Colors.red),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
