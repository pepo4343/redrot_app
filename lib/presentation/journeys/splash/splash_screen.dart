import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/presentation/journeys/splash/cane_logo.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/auto_login/auto_login_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/auto_login/auto_login_state.dart';
import 'package:redrotapp/presentation/logic/cubit/login/login_cubit.dart';
import 'package:redrotapp/presentation/widgets/primary_button.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../../themes/app_theme.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => getItInstance<LoginCubit>(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: SplashBody(),
          ),
        ),
      ),
    );
  }
}

class SplashBody extends StatefulWidget {
  const SplashBody({
    Key? key,
  }) : super(key: key);

  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  late Timer? _timer;

  @override
  void initState() {
    _timer = Timer(Duration(seconds: 3), () {
      final autoLoginState = context.read<AutoLoginCubit>().state;

      if (autoLoginState is AutoLoginDisable) {
        Navigator.of(context).pushReplacementNamed('/login');
      }

      if (autoLoginState is AutoLoginEnable) {
        context
            .read<LoginCubit>()
            .fetch(autoLoginState.username, autoLoginState.password);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        final loginState = state;
        if (loginState is LoginSuccessful) {
          Navigator.of(context).pushReplacementNamed("/home");
          context.read<AutoLoginCubit>().enable(
              loginState.userEntity.username!, loginState.userEntity.password!);
          context
              .read<AuthenticationCubit>()
              .emitAuthenticated(loginState.userEntity);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CaneLogo(),
          SizedBox(
            height: Sizes.dimen_100,
          ),
          Builder(
            builder: (context) {
              final autoLoginState = context.read<AutoLoginCubit>().state;

              if (autoLoginState is AutoLoginEnable) {
                return _BottomContent();
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _BottomContent extends StatefulWidget {
  const _BottomContent({Key? key}) : super(key: key);

  @override
  _BottomContentState createState() => _BottomContentState();
}

class _BottomContentState extends State<_BottomContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 600),
  )..forward();

  late Animation<double> _translateYAnimation =
      Tween<double>(begin: -25, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  )..addListener(() {
          setState(() {});
        });

  late Animation<double> _opacityAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: _opacityAnimation.value,
      child: Transform.translate(
        offset: Offset(0, _translateYAnimation.value),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "กำลังลงชื่อเข้าใช้",
                style: theme.textTheme.bodyText2!.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              SizedBox(
                height: Sizes.dimen_4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TapDetector(
                    child: AutoLoginBadge(),
                    onPressed: () {
                      final autoLoginState =
                          context.read<AutoLoginCubit>().state;
                      print(autoLoginState);
                      if (autoLoginState is AutoLoginEnable) {
                        context.read<LoginCubit>().fetch(
                            autoLoginState.username, autoLoginState.password);
                      }
                    },
                  ),
                  SizedBox(
                    width: Sizes.dimen_16,
                  ),
                  TapDetector(
                    onPressed: () {
                      context.read<AutoLoginCubit>().reset();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.colorScheme.onSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          size: Sizes.dimen_20,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AutoLoginBadge extends StatefulWidget {
  const AutoLoginBadge({
    Key? key,
  }) : super(key: key);

  @override
  _AutoLoginBadgeState createState() => _AutoLoginBadgeState();
}

class _AutoLoginBadgeState extends State<AutoLoginBadge>
    with SingleTickerProviderStateMixin {
  double badgeWidth = 150;
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  )..forward();
  late Tween<double> _widthAnimationTween =
      Tween<double>(begin: 0, end: badgeWidth);
  late Animation<double> _widthAnimation = _widthAnimationTween.animate(
    CurvedAnimation(parent: _controller, curve: Curves.linear),
  )..addListener(() {
      setState(() {});
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(),
      width: badgeWidth,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary.withOpacity(0.3),
              ),
            ),
            Container(
              width: _widthAnimation.value,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: theme.colorScheme.secondary,
                ),
                child: Center(
                  child: Builder(
                    builder: (context) {
                      final autoLoginState =
                          context.read<AutoLoginCubit>().state;
                      if (autoLoginState is AutoLoginEnable) {
                        return Text(
                          autoLoginState.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText1!.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        );
                      }
                      return Text(
                        "กำลังลงชื่อเข้าใช้",
                        style: theme.textTheme.bodyText1!.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
