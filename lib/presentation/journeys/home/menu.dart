import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/presentation/logic/cubit/auto_login/auto_login_cubit.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import 'package:wiredash/wiredash.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: 0,
      bottom: 0,
      top: 0,
      child: Container(
        width: 0.7 * MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: Sizes.dimen_150, left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final authenticationState =
                      context.watch<AuthenticationCubit>().state;
                  if (authenticationState is AuthenticationAnthenticated) {
                    final user = authenticationState.userEntity;
                    return Column(
                      children: [
                        AnimatedIn(
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: theme.disabledColor,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "${user.firstName![0].toUpperCase()}${user.lastName![0].toUpperCase()}",
                                style: theme.textTheme.headline5!.copyWith(
                                  color: theme.colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Sizes.dimen_10,
                        ),
                        AnimatedIn(
                          delay: 50,
                          child: Center(
                            child: Text(
                              "${user.firstName!.toUpperCase()} ${user.lastName!.toUpperCase()}",
                              style: theme.textTheme.headline6,
                            ),
                          ),
                        ),
                        AnimatedIn(
                          delay: 100,
                          child: Center(
                            child: Text(
                              "${user.email}",
                              style: theme.textTheme.caption,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(
                height: 32,
              ),
              AnimatedIn(
                delay: 200,
                child: TapDetector(
                  onPressed: () {
                    Wiredash.of(context)!.show();
                  },
                  child: Text(
                    "แจ้งข้อบกพร่อง",
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ),
              AnimatedIn(
                delay: 250,
                child: Divider(),
              ),
              AnimatedIn(
                delay: 300,
                child: TapDetector(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                    context.read<AuthenticationCubit>().reset();
                    context.read<AutoLoginCubit>().reset();
                  },
                  child: Text(
                    "ออกจากระบบ",
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedIn extends StatefulWidget {
  final Widget child;
  final int delay;
  const AnimatedIn({
    Key? key,
    required this.child,
    this.delay = 0,
  }) : super(key: key);

  @override
  _AnimatedInState createState() => _AnimatedInState();
}

class _AnimatedInState extends State<AnimatedIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 600),
  );

  late Animation<double> _translateYAnimation =
      Tween<double>(begin: -10, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  )..addListener(() {
          setState(() {});
        });
  late Animation<double> _opacityAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  );

  late Timer? _timer;
  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: widget.delay), () {
      _controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityAnimation.value,
      child: Transform.translate(
        offset: Offset(0, _translateYAnimation.value),
        child: Container(
          child: widget.child,
        ),
      ),
    );
  }
}
