import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter your email to receive a password reset link.",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset link sent.')));
                Navigator.of(context).pop();
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
