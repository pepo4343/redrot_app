import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/presentation/widgets/image_uploader_indicator.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';
import '../themes/app_theme.dart';

class RedrotAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const RedrotAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5!,
      ),
      iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondaryTextColor),
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [ImageUploaderIndicator()],
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Sizes.dimen_48);
}
