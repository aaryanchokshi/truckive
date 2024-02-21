import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure the file paths are correct
import 'register_page.dart';
import 'dashboard_page.dart';
import 'booking_screen.dart';
//import 'profile_page.dart';
//import 'settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define light theme colors
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue, // Use your brand color here
      brightness: Brightness.light,
    );

    // Define dark theme colors
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue, // Use your brand color here
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Truckive',
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
        colorScheme: lightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primaryContainer,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true, // Enable Material 3 for dark theme
        colorScheme: darkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.primaryContainer,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/booking': (context) => BookingScreen(),
        //'/profile': (context) => ProfileScreen(),
        //'/settings': (context) => SettingsScreen(),
      },
    );
  }
}
