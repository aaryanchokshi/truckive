import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Make sure this import points to your actual login page

class RegistrationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> register(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog(context, 'Passwords do not match.');
      return;
    }

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(userCredential.user!.uid)
          .set({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
      });

      _showSuccessDialog(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again later.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }
      _showErrorDialog(context, errorMessage);
    }
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Successful'),
        content: Text('Your account has been created successfully.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                buildTextField(
                    icon: Icons.person,
                    hintText: 'Full Name',
                    controller: nameController),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.email,
                    hintText: 'Email',
                    controller: emailController),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.phone,
                    hintText: 'Phone Number',
                    controller: phoneController),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.lock,
                    hintText: 'Password',
                    controller: passwordController,
                    isPassword: true),
                SizedBox(height: 20),
                buildTextField(
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    controller: confirmPasswordController,
                    isPassword: true),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    await register(context);
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
      required TextEditingController controller,
      bool isPassword = false}) {
    return TextField(
      controller: controller,
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

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:truckive/login_page.dart';

// class RegistrationScreen extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [Colors.deepPurple, Colors.indigo],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'Sign Up',
//                   style: GoogleFonts.inter(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 buildTextField(
//                     icon: Icons.person,
//                     hintText: 'Full Name',
//                     controller: nameController),
//                 SizedBox(height: 20),
//                 buildTextField(
//                     icon: Icons.email,
//                     hintText: 'Email',
//                     controller: emailController),
//                 SizedBox(height: 20),
//                 buildTextField(
//                     icon: Icons.phone,
//                     hintText: 'Phone Number',
//                     controller: phoneController),
//                 SizedBox(height: 20),
//                 buildTextField(
//                     icon: Icons.lock,
//                     hintText: 'Password',
//                     controller: passwordController,
//                     isPassword: true),
//                 SizedBox(height: 20),
//                 buildTextField(
//                     icon: Icons.lock,
//                     hintText: 'Confirm Password',
//                     controller: confirmPasswordController,
//                     isPassword: true),
//                 SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await register(context);
//                   },
//                   child: Text('Register', style: GoogleFonts.inter()),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.white,
//                     onPrimary: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(
//                         context); // Assuming this navigates back to the login screen
//                   },
//                   child: Text(
//                     'Already have an account? Login',
//                     style: GoogleFonts.inter(
//                       color: Colors.white,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       {required IconData icon,
//       required String hintText,
//       required TextEditingController controller,
//       bool isPassword = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: Colors.white70),
//         fillColor: Colors.white24,
//         filled: true,
//         prefixIcon: Icon(icon, color: Colors.white70),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Future<void> register(BuildContext context) async {
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showErrorDialog(context, 'Email and password cannot be empty.');
//       return;
//     }

//     if (password != confirmPasswordController.text.trim()) {
//       _showErrorDialog(context, 'Passwords do not match.');
//       return;
//     }

//     try {
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       // Registration successful, navigate to another screen
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         _showErrorDialog(context, 'The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         _showErrorDialog(context, 'The account already exists for that email.');
//       } else {
//         _showErrorDialog(context, 'Registration failed. Please try again.');
//       }
//     } catch (e) {
//       _showErrorDialog(context, 'An unexpected error occurred.');
//     }
//   }

//   Future<void> _showErrorDialog(BuildContext context, String errorMessage) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Registration Failed'),
//           content: Text(errorMessage),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:truckive/login_page.dart';

// // class RegistrationScreen extends StatefulWidget {
// //   const RegistrationScreen({Key? key}) : super(key: key);

// //   @override
// //   RegisterPage createState() => RegisterPage();
// // }

// // // final TextEditingController _nameController = TextEditingController();

// // class RegisterPage extends State<RegistrationScreen> {
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController confirmPasswordController =
// //       TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();

// //   @override
// //   void dispose() {
// //     emailController.dispose();
// //     passwordController.dispose();
// //     super.dispose();
// //   }

// //   Widget build(BuildContext context) {
// //     Future<void> _showSuccessDialog() async {
// //       return showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Registration Successful'),
// //             content: Text('Your account has been created successfully.'),
// //             actions: <Widget>[
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                   // Navigator.pushNamed(context, 'login');
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     }

// //     Future<void> _showErrorDialog(String errorMessage) async {
// //       return showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Registration Failed'),
// //             content: Text(errorMessage),
// //             actions: <Widget>[
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     }

// //     Future<bool> createUser(email, password) async {
// //       try {
// //         // ignore: unused_local_variable
// //         final User = await FirebaseAuth.instance.createUserWithEmailAndPassword(
// //           email: email,
// //           password: password,
// //         );
// //       } on FirebaseAuthException catch (e) {
// //         if (e.code == 'weak-password') {
// //           print('The password provided is too weak.');
// //           await _showErrorDialog('The password provided is too weak.');
// //         } else if (e.code == 'email-already-in-use') {
// //           print('The account already exists for that email.');
// //           await _showErrorDialog('The account already exists for that email');
// //         }
// //       }
// //       // catch (e) {
// //       //   await _showErrorDialog('Error: $e');
// //       // }

// //       if (FirebaseAuth.instance.currentUser != null) {
// //         await FirebaseAuth.instance.signOut();
// //         return true;
// //       } else {
// //         return false;
// //       }
// //     }

// //     Future<void> register() async {
// //       final email = emailController.text;
// //       final password = passwordController.text;
// //       try {
// //         final userCreated = await createUser(email, password);
// //         if (userCreated) {
// //           await _showSuccessDialog();
// //           Navigator.push(
// //               context, MaterialPageRoute(builder: (context) => LoginPage()));
// //         } else {
// //           print('Error in else');
// //           _showErrorDialog("error");
// //         }
// //         //dispose();
// //       } catch (e) {
// //         print(e);
// //         print("in catch");
// //       }
// //     }

// //     return Scaffold(
// //       body: Container(
// //         padding: EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topRight,
// //             end: Alignment.bottomLeft,
// //             colors: [Colors.deepPurple, Colors.indigo],
// //           ),
// //         ),
// //         child: Center(
// //           child: SingleChildScrollView(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 Text(
// //                   'Sign Up',
// //                   style: GoogleFonts.inter(
// //                     fontSize: 30,
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 30),
// //                 buildTextField(
// //                     icon: Icons.person,
// //                     hintText: 'Full Name',
// //                     controller: _nameController),
// //                 SizedBox(height: 20),
// //                 buildTextField(
// //                     icon: Icons.email,
// //                     hintText: 'Email',
// //                     controller: emailController),
// //                 SizedBox(height: 20),
// //                 buildTextField(
// //                     icon: Icons.phone,
// //                     hintText: 'Phone Number',
// //                     controller: phoneController),
// //                 SizedBox(height: 20),
// //                 buildTextField(
// //                     icon: Icons.lock,
// //                     hintText: 'Password',
// //                     controller: passwordController,
// //                     isPassword: true),
// //                 SizedBox(height: 20),
// //                 buildTextField(
// //                     icon: Icons.lock,
// //                     hintText: 'Confirm Password',
// //                     controller: confirmPasswordController,
// //                     isPassword: true),
// //                 SizedBox(height: 40),
// //                 ElevatedButton(
// //                   onPressed: () async {
// //                     await register();
// //                   },
// //                   child: Text('Register', style: GoogleFonts.inter()),
// //                   style: ElevatedButton.styleFrom(
// //                     primary: Colors.white,
// //                     onPrimary: Colors.deepPurple,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(20.0),
// //                     ),
// //                     padding:
// //                         EdgeInsets.symmetric(horizontal: 100, vertical: 15),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () {
// //                     Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) =>
// //                                 LoginPage())); // Assuming this navigates back to the login screen
// //                   },
// //                   child: Text(
// //                     'Already have an account? Login',
// //                     style: GoogleFonts.inter(
// //                       color: Colors.white,
// //                       decoration: TextDecoration.underline,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildTextField(
// //       {required IconData icon,
// //       required String hintText,
// //       required TextEditingController controller,
// //       bool isPassword = false}) {
// //     return TextField(
// //       controller: controller,
// //       obscureText: isPassword,
// //       style: TextStyle(color: Colors.white),
// //       decoration: InputDecoration(
// //         hintText: hintText,
// //         hintStyle: TextStyle(color: Colors.white70),
// //         fillColor: Colors.white24,
// //         filled: true,
// //         prefixIcon: Icon(icon, color: Colors.white70),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(25.0),
// //           borderSide: BorderSide.none,
// //         ),
// //       ),
// //     );
// //   }
// // }
// // //   Widget buildTextField(
// // //       {required IconData icon,
// // //       required String hintText,
// // //       bool isPassword = false}) {
// // //     return TextField(
// // //       obscureText: isPassword,
// // //       style: TextStyle(color: Colors.white),
// // //       decoration: InputDecoration(
// // //         hintText: hintText,
// // //         hintStyle: TextStyle(color: Colors.white70),
// // //         fillColor: Colors.white24,
// // //         filled: true,
// // //         prefixIcon: Icon(icon, color: Colors.white70),
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(25.0),
// // //           borderSide: BorderSide.none,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // // import 'package:flutter/material.dart';

// // // class RegistrationScreen extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Container(
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             begin: Alignment.topRight,
// // //             end: Alignment.bottomLeft,
// // //             colors: [Colors.greenAccent, Colors.blueAccent],
// // //           ),
// // //         ),
// // //         child: Center(
// // //           child: SingleChildScrollView(
// // //             padding: const EdgeInsets.all(20.0),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: <Widget>[
// // //                 FlutterLogo(size: 100),
// // //                 SizedBox(height: 50),
// // //                 TextField(
// // //                   decoration: InputDecoration(
// // //                     hintText: 'Name',
// // //                     fillColor: Colors.white,
// // //                     filled: true,
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(25.0),
// // //                       borderSide: BorderSide(),
// // //                     ),
// // //                     prefixIcon: Icon(Icons.person),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 20),
// // //                 // Repeat the TextField and style for Email, Password, Confirm Password
// // //                 ElevatedButton(
// // //                   onPressed: () {
// // //                     // Registration logic
// // //                   },
// // //                   child: Text('Sign Up'),
// // //                   style: ElevatedButton.styleFrom(
// // //                     primary: Colors.white,
// // //                     onPrimary: Colors.black,
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(18.0),
// // //                     ),
// // //                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
