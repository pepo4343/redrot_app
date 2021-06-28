import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/presentation/journeys/login/login_card.dart';
import 'package:redrotapp/presentation/logic/cubit/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: LoginAppBar(),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => getItInstance<LoginCubit>(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: theme.colorScheme.background,
            child: AnimatedLoginCard(),
          ),
        ),
      ),
    );
  }
}

class LoginAppBar extends StatefulWidget with PreferredSizeWidget {
  const LoginAppBar({
    Key? key,
  }) : super(key: key);

  @override
  _LoginAppBarState createState() => _LoginAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Sizes.dimen_48);
}

class _LoginAppBarState extends State<LoginAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1600),
  );
  late Tween<double> _translateYTween = Tween<double>(begin: 0, end: -50);
  late Animation<double> _translateYAnimation = _translateYTween.animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.3,
        1,
        curve: Curves.ease,
      ),
    ),
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (bottomInset == 0) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    return AppBar(
      title: Transform.translate(
        offset: Offset(0, _translateYAnimation.value),
        child: Text(
          "ลงชื่อเข้าใช้",
          style: Theme.of(context).textTheme.headline5!,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
