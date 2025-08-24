import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import '../scaffold_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    Future<String> getAppVersion() async {
      final info = await PackageInfo.fromPlatform();
      return "${info.version}+${info.buildNumber}";
    }

    return Scaffold(
        backgroundColor: myColors.bgColor,
        body: AppScaffoldWrapper(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'images/appstore.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
                "Your media and watchlists, all in one place. Personal, customizable, and easy.",
                style: TextStyle(
                    color: myColors.brightOutlineColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: myColors.lightTextColor),
              controller: emailController,
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
              controller: passwordController,
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: constants.textFieldDecoration2
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
                      myColors.brightOutlineColor),
                  foregroundColor:
                      WidgetStateProperty.all<Color>(myColors.darkTextColor),
                ),
                onPressed: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email!, password: password!);
                    Navigator.pushNamed(context, constants.RoutePaths.Home);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Log In'),
              ),
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Text('or', style: TextStyle(color: myColors.lightTextColor)),
            )),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        myColors.brightOutlineColor),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(myColors.darkTextColor),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, constants.RoutePaths.RegisterScreen);
                  },
                  child: const Text('Register')),
            ),
          ],
        )),
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 24, // just enough for the text
          child: Center(
            child: FutureBuilder<String>(
              future: getAppVersion(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Text(
                  "Mediary v${snapshot.data}",
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                );
              },
            ),
          ),
        ),
      ),

    );
  }
}
