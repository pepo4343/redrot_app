import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:redrotapp/presentation/widgets/time_ago_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../themes/app_theme.dart';

class RedrotCard extends StatefulWidget {
  final RedrotEntity redrotEntity;
  RedrotCard({
    required this.redrotEntity,
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
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _RedrotImageContainer(
              imageUrl: widget.redrotEntity.imageUrl,
            ),
            SizedBox(
              height: Sizes.dimen_4,
            ),
            _StatusBadge(status: widget.redrotEntity.status),
            _ScoreContainer(
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

class _StatusBadge extends StatelessWidget {
  _StatusBadge({required this.status});
  final ProcessStatus status;

  String get _statusText {
    if (status == ProcessStatus.Waiting) {
      return 'กำลังประมวลผล';
    }
    if (status == ProcessStatus.VerifyNeeded) {
      return 'รอการอนุมัติ';
    }
    if (status == ProcessStatus.Error) {
      return 'ผิดพลาด';
    }
    if (status == ProcessStatus.Completed) {
      return 'เสร็จสิ้น';
    }
    return "";
  }

  Color _getColor(ThemeData theme) {
    if (status == ProcessStatus.Waiting) {
      return theme.colorScheme.disableColor;
    }
    if (status == ProcessStatus.VerifyNeeded) {
      return theme.colorScheme.secondary;
    }
    if (status == ProcessStatus.Error) {
      return theme.colorScheme.errorColor;
    }
    if (status == ProcessStatus.Completed) {
      return theme.colorScheme.successColor;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(
        right: Sizes.dimen_4,
      ),
      decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(const Radius.circular(Sizes.dimen_58)),
          border: Border.all(width: Sizes.dimen_1, color: _getColor(theme))),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_12),
      child: Text(
        _statusText,
        style: theme.textTheme.bodyText2!.copyWith(color: _getColor(theme)),
      ),
    );
  }
}

class _ScoreContainer extends StatelessWidget {
  const _ScoreContainer({
    Key? key,
    required this.redrotEntity,
  }) : super(key: key);

  final RedrotEntity redrotEntity;
  @override
  Widget build(BuildContext context) {
    final score = redrotEntity.score;
    final totalScoreText = score == null ? "-" : score.totalScore.toString();
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScoreText(
              title: "จำนวนข้อ",
              score: score?.nodalTransgressionScore,
            ),
            _ScoreText(
              title: "ความกว้าง",
              score: score?.lesionWidthScore,
            ),
            _ScoreText(
              title: "สี",
              score: score?.colorScore,
            )
          ],
        ),
        Container(
          height: Sizes.dimen_58,
          width: 1,
          color: theme.colorScheme.textColor,
          margin: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
        ),
        Text(
          totalScoreText,
          style: theme.textTheme.headline1!.copyWith(height: 1),
        )
      ],
    );
  }
}

class _ScoreText extends StatelessWidget {
  const _ScoreText({
    Key? key,
    required this.title,
    required this.score,
  }) : super(key: key);

  final String title;
  final int? score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreText = score == null ? "-" : score.toString();
    return RichText(
      text: TextSpan(
        text: "$title : ",
        style: theme.textTheme.bodyText2,
        children: [
          TextSpan(
            text: "$scoreText คะแนน",
            style: theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _RedrotImageContainer extends StatelessWidget {
  const _RedrotImageContainer({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.dimen_16)),
      child: Image.network(
        imageUrl,
        height: Sizes.dimen_100,
        width: double.infinity,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          if (frame == null) {
            return Shimmer.fromColors(
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
          return child;
        },
      ),
    );
  }
}
