import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'scaffold_wrapper.dart';

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
      body: AppScaffoldWrapper(
        child: ListView(
          children: const <Widget>[
            Text(
              constants.Titles.homeTitle, // 'My Media'
              style: TextStyle(
                color: myColors.darkTextColor,
                fontSize: 45,
              )
            ),
          ]
        ),
      )
    );
  }
}
