import 'package:flutter/material.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:mediary/providers/watchlist_provider.dart';
import 'package:provider/provider.dart';
import 'app_styles.dart';
import 'app_router.dart' as mediaryRouter;
import 'app_constants.dart';
import 'package:mediary/ui/bottom.dart';
import 'package:mediary/ui/onboarding/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mediary/providers/cards_provider.dart';

var showOnboardingScreen = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CardsProvider>(
          create: (_) {
            return CardsProvider();
          },
        ),
        ChangeNotifierProvider<MediaProvider>(
          create: (_) {
            return MediaProvider();
          }
        ),
        ChangeNotifierProvider<WatchlistProvider>(
          create: (_) {
            return WatchlistProvider();
          }
        )
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        title: 'Mediary',
        initialRoute:
            showOnboardingScreen ? RoutePaths.LoginScreen : RoutePaths.NavBar,
        onGenerateRoute: mediaryRouter.Router.generateRoute,
      ),
    );
  }
}
