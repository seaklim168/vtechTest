enum ActionList {
  edit,
  remove,
  markCompleted,
  markIncompleted;

  String get title {
    switch (this) {
      case edit:
        return 'Edit';
      case remove:
        return 'Remove';
      case markCompleted:
        return "Mark as Completed";
      case markIncompleted:
        return "Mark as Incompleted";
    }
  }
}
