import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mediary/app_styles.dart' as myColors;
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
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Profile',
              style: TextStyle(
                color: myColors.darkTextColor,
                fontSize: 30,
              )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Card(
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Text(
                      loggedInUser?.email ?? 'Not logged in',
                      style: const TextStyle(
                        fontSize: 15,
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          constants.RoutePaths.LoginScreen,
                              (route) => false,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            myColors.darkHighlightGoldColor),
                        foregroundColor: WidgetStateProperty.all<Color>(
                            myColors.darkTextColor),
                      ),
                      child: Text('Log Out')),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
