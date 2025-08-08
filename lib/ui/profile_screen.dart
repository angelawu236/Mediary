import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'all_media_screen.dart';
import 'animation.dart';
import 'scaffold_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediary/app_constants.dart' as constants;

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: myColors.lightTextColor,
            fontSize: 25,
          ),
        ),
        backgroundColor: myColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: myColors.lightTextColor,),
          onPressed: () {
            final route = cupertinoBackRoute(const Home());
            Navigator.of(context).pushReplacement(route); // or pushAndRemoveUntil(route, (_) => false)
          },
        ),
      ),
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              Card(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: myColors.darkGreenColor,
                    width: 1,
                  ),
                ),
                child: SizedBox(
                  width: 125,
                  height: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'images/profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Text(loggedInUser?.email ?? 'Not logged in',
              style: const TextStyle(
                fontSize: 17,
                color: myColors.brightOutlineColor,
              )),
          const SizedBox(
            height: 10.0,
          ),
        ]),
      ),
      bottomNavigationBar: SizedBox(
        height: 70, // tweak to your taste
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: myColors.brightOutlineColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.only(bottom: 7),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              constants.RoutePaths.LoginScreen,
              (route) => false,
            );
          },
          child: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
