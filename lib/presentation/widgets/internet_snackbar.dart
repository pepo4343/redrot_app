import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/presentation/logic/cubit/internet/internet_cubit.dart';

class InternetSnackBar extends StatelessWidget {
  InternetSnackBar({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        final theme = Theme.of(context);
        final snackBar = SnackBar(
          duration: Duration(days: 365),
          content: Text(
            'โปรดเชื่อมต่ออินเตอร์เน็ต',
            style: theme.textTheme.bodyText1!
                .copyWith(color: theme.colorScheme.onSecondary),
          ),
        );

        if (state is InternetDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is InternetConnected) {
          if (ScaffoldMessenger.of(context).mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }
      },
      child: child,
    );
  }
}
