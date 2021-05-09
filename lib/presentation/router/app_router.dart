import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redrotapp/presentation/journeys/home/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
