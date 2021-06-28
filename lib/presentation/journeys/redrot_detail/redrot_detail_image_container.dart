import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_screen.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import 'package:shimmer/shimmer.dart';
import '../../themes/app_theme.dart';

class RedrotDetailImageContainer extends StatefulWidget {
  const RedrotDetailImageContainer({
    Key? key,
    required this.redrotEntity,
  }) : super(key: key);

  final RedrotEntity redrotEntity;

  @override
  _RedrotDetailImageContainerState createState() =>
      _RedrotDetailImageContainerState();
}

class _RedrotDetailImageContainerState
    extends State<RedrotDetailImageContainer> {
  ScrollController? scrollController;
  double scale = 1;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (scrollController != null) {
      scrollController!.removeListener(_onScrollChange);
    }
    scrollController = RedrotDetailScreen.of(context)?.scrollChange;
    if (scrollController != null) {
      scrollController!.addListener(_onScrollChange);
    }
  }

  @override
  void dispose() {
    scrollController?.removeListener(_onScrollChange);
    super.dispose();
  }

  void _onScrollChange() {
    if (scrollController == null) {
      return;
    }
    if (scrollController!.offset <= 0) {
      final offset = -scrollController!.offset;
      setState(() {
        scale = 0.003 * offset + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.redrotEntity.redrotId,
      child: ClipRRect(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Sizes.dimen_16)),
        child: Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/redrotphotoview",
                  arguments: widget.redrotEntity);
            },
            child: Image.network(
              widget.redrotEntity.imageUrl,
              height: Sizes.dimen_200,
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                Widget content = child;
                if (frame == null) {
                  content = Shimmer.fromColors(
                    baseColor:
                        Theme.of(context).colorScheme.shimmerBackgroundColor,
                    highlightColor:
                        Theme.of(context).colorScheme.shimmerHighlightColor,
                    child: Container(
                      height: Sizes.dimen_200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Sizes.dimen_16)),
                      ),
                    ),
                  );
                }

                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: content,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
