import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:images_picker/images_picker.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/add_clone/add_clone_screen.dart';
import 'package:redrotapp/presentation/journeys/clone_detail/clone_detail_screen.dart';
import 'package:redrotapp/presentation/journeys/home/home_screen.dart';
import 'package:redrotapp/presentation/journeys/images_upload/images_upload_screen.dart';
import 'package:redrotapp/presentation/journeys/images_upload/photo_view_screen.dart';
import 'package:redrotapp/presentation/journeys/login/login_screen.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_screen.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_photo_view_screen.dart';
import 'package:redrotapp/presentation/journeys/splash/splash_screen.dart';

class ImagesUploadScreenArguments {
  final List<Media> media;
  final CloneEntity clone;
  ImagesUploadScreenArguments({required this.clone, required this.media});
}

class RedrotDetailScreenArguments {
  final String redrotId;
  final CloneEntity clone;
  RedrotDetailScreenArguments({required this.clone, required this.redrotId});
}

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return _createRoute(SplashScreen());
      case "/home":
        return _createRoute(HomeScreen());
      case "/login":
        return _createRoute(LoginScreen());
      case "/addclone":
        final args = routeSettings.arguments as String;
        return _createRoute(AddCloneScreen(title: args));
      case "/clonedetail":
        final args = routeSettings.arguments as CloneEntity;
        return _createRoute(CloneDetailScreen(
          clone: args,
        ));
      case "/imagesupload":
        return _createRoute(ImagesUploadScreen());
      case "/photoview":
        final args = routeSettings.arguments as int;
        return _createRoute(PhotoViewScreen(initialIndex: args));
      case "/redrotphotoview":
        final args = routeSettings.arguments as RedrotEntity;
        return _createRoute(RedrotPhotoViewScreen(redrotEntity: args));
      case "/redrotdetail":
        final args = routeSettings.arguments as RedrotDetailScreenArguments;
        return _createRoute(RedrotDetailScreen(
          redrotId: args.redrotId,
          initialClone: args.clone,
        ));
      default:
        return _createRoute(HomeScreen());
    }
  }

  static Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600),
      reverseTransitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        double begin = 0;
        double end = 1;
        var curve = Curves.ease;

        var tween = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
