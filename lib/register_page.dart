// import 'package:flutter/material.dart';

// class RegistrationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [Colors.greenAccent, Colors.blueAccent],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 FlutterLogo(size: 100),
//                 SizedBox(height: 50),
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Name',
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                       borderSide: BorderSide(),
//                     ),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 // Repeat the TextField and style for Email, Password, Confirm Password
//                 ElevatedButton(
//                   onPressed: () {
//                     // Registration logic
//                   },
//                   child: Text('Sign Up'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.white,
//                     onPrimary: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure MaterialApp uses ThemeData from Material 3
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple, Colors.indigo],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                buildTextField(icon: Icons.person, hintText: 'Full Name'),
                SizedBox(height: 20),
                buildTextField(icon: Icons.email, hintText: 'Email'),
                SizedBox(height: 20),
                buildTextField(icon: Icons.phone, hintText: 'Phone Number'),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.lock, hintText: 'Password', isPassword: true),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    isPassword: true),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Registration logic
                  },
                  child: Text('Register', style: GoogleFonts.inter()),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context); // Assuming this navigates back to the login screen
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required IconData icon,
      required String hintText,
      bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        fillColor: Colors.white24,
        filled: true,
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
