import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/common/functions.dart';

import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:redrotapp/presentation/widgets/time_ago_text.dart';

import '../../themes/app_theme.dart';

import 'clone_card_body/clone_card_body.dart';

class CloneCard extends StatelessWidget {
  final CloneEntity clone;
  final Function(CloneEntity clone) onTap;
  final Function(CloneEntity clone) onDelete;
  final bool animation;

  static const double margin = Sizes.dimen_8;

  CloneCard({
    required this.clone,
    required this.onTap,
    required this.onDelete,
    this.animation = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.all(
        CloneCard.margin,
      ),
      child: AnimatedCard(
        onTap: () {
          onTap(clone);
        },
        onLongPressed: () {
          onDelete(clone);
        },
        width: double.infinity,
        sensitivity: 0.15,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.dimen_8),
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                children: [
                  FittedBox(
                    child: Text(
                      clone.cloneName,
                      style: textTheme.headline6!,
                    ),
                  ),
                  SizedBox(
                    height: Sizes.dimen_8,
                    width: double.infinity,
                  ),
                  CloneCardBody(
                    cloneEntity: clone,
                    animation: animation,
                  ),
                  SizedBox(
                    height: Sizes.dimen_8,
                    width: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FittedBox(
                      child: TimeagoText(clone.createdAt),
                    ),
                  ),
                ],
              ),
            ),
            getCloneStatus(clone) == CloneStatus.Completed
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.successColor,
                        size: Sizes.dimen_20,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
