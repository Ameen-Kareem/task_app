import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/blocs/task/task_bloc.dart';
import 'package:task_app/global_widgets/popup_msg.dart';
import 'package:task_app/utils/color_utils.dart';

class TaskAddPage extends StatefulWidget {
  @override
  var docId;
  TaskAddPage({this.docId = null});
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  var docId;
  void initState() {
    super.initState();
    if (widget.docId != null) {
      docId = widget.docId;
    }
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: ColorConstants.BgYELLOW,
              hourMinuteTextColor: ColorConstants.TXTCOLOR,
              dialHandColor: ColorConstants.PRIMARYCOLOR,
              entryModeIconColor: ColorConstants.PRIMARYCOLOR,
            ),
            colorScheme: ColorScheme.light(
              primary: ColorConstants.PRIMARYCOLOR,
              onPrimary: ColorConstants.TXTCOLOR,
              onSurface: ColorConstants.TXTCOLOR,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConstants.PRIMARYCOLOR, // header background
              onPrimary: ColorConstants.TXTCOLOR, // header text color
              onSurface: ColorConstants.TXTCOLOR, // default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    ColorConstants.HYPERLINK, // button text (e.g. CANCEL)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;

      if (_selectedDate != null && _selectedTime != null) {
        final remainderTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        if (docId != null) {
          log("Going to edit");
          context.read<TaskBloc>().add(
            EditTaskEvent(
              docId: docId,
              title: title,
              description: description,
              date: remainderTime,
            ),
          );
        } else {
          log("Going to add");

          context.read<TaskBloc>().add(
            SubmitTaskEvent(
              date: remainderTime,
              title: title,
              description: description,
            ),
          );
        }
      } else {
        if (docId != null) {
          log("Going to edit 2");
          context.read<TaskBloc>().add(
            EditTaskEvent(docId: docId, title: title, description: description),
          );
        } else {
          log("Going to add 2");

          context.read<TaskBloc>().add(
            SubmitTaskEvent(title: title, description: description),
          );
        }
      }
    } else {
      PopupMsg.popUpMsg(
        msg: "Fill both title and description of the task",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.BgYELLOW,
      appBar: AppBar(
        title: Text(docId == null ? "Add Task" : "Edit Task"),
        backgroundColor: ColorConstants.PRIMARYCOLOR,
        iconTheme: IconThemeData(color: ColorConstants.TXTCOLOR),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskAddedSuccessState ||
                  state is TaskWithoutRemainderAddingState) {
                Navigator.pop(context);
                PopupMsg.popUpMsg(
                  msg: "Task added successfully",
                  context: context,
                );
              } else if (state is TaskIncompleteState) {
                PopupMsg.popUpMsg(msg: state.msg, context: context);
              } else if (state is TaskEditSuccess) {
                Navigator.pop(context);

                PopupMsg.popUpMsg(
                  msg: "Task Updated Successfully",
                  context: context,
                );
              } else if (state is TaskUpdationFailedState) {
                PopupMsg.popUpMsg(msg: state.error, context: context);
              } else {
                PopupMsg.popUpMsg(msg: "Failed to add task", context: context);
              }
            },
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: ColorConstants.TXTFLDFILL,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Task Title",
                    prefixIcon: Icon(
                      Icons.title,
                      color: ColorConstants.ICONCOLOR,
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Title is required"
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    fillColor: ColorConstants.TXTFLDFILL,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: ColorConstants.TEXTFIELDBORDERS,
                      ),
                    ),
                    labelText: "Description",
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.FOCUSEDTEXTFIELDBORDERS,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: ColorConstants.ICONCOLOR,
                  ),
                  title: Text(
                    _selectedDate == null
                        ? "Select Due Date"
                        : "Due Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: TextStyle(color: ColorConstants.TXTCOLOR),
                  ),
                  onTap: _pickDate,
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: ColorConstants.ICONCOLOR,
                  ),
                  title: Text(
                    _selectedTime == null
                        ? "Select Time"
                        : "Time: ${_selectedTime!.format(context)}",
                    style: TextStyle(color: ColorConstants.TXTCOLOR),
                  ),
                  onTap: _pickTime,
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: _submitTask,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorConstants.PRIMARYCOLOR,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, color: ColorConstants.TXTCOLOR),
                        const SizedBox(width: 10),
                        Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 15,
                            color: ColorConstants.TXTCOLOR,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
