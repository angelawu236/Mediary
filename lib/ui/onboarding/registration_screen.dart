import 'package:flutter/material.dart';
import 'package:mediary/ui/onboarding/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import '../all_media_screen.dart';
import '../animation.dart';
import '../scaffold_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  String? _error;

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
              style: TextStyle(color: myColors.lightTextColor),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: constants.textFieldDecoration2
                  .copyWith(hintText: 'Enter your email'),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(color: myColors.lightTextColor),
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: constants.textFieldDecoration2
                  .copyWith(hintText: 'Enter your password'),
              onChanged: (value) {
                password = value;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            const SizedBox(
              height: 24.0,
            ),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      myColors.brightOutlineColor),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  try {
                    final route = cupertinoBackRoute(const LoginScreen());
                    Navigator.of(context).pushReplacement(route);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Go Back'),
              ),
            )
          ],
        ),
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
            final e = (email ?? '').trim();
            final p = (password ?? '').trim();

            if (e.isEmpty || p.isEmpty) {
              setState(() => _error = 'Please enter both email and password.');
              return;
            }

            try {
              setState(() => _error = null);
              final user = await _auth.createUserWithEmailAndPassword(
                email: e,
                password: p,
              );
              final route = cupertinoForwardRoute(const Home());
              if (mounted) Navigator.of(context).pushReplacement(route);
            } on FirebaseAuthException catch (ex) {
              String msg = 'Registration failed. Your email may be already in use.';
              if (ex.code == 'invalid-email') msg = 'That email looks invalid.';
              else if (ex.code == 'email-already-in-use') msg = 'Email is already registered.';
              setState(() => _error = msg);
            } catch (_) {
              setState(() => _error = 'Something went wrong. Please try again.');
            }
          },
          child: const Text(
            'Register',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
