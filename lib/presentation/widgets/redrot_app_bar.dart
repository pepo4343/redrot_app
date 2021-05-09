import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';

class RedrotAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const RedrotAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Sizes.dimen_48);
}
