import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truckive/register_page.dart';
import 'dashboard_page.dart';
import 'forget_password_page.dart';
//import 'registration_.dart'; // Import the registration screen

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Future<void> _showSuccessDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Successful'),
            content: Text('You have been logged in Successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, 'dashboard');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _showErrorDialog(String errorMessage) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    Future<bool> getUser(email, password) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await _showErrorDialog('No user found for that email.');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          await _showErrorDialog('Wrong password provided for that user.');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        await _showErrorDialog("Login Failed");
      }

      if (FirebaseAuth.instance.currentUser != null) {
        return true;
      } else {
        return false;
      }
    }

    Future<void> login() async {
      final email = emailController.text;
      final password = passwordController.text;

      final userCreated = await getUser(email, password);
      if (userCreated) {
        await _showSuccessDialog();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        print('Error');
        _showErrorDialog("error");
      }
      //dispose();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blueAccent, Colors.redAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 100),
                SizedBox(height: 50),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    // labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await login();
                  },
                  //
                  //() {
                  //   // Login logic

                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DashboardScreen()),
                  //   );
                  // },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text('Don’t have an account? Sign up',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text('Forgot Password?',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  // import 'package:flutter/material.dart';
  // import 'package:truckive/dashboard_page.dart';

  // import 'register_page.dart';

  // class LoginScreen extends StatefulWidget {
  //   @override
  //   _LoginScreenState createState() => _LoginScreenState();
  // }

  // class _LoginScreenState extends State<LoginScreen> {
  //   final _emailController = TextEditingController();
  //   final _passwordController = TextEditingController();

  //   @override
  //   void dispose() {
  //     _emailController.dispose();
  //     _passwordController.dispose();
  //     super.dispose();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Login'),
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: _emailController,
  //               decoration: InputDecoration(
  //                 labelText: 'Email',
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.email),
  //               ),
  //               keyboardType: TextInputType.emailAddress,
  //             ),
  //             SizedBox(height: 20),
  //             TextField(
  //               controller: _passwordController,
  //               decoration: InputDecoration(
  //                 labelText: 'Password',
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.lock),
  //               ),
  //               obscureText: true,
  //             ),
  //             SizedBox(height: 30),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Implement login logic
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => DashboardScreen()),
  //                 );
  //               },
  //               child: Text('Login'),
  //               style: ElevatedButton.styleFrom(
  //                 minimumSize: Size(double.infinity,
  //                     50), // double.infinity is the width and 50 is the height
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 // Navigate to the registration screen
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) =>
  //                           RegistrationPage()), // Assuming RegistrationScreen() is your registration screen class
  //                 );
  //               },
  //               child: Text('Don’t have an account? Sign up'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
