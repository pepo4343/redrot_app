import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import '../themes/app_theme.dart';

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({Key? key, required this.redrotEntity})
      : super(key: key);

  final RedrotEntity redrotEntity;

  @override
  Widget build(BuildContext context) {
    final score = redrotEntity.score;
    final totalScoreText = score == null ? "-" : score.totalScore.toString();
    final theme = Theme.of(context);
    return Hero(
      tag: redrotEntity.redrotId + "_score",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScoreText(
                title: "จำนวนข้อ",
                unit: " คะแนน",
                score: score?.nodalTransgressionScore.toString(),
              ),
              ScoreText(
                title: "ความกว้าง",
                unit: " คะแนน",
                score: score?.lesionWidthScore.toString(),
              ),
              ScoreText(
                title: "สี",
                unit: " คะแนน",
                score: score?.colorScore.toString(),
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
      ),
    );
  }
}

class ScoreText extends StatelessWidget {
  const ScoreText({
    Key? key,
    required this.title,
    required this.score,
    required this.unit,
    this.color,
  }) : super(key: key);

  final String title;
  final String? score;
  final String unit;
  final Color? color;

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
            text: "$scoreText",
            style: theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w500,
              color: color == null ? theme.colorScheme.textColor : color,
            ),
          ),
          TextSpan(
            text: "$unit",
            style: theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
