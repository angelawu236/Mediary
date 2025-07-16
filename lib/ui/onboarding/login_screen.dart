import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import '../scaffold_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // String? email;
  // String? password;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(child: Column(
        children: [
          Text('login here'),
          TextField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,

          )
        ],
      ))
    );
  }
}
