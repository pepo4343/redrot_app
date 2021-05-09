import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/presentation/router/app_router.dart';
import 'package:redrotapp/presentation/themes/app_theme.dart';
import 'package:sizer/sizer.dart';

import 'common/screenutil/screenutil.dart';
import 'package:pedantic/pedantic.dart';
import './di/get_it.dart' as getIt;
import 'domain/entities/app_error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(getIt.init());
  unawaited(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  );
  runApp(RedrotApp());
}

class RedrotApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          onGenerateRoute: _appRouter.onGenerateRoute,
        );
      },
    );
  }
}
