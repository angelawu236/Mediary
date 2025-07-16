import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'scaffold_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profile',
              style: TextStyle(
                color: myColors.darkTextColor,
                fontSize: 30,
              )),
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
              )


            ]
          ),

      ),
    );
  }
}

