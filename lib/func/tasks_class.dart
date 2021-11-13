class SubTasksDetails {
  // late String setName;
  late String subName;
  late DateTime date;
  // late bool isDone;

  SubTasksDetails({
    // required this.setName,
    required this.subName,
    required this.date,
    // required this.isDone
  });
}

class SubTasksEditing {
  late String subName;
  late String setName;
  late String type;
  late DateTime date;
  late DateTime deadline;
  late String setPath;
  late String id;

  SubTasksEditing(
      {required this.subName,
      required this.setName,
      required this.type,
      required this.date,
      required this.deadline,
      required this.setPath,
      required this.id});
}

class ToDoSetDetails {
  late String title;
  late String day;
  late String condition;
  late String startOrDeadline;

  ToDoSetDetails(
      {
      required this.title,
      required this.day,
      required this.condition,
      required this.startOrDeadline});
}

class GenerateSetTasks {
  late String title;
  late DateTime date;

  GenerateSetTasks({
    required this.title,
    required this.date,
  });
}

class Weekend {
  late bool sunday;
  late bool monday;
  late bool tuesday;
  late bool wednesday;
  late bool thursday;
  late bool friday;
  late bool saturday;

  Weekend({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });
}