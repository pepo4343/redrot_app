import 'dart:async';

import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/auto_login/auto_login_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/login/login_cubit.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';
import 'package:redrotapp/presentation/widgets/primary_button.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../../themes/app_theme.dart';
import '../splash/cane_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimatedLoginCard extends StatefulWidget {
  const AnimatedLoginCard({
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedLoginCardState createState() => _AnimatedLoginCardState();
}

class _AnimatedLoginCardState extends State<AnimatedLoginCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1000),
  );
  late Tween<double> _translateYTween = Tween<double>(begin: 0, end: 0);
  late Animation<double> _translateYAnimation = _translateYTween
      .animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
        ..addListener(() {
          setState(() {});
        });

  Timer? _timer;

  @override
  void initState() {
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
    if (!_controller.isAnimating) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: 100), () {
        final _keyboardInsets = MediaQuery.of(context).viewInsets.bottom;
        _translateYTween.begin = _translateYAnimation.value;
        if (_keyboardInsets == 0) {
          _translateYTween.end = 0;
        } else {
          _translateYTween.end = -_keyboardInsets / 2;
        }

        if (_translateYTween.begin != _translateYTween.end) {
          _controller.reset();
          _controller.forward();
        }
      });
    }

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
        if (loginState is LoginUnsuccessful) {
          final theme = Theme.of(context);
          final snackBar = SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              loginState.message,
              style: theme.textTheme.bodyText1!
                  .copyWith(color: theme.colorScheme.onSecondary),
            ),
          );
          if (ScaffoldMessenger.of(context).mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Transform.translate(
        offset: Offset(0, _translateYAnimation.value),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: LoginCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  LoginCard({
    Key? key,
  }) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isUsernameError = false;
  bool isPasswordError = false;

  InputDecoration _inputDecoration(String hintText) {
    final theme = Theme.of(context);
    return InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      focusColor: theme.colorScheme.secondary,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.secondary),
      ),
      hintText: hintText,
      hintStyle: theme.textTheme.bodyText2!.copyWith(
        color: theme.colorScheme.disableColor,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.errorColor),
      ),
      errorStyle: theme.textTheme.bodyText2!.copyWith(
        color: theme.colorScheme.errorColor,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.errorColor,
        ),
      ),
    );
  }

  double _getCardHeight() {
    int numError = 0;
    double errorTextHeight = 15;
    if (isUsernameError) {
      numError = numError + 1;
    }
    if (isPasswordError) {
      numError = numError + 1;
    }

    return 250 + numError * errorTextHeight;
  }

  Widget get _bottomContent {
    final theme = Theme.of(context);
    final loginState = context.watch<LoginCubit>().state;
    Widget _content = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TapDetector(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/home");
            context.read<AuthenticationCubit>().emitGuestAuthenticated();
          },
          child: Text(
            "Guest Login",
            style: theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.secondaryTextColor,
            ),
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        PrimaryButton(
          text: "ลงชื่อเข้าใช้",
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            FocusScope.of(context).unfocus();
            context
                .read<LoginCubit>()
                .fetch(_usernameController.text, _passwordController.text);
          },
        ),
      ],
    );
    if (loginState is LoginInProgress) {
      _content = Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: LoadingIndicator(
            width: 30,
            height: 30,
          ),
        ),
      );
    }

    return Container(
      height: 30,
      child: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          var curve = Curves.ease;
          var opacityTween =
              Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
          var slideTween =
              Tween<Offset>(begin: Offset(0.0, -0.25), end: Offset(0.0, 0.0))
                  .chain(CurveTween(curve: curve));
          return FadeTransition(
            opacity: opacityTween.animate(animation),
            child: SlideTransition(
              child: child,
              position: slideTween.animate(animation),
            ),
          );
        },
        layoutBuilder: (currentChild, previousChildren) => currentChild!,
        duration: Duration(milliseconds: 300),
        child: _content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      height: _getCardHeight(),
      margin: EdgeInsets.only(top: Sizes.dimen_20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.cardColor,
        boxShadow: theme.primaryBoxShadows,
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              clipBehavior: Clip.antiAlias,
              children: [
                Text(
                  "ชื่อผู้ใช้",
                  style: theme.textTheme.bodyText2,
                ),
                TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  enableSuggestions: false,
                  cursorColor: theme.colorScheme.secondary,
                  style: theme.textTheme.bodyText1,
                  decoration: _inputDecoration("โปรดใส่ชื่อผู้ใช้"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isUsernameError = true;
                      });
                      return "โปรดใส่ชื่อผู้ใช้";
                    }
                    setState(() {
                      isUsernameError = false;
                    });
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                  width: double.infinity,
                ),
                Text(
                  "รหัสผ่าน",
                  style: theme.textTheme.bodyText2,
                ),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: theme.colorScheme.secondary,
                  style: theme.textTheme.bodyText1,
                  obscureText: true,
                  decoration: _inputDecoration("โปรดใส่รหัสผ่าน"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isPasswordError = true;
                      });
                      return "โปรดใส่รหัสผ่าน";
                    }
                    setState(() {
                      isPasswordError = false;
                    });
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                  width: double.infinity,
                ),
                _bottomContent
              ],
            ),
          ),
        ),
      ),
    );
  }
}
