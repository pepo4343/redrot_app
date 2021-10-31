import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:redrotapp/presentation/widgets/score_container.dart';
import 'package:redrotapp/presentation/widgets/status_badge.dart';
import 'package:redrotapp/presentation/widgets/time_ago_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../themes/app_theme.dart';

class RedrotCard extends StatefulWidget {
  final RedrotEntity redrotEntity;
  final VoidCallback onPressed;
  final Function(RedrotEntity redrotEntity) onDelete;
  RedrotCard({
    required this.redrotEntity,
    required this.onPressed,
    required this.onDelete,
  });
  @override
  _RedrotCardState createState() => _RedrotCardState();
}

class _RedrotCardState extends State<RedrotCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedCard(
        onTap: widget.onPressed,
        onLongPressed: () {
          widget.onDelete(widget.redrotEntity);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _RedrotImageContainer(
              imageUrl: widget.redrotEntity.imageUrl,
              redrotId: widget.redrotEntity.redrotId,
            ),
            SizedBox(
              height: Sizes.dimen_4,
            ),
            StatusBadge(redrotEntity: widget.redrotEntity),
            ScoreContainer(
              redrotEntity: widget.redrotEntity,
            ),
            Padding(
              padding: const EdgeInsets.only(right: Sizes.dimen_20),
              child: TimeagoText(widget.redrotEntity.updatedAt),
            ),
            SizedBox(
              height: Sizes.dimen_4,
            ),
          ],
        ),
      ),
    );
  }
}

class _RedrotImageContainer extends StatelessWidget {
  const _RedrotImageContainer({
    Key? key,
    required this.imageUrl,
    required this.redrotId,
  }) : super(key: key);

  final String imageUrl;
  final String redrotId;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: redrotId,
      child: ClipRRect(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Sizes.dimen_16)),
        child: Image.network(
          imageUrl,
          height: Sizes.dimen_100,
          width: double.infinity,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            Widget content = child;
            if (frame == null) {
              content = Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.shimmerBackgroundColor,
                highlightColor:
                    Theme.of(context).colorScheme.shimmerHighlightColor,
                child: Container(
                  height: Sizes.dimen_100,
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
    );
  }
}
