import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';
import '../themes/app_theme.dart';

class RedrotDarkAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const RedrotDarkAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: AppDarkColors().textColor),
      ),
      iconTheme: IconThemeData(color: const AppDarkColors().textColor),
      backgroundColor: const AppDarkColors().backgroundColor,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Sizes.dimen_48);
}
