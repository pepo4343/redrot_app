import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_divider.dart';
import 'package:redrotapp/presentation/widgets/score_container.dart';
import '../../themes/app_theme.dart';
import 'cane.dart';

class RedrotDetailCardBody extends StatelessWidget {
  const RedrotDetailCardBody({
    Key? key,
    required this.redrotEntity,
  }) : super(key: key);

  final RedrotEntity redrotEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Cane(
            color: redrotEntity.raw?.color.toDouble() ?? 0,
            node: (redrotEntity.raw?.nodalTransgression ?? 0).toDouble(),
            spread: redrotEntity.raw?.lesionWidth ?? 0,
          ),
          RedrotDetailDivider(
            title: "ข้อมูลดิบ",
          ),
          SizedBox(
            height: Sizes.dimen_8,
          ),
          _RawContainer(
            redrotEntity: redrotEntity,
          ),
          RedrotDetailDivider(
            title: "คะแนน",
          ),
          SizedBox(
            height: Sizes.dimen_8,
          ),
          ScoreContainer(redrotEntity: redrotEntity),
          SizedBox(
            height: Sizes.dimen_8,
          ),
        ],
      ),
    );
  }
}

class _RawContainer extends StatelessWidget {
  const _RawContainer({
    Key? key,
    required this.redrotEntity,
  }) : super(key: key);

  String get _colorText {
    if (redrotEntity.raw?.color == 0) {
      return "ไม่มีสี";
    }
    if (redrotEntity.raw?.color == 1) {
      return 'แดง';
    }
    if (redrotEntity.raw?.color == 2) {
      return 'ดำ';
    }
    return "-";
  }

  Color _getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (redrotEntity.raw?.color == 0) {
      return colorScheme.disableColor;
    }
    if (redrotEntity.raw?.color == 1) {
      return colorScheme.errorColor;
    }
    if (redrotEntity.raw?.color == 2) {
      return colorScheme.textColor;
    }
    return colorScheme.textColor;
  }

  final RedrotEntity redrotEntity;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScoreText(
          score: redrotEntity.raw?.nodalTransgression.toString(),
          title: "จำนวนข้อ",
          unit: " ข้อ",
        ),
        ScoreText(
          score: redrotEntity.raw?.lesionWidth.toStringAsFixed(2),
          title: "ความกว้างแผล",
          unit: "%",
        ),
        ScoreText(
          score: _colorText,
          color: _getColor(context),
          title: "สี",
          unit: "",
        )
      ],
    );
  }
}
