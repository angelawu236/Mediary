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

  String _aliasFromUsername(String input) {
    final uname = input.trim().toLowerCase();
    final ok = RegExp(r'^[a-z0-9._-]{3,20}$').hasMatch(uname);
    if (!ok) throw FormatException('invalid-username');
    return '$uname@mediary.user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.bgColor,

      appBar: AppBar(
        backgroundColor: myColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: myColors.lightTextColor),
          onPressed: () {
            final route = cupertinoBackRoute(const LoginScreen());
            Navigator.of(context).pushReplacement(route);
          },
        ),
      ),

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
                  .copyWith(hintText: 'Enter your username'),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(height: 8.0),
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
            const SizedBox(height: 24.0),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      myColors.brightOutlineColor),
                  foregroundColor:
                  WidgetStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  final e = (email ?? '').trim();
                  final p = (password ?? '').trim();

                  if (e.isEmpty || p.isEmpty) {
                    setState(() => _error =
                    'Please enter both username and password.');
                    return;
                  }

                  String aliasEmail;
                  try {
                    aliasEmail = _aliasFromUsername(e);
                  } catch (_) {
                    setState(() => _error =
                    'Username must be 3–20 chars (letters, numbers, ., _, or -).');
                    return;
                  }

                  try {
                    setState(() => _error = null);
                    await _auth.createUserWithEmailAndPassword(
                      email: aliasEmail,
                      password: p,
                    );
                    final route = cupertinoForwardRoute(const Home());
                    if (mounted) Navigator.of(context).pushReplacement(route);
                  } on FirebaseAuthException catch (ex) {
                    String msg = 'Registration failed.';
                    if (ex.code == 'email-already-in-use') {
                      msg = 'That username is already taken.';
                    } else if (ex.code == 'weak-password') {
                      msg = 'Please choose a stronger password.';
                    }
                    setState(() => _error = msg);
                  } catch (_) {
                    setState(() => _error =
                    'Something went wrong. Please try again.');
                  }
                },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),

      // REMOVED: bottomNavigationBar "Register" button
    );
  }
}

