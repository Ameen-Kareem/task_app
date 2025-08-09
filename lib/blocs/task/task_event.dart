part of 'task_bloc.dart';

abstract class TaskEvent {}

class PickDateEvent extends TaskEvent {}

class PickTimeEvent extends TaskEvent {}

class SubmitTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final DateTime? date;

  SubmitTaskEvent({this.date, required this.title, required this.description});
}

class DeleteTaskEvent extends TaskEvent {
  DeleteTaskEvent({required this.docId});
  var docId;
}

class ClearStatusEvent extends TaskEvent {}

class EditTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final DateTime? date;
  var docId;

  EditTaskEvent({
    required this.docId,
    this.date,
    this.title = '',
    this.description = '',
  });
}
