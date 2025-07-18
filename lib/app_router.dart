import 'package:flutter/material.dart';
import 'package:mediary/ui/onboarding/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:mediary/models/card_model.dart';
import 'package:mediary/models/user_model.dart';
import 'package:mediary/providers/auth_provider.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:mediary/services/local_storage_service.dart';
import 'package:mediary/services/media_api_service.dart';
import 'package:mediary/ui/all_media_screen.dart';
import 'package:mediary/ui/items_media_screen.dart';
import 'package:mediary/ui/profile_screen.dart';
import 'package:mediary/ui/profile_screen.dart';
import 'package:mediary/ui/widgets/media_category_card.dart';
import 'app_constants.dart';
import 'package:mediary/ui/bottom.dart';
import 'package:mediary/ui/onboarding/registration_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case RoutePaths.NavBar:
        return MaterialPageRoute(builder: (_) => AppNavigationBar());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => Home());
      case RoutePaths.LoginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutePaths.RegisterScreen:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }

}
