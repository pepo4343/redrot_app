import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/journeys/qr/qr_screen.dart';

class QrFab extends StatelessWidget {
  const QrFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              CircularClipRoute<void>(
                builder: (_) => QrScreen(),
                expandFrom: context,
                border: Border.all(
                  width: Sizes.dimen_0,
                ),
              ),
            );
          },
          child: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
