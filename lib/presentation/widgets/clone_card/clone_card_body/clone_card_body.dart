import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/widgets/clone_card/clone_card_body/verify_needed_body/verify_needed_body.dart';

import '../../../../../common/functions.dart';
import 'completed_body/completed_body.dart';

class CloneCardBody extends StatelessWidget {
  final CloneEntity cloneEntity;
  final bool animation;
  const CloneCardBody({
    Key? key,
    required this.cloneEntity,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    CloneStatus cloneStatus = getCloneStatus(cloneEntity);
    final theme = Theme.of(context);

    switch (cloneStatus) {
      case CloneStatus.Empty:
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.dimen_4,
              horizontal: Sizes.dimen_20,
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "ไม่พบข้อมูลความต้านทานของโรคเน่าแดง",
                style: theme.textTheme.bodyText2!,
              ),
            ),
          ),
        );
      case CloneStatus.VerifyNeed:
        return VerifyNeededBody(
          redrots: cloneEntity.redrot,
          animation: animation,
        );
      case CloneStatus.Completed:
        return CompletedBody(cloneEntity: cloneEntity);
      default:
        return Text("Error");
    }
  }
}
