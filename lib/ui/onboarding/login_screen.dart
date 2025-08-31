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

  String? _error;

  String _aliasFromUsername(String input) {
    final uname = input.trim().toLowerCase();
    final ok = RegExp(r'^[a-z0-9._-]{3,20}$').hasMatch(uname); // 3–20 chars
    if (!ok) throw FormatException('invalid-username');
    return '$uname@mediary.user';
  }

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
      resizeToAvoidBottomInset: true,
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 150),
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
                    const Text(
                      "Your media and watchlists, all in one place. Personal, customizable, and accessible.",
                      style: TextStyle(
                        color: myColors.brightOutlineColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(color: myColors.lightTextColor),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: constants.textFieldDecoration2
                          .copyWith(hintText: 'Enter your username'),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                      ),
                      onChanged: (value) => email = value,
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      style: const TextStyle(color: myColors.lightTextColor),
                      controller: passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: constants.textFieldDecoration2
                          .copyWith(hintText: 'Enter your password'),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                      ),
                      onChanged: (value) => password = value,
                    ),

                    // NEW: error message (matches registration style)
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
                          foregroundColor: WidgetStateProperty.all<Color>(
                              myColors.darkTextColor),
                        ),
                        onPressed: () async {
                          final id = (email ?? '').trim();
                          final pw = (password ?? '').trim();
                          if (id.isEmpty || pw.isEmpty) {
                            setState(() => _error =
                            'Please enter both username and password.');
                            return;
                          }

                          try {
                            setState(() => _error = null);
                            final signinEmail = _aliasFromUsername(id);
                            await _auth.signInWithEmailAndPassword(
                              email: signinEmail,
                              password: pw,
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(
                                context, constants.RoutePaths.Home);
                          } on FormatException {
                            setState(() => _error =
                            'Username must be 3–20 chars (letters, numbers, ., _, or -).');
                          } on FirebaseAuthException catch (ex) {
                            String msg = 'Login failed. Please try again.';
                            if (ex.code == 'user-not-found') {
                              msg = 'No account found for that username.';
                            } else if (ex.code == 'wrong-password' ||
                                ex.code == 'invalid-credential') {
                              msg = 'Incorrect username or password.';
                            } else if (ex.code == 'too-many-requests') {
                              msg = 'Too many attempts. Please wait and try again.';
                            }
                            setState(() => _error = msg);
                          } catch (_) {
                            setState(() =>
                            _error = 'Something went wrong. Please try again.');
                          }
                        },
                        child: const Text('Log In'),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'or',
                          style: TextStyle(color: myColors.lightTextColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              myColors.brightOutlineColor),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              myColors.darkTextColor),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, constants.RoutePaths.RegisterScreen);
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 24,
          child: Center(
            child: FutureBuilder<String>(
              future: getAppVersion(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Text(
                  "Mediarie v${snapshot.data}",
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
