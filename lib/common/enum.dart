enum ProcessStatus {
  Waiting,
  VerifyNeeded,
  Completed,
  Error,
}

enum CloneStatus {
  Empty,
  VerifyNeed,
  Completed,
}

enum CloneType {
  All,
  VerifyNeeded,
  Completed,
}

enum ImageUploadStatus {
  Initial,
  Waiting,
  Uploading,
  Success,
  Failure,
}
