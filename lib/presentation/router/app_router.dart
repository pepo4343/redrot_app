import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:images_picker/images_picker.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/add_clone/add_clone_screen.dart';
import 'package:redrotapp/presentation/journeys/clone_detail/clone_detail_screen.dart';
import 'package:redrotapp/presentation/journeys/home/home_screen.dart';
import 'package:redrotapp/presentation/journeys/images_upload/images_upload_screen.dart';
import 'package:redrotapp/presentation/journeys/images_upload/photo_view_screen.dart';

class ImagesUploadScreenArguments {
  final List<Media> media;
  final CloneEntity clone;

  ImagesUploadScreenArguments({required this.clone, required this.media});
}

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return _createRoute(HomeScreen());
        ;
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
      default:
        return _createRoute(HomeScreen());
    }
  }

  static Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
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
