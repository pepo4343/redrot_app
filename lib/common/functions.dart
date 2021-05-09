import 'package:redrotapp/common/enum.dart';

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
