import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import '../scaffold_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emailController.clear();
    passwordController.clear();
    email = null;
    password = null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.bgColor,
        body: AppScaffoldWrapper(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: 200,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'images/appstore.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: constants.textFieldDecoration
                  .copyWith(hintText: 'Enter your email'),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: constants.textFieldDecoration
                  .copyWith(hintText: 'Enter your password'),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(
              height: 24.0,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      myColors.darkHighlightGoldColor),
                  foregroundColor:
                      WidgetStateProperty.all<Color>(myColors.darkTextColor),
                ),
                onPressed: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email!, password: password!);
                    Navigator.pushNamed(context, constants.RoutePaths.NavBar);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Log In'),
              ),
            ),
            const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('or'),
            )),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        myColors.darkHighlightGoldColor),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(myColors.darkTextColor),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, constants.RoutePaths.RegisterScreen);
                  },
                  child: const Text('Register')),
            )
          ],
        )));
  }
}
