import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/views/services/notification_scheduler.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    final CollectionReference _usersStream = FirebaseFirestore.instance
        .collection('tasks');
    on<SubmitTaskEvent>((event, emit) async {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(TaskIncompleteState(msg: "Name or description cannot be empty"));
      } else {
        if (event.date != null) {
          try {
            await _usersStream.add({
              'name': event.title,
              'description': event.description,
              'remainder': Timestamp.fromDate(event.date!),
            });
            log("inside event");
            TaskScheduler().scheduleAllTaskNotifications();
            emit(TaskAddedSuccessState());
          } catch (e) {
            emit(TaskUpdationFailedState(error: e.toString()));
          }
        } else {
          try {
            _usersStream.add({
              'name': event.title,
              'description': event.description,
            });
            emit(TaskWithoutRemainderAddingState());
          } catch (e) {
            emit(TaskUpdationFailedState(error: e.toString()));
          }
        }
      }
    });
    on<EditTaskEvent>((event, emit) {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(TaskIncompleteState(msg: "Name or description cannot be empty"));
      } else {
        if (event.date != null) {
          try {
            _usersStream.doc(event.docId).set({
              'name': event.title,
              'description': event.description,
              'remainder': Timestamp.fromDate(event.date!),
            });
            emit(TaskEditSuccess());
          } catch (e) {
            emit(TaskUpdationFailedState(error: e.toString()));
          }
        } else {
          try {
            _usersStream.doc(event.docId).set({
              'name': event.title,
              'description': event.description,
            });
            emit(TaskEditSuccess());
          } catch (e) {
            emit(TaskUpdationFailedState(error: e.toString()));
          }
        }
      }
    });
    on<DeleteTaskEvent>((event, emit) {
      _usersStream.doc(event.docId).delete();
    });
  }
}
