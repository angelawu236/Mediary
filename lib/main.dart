import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_styles.dart';
import 'app_router.dart' as mediaryRouter;
import 'app_constants.dart';


void main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final theme = ThemeData(

    );
    return const MaterialApp(
      title: 'Mediary',
      initialRoute: RoutePaths.Home,
      onGenerateRoute: mediaryRouter.Router.generateRoute,
    );
  }
}

