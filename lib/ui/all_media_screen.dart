import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: ListView(
        children: const <Widget>[
          Text(
            'My Media',
            style: TextStyle(
              color: myColors.darkTextColor,
              fontSize: 45,
            )
          ),
        ]
      )
    );
  }
}
