import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
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

class RedrotApp extends StatefulWidget {
  @override
  _RedrotAppState createState() => _RedrotAppState();
}

class _RedrotAppState extends State<RedrotApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    setOptimalDisplayMode();
    super.initState();
  }

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

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
          ..sort((DisplayMode a, DisplayMode b) =>
              b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    /// This setting is per session.
    /// Please ensure this was placed with `initState` of your root widget.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }
}
