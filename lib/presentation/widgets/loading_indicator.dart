import 'package:after_layout/after_layout.dart';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redrotapp/common/constants/size_constants.dart';

class LoadingIndicator extends StatefulWidget {
  final double width, height;

  const LoadingIndicator(
      {Key? key, this.width = Sizes.dimen_80, this.height = Sizes.dimen_80})
      : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FlareCacheBuilder([
        AssetFlare(bundle: rootBundle, name: "assets/flares/square_loading.flr")
      ], builder: (context, isWarm) {
        return !isWarm
            ? Container()
            : FlareActor(
                "assets/flares/square_loading.flr",
                animation: "SlideThem",
              );
      }),
    );
  }
}
