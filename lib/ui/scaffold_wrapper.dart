import 'package:flutter/material.dart';

class AppScaffoldWrapper extends StatelessWidget {
  final Widget child;

  const AppScaffoldWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: child,
      ),
    );
  }
}
