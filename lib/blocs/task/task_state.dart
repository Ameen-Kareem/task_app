part of 'task_bloc.dart';

enum TaskStatus { idle, success, error }

class TaskState {}

class TaskInitial extends TaskState {}

class AddTaskState extends TaskState {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TaskStatus status;
  final String description;
  final String title;

  AddTaskState({
    required this.title,
    this.selectedDate,
    this.selectedTime,
    required this.status,
    required this.description,
  });

  AddTaskState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    TaskStatus? status,
    String? description,
    String? name,
  }) {
    return AddTaskState(
      title: name ?? this.title,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}

final class TaskAddedSuccessState extends TaskState {}

final class TaskDeletionSuccess extends TaskState {}

final class TaskEditSuccess extends TaskState {}

final class TaskUpdationFailedState extends TaskState {
  String error;
  TaskUpdationFailedState({required this.error});
}

final class TaskIncompleteState extends TaskState {
  String msg;
  TaskIncompleteState({required this.msg});
}

final class TaskWithoutRemainderAddingState extends TaskState {}
