import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/theme/theme_cubit.dart';
import 'package:redrotapp/presentation/router/app_router.dart';
import 'package:redrotapp/presentation/themes/app_theme.dart';

import 'package:pedantic/pedantic.dart';
import './di/get_it.dart' as getIt;

import 'package:universal_platform/universal_platform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(getIt.init());
  unawaited(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  );
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    if (UniversalPlatform.isAndroid) {
      setOptimalDisplayMode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => getIt.getItInstance<ImageUploaderCubit>(),
        ),
      ],
      child: RedrotApp(),
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

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }
}

class RedrotApp extends StatefulWidget {
  @override
  _RedrotAppState createState() => _RedrotAppState();
}

class _RedrotAppState extends State<RedrotApp> with WidgetsBindingObserver {
  @override
  void initState() {
    context.read<ThemeCubit>().updateAppTheme();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          context.select((ThemeCubit themeCubit) => themeCubit.state.themeMode),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
