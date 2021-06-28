import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import '../themes/app_theme.dart';

class StatusBadge extends StatelessWidget {
  StatusBadge({required RedrotEntity redrotEntity})
      : this.status = redrotEntity.status,
        this.redrotId = redrotEntity.redrotId;
  final ProcessStatus status;
  final String redrotId;

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
    return Hero(
      placeholderBuilder: (context, heroSize, child) {
        return Opacity(
          opacity: 0,
          child: Container(
            child: child,
          ),
        );
      },
      tag: redrotId + "_badge",
      child: Container(
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
      ),
    );
  }
}
