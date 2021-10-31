import 'package:flutter/material.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

ProcessStatus toProcessStatus(int processNumber) {
  switch (processNumber) {
    case 0:
      return ProcessStatus.Waiting;
    case 1:
      return ProcessStatus.VerifyNeeded;
    case 2:
      return ProcessStatus.Completed;
    case 3:
      return ProcessStatus.Error;
    default:
      return ProcessStatus.Error;
  }
}

int getCompletedNum(List<RedrotEntity> redrots) {
  return redrots.fold(
    0,
    (int previousValue, element) {
      if (element.status == ProcessStatus.Completed) {
        return previousValue + 1;
      }
      return previousValue;
    },
  );
}

CloneStatus getCloneStatus(CloneEntity cloneEntity) {
  if (cloneEntity.redrot.isEmpty) {
    return CloneStatus.Empty;
  }
  final completedNum = getCompletedNum(cloneEntity.redrot);
  final totalNum = cloneEntity.redrot.length;
  if (completedNum == totalNum) {
    return CloneStatus.Completed;
  } else {
    return CloneStatus.VerifyNeed;
  }
}

void showDeleteInprogressSnackbar(BuildContext context) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
    duration: Duration(seconds: 1),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "กำลังลบข้อมูล...",
          style: theme.textTheme.bodyText1!
              .copyWith(color: theme.colorScheme.onSecondary),
        ),
        Container(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: theme.colorScheme.onSecondary,
          ),
        )
      ],
    ),
  );
  if (ScaffoldMessenger.of(context).mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showDeleteSuccessSnackbar(BuildContext context) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
    duration: Duration(seconds: 1),
    content: Text(
      "ลบข้อมูลเสร็จสิ้น",
      style: theme.textTheme.bodyText1!
          .copyWith(color: theme.colorScheme.onSecondary),
    ),
  );
  if (ScaffoldMessenger.of(context).mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
