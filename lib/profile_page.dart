import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'EditProfilePage.dart';
import 'help_support_page.dart';
import 'settings_screen.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  // Future<void> getFullName(String userId) async {
  //   // Get a reference to the Firebase Realtime Database
  //   // Get a reference to the Firebase Realtime Database
  //   DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  //   try {
  //     // Retrieve the user data using the user ID
  //     DataSnapshot dataSnapshot =
  //         await databaseReference.child(userId).once() as DataSnapshot;

  //     // Check if data exists for the given user ID
  //     if (dataSnapshot.value != null) {
  //       // Cast dataSnapshot.value to a Map<String, dynamic>
  //       Map<String, dynamic>? userData =
  //           dataSnapshot.value as Map<String, dynamic>?;

  //       // Check if userData is not null and contains the 'fullName' key
  //       if (userData != null && userData.containsKey('fullName')) {
  //         // Get the full name from the user data
  //         String fullName = userData['fullName'];

  //         // Use the full name as needed
  //         print('Full Name: $fullName');
  //         // return fullName;
  //       } else {
  //         print('Full Name not found');
  //       }
  //     } else {
  //       print('User not found');
  //     }
  //   } catch (error) {
  //     print('Error retrieving user data: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // getFullName('kCEhqoxiA7Yehk2ZB4klZfzcqeI2');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                      'assets/userimage.webp'), // Correct way to set the image
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 20),
                // Display name and email of the logged-in user
                Text(user?.displayName ?? 'User',
                    style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
                SizedBox(height: 10),
                Text(user?.email ?? 'No Email',
                    style: GoogleFonts.lato(
                        fontSize: 18, color: Colors.grey[600])),
                SizedBox(height: 20),
                _buildProfileOption(context, 'Edit Profile', Icons.edit, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                }),
                _buildProfileOption(context, 'Settings', Icons.settings, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                }),
                _buildProfileOption(context, 'Help & Support', Icons.help, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelpSupportPage()));
                }),
                _buildProfileOption(context, 'Log Out', Icons.exit_to_app,
                    () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: GoogleFonts.lato(fontSize: 20)),
        onTap: onTap,
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:truckive/login_page.dart';
// import 'EditProfilePage.dart';
// //import 'edit_profile_page.dart';
// //import 'settings_page.dart';
// import 'help_support_page.dart';
// import 'settings_screen.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile', style: GoogleFonts.lato()),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage: AssetImage(
//                       'assets/userimage.webp'), // Correct way to set the image
//                   backgroundColor: Colors.transparent,
//                 ),
//                 SizedBox(height: 20),
//                 Text('Alex Johnson',
//                     style: GoogleFonts.lato(
//                         fontSize: 24, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 Text('alex.johnson@example.com',
//                     style: GoogleFonts.lato(
//                         fontSize: 18, color: Colors.grey[600])),
//                 SizedBox(height: 20),
//                 _buildProfileOption(context, 'Edit Profile', Icons.edit, () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => EditProfilePage()));
//                 }),
//                 _buildProfileOption(context, 'Settings', Icons.settings, () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => SettingsPage()));
//                 }),
//                 _buildProfileOption(context, 'Help & Support', Icons.help, () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => HelpSupportPage()));
//                 }),
//                 _buildProfileOption(context, 'Log Out', Icons.exit_to_app,
//                     () async {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => LoginPage()));
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileOption(
//       BuildContext context, String title, IconData icon, VoidCallback onTap) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
//         title: Text(title, style: GoogleFonts.lato(fontSize: 20)),
//         onTap: onTap,
//       ),
//     );
//   }
// }
