import 'package:flutter/material.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:mediary/providers/watchlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:mediary/services/watchlist_services.dart';
import 'app_styles.dart' as myColors;
import 'app_router.dart' as mediaryRouter;
import 'app_constants.dart';
import 'package:mediary/ui/bottom.dart';
import 'package:mediary/ui/onboarding/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mediary/providers/cards_provider.dart';
import 'package:mediary/services/image_services.dart';


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
        ),
        Provider(create: (_) => WatchListService()),
        ChangeNotifierProvider<ImageService>(
            create: (_) {
              return ImageService();
            }
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        useMaterial3: false, textSelectionTheme: TextSelectionThemeData(
          cursorColor: myColors.brightOutlineColor,
          selectionColor: myColors.brightOutlineColor.withOpacity(0.4),
          selectionHandleColor: myColors.brightOutlineColor, // <- handle bars
        ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: myColors.brightOutlineColor, // <- fallback for some components
          ),

        ),

        title: 'Mediary',
        initialRoute:
            showOnboardingScreen ? RoutePaths.LoginScreen : RoutePaths.Home,
        onGenerateRoute: mediaryRouter.Router.generateRoute,
      ),
    );
  }
}
