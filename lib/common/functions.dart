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
