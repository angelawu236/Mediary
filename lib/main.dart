import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_styles.dart';
import 'app_router.dart' as mediaryRouter;
import 'app_constants.dart';
import 'package:mediary/ui/bottom.dart';
import 'package:mediary/ui/onboarding/login_screen.dart';

var showOnboardingScreen = true;

void main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final theme = ThemeData(

    );
    return MaterialApp(

      theme: ThemeData(useMaterial3: true),
      title: 'Mediary',
      initialRoute: showOnboardingScreen
      ? RoutePaths.LoginScreen
      : RoutePaths.NavBar,
      onGenerateRoute: mediaryRouter.Router.generateRoute,
    );
  }
}

