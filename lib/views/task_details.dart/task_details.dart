import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/utils/color_utils.dart';
import 'package:task_app/views/tasks/add_tasks_screen.dart';

class TaskDetails extends StatelessWidget {
  TaskDetails({super.key, required this.selectedDocument});
  var selectedDocument;
  var reminderTime;

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    final data = selectedDocument.data() as Map<String, dynamic>;
    final hasReminder = data.containsKey('remainder');
    final Timestamp? reminderTime = hasReminder ? data['remainder'] : null;
    log(hasReminder.toString());
    return Scaffold(
      backgroundColor: ColorConstants.BgYELLOW,
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: ColorConstants.PRIMARYCOLOR,
        toolbarHeight: 75,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
          ],
          // borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Task name:  ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${selectedDocument["name"]}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Task description:  ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${selectedDocument["description"]}",

                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),

            reminderTime == null
                ? const SizedBox()
                : Row(
                  children: [
                    Text(
                      "Reminder Time:  ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${formatTimestamp(reminderTime)}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  TaskAddPage(docId: selectedDocument.id),
                        ),
                      ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                      color: ColorConstants.PRIMARYCOLOR,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Edit task",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorConstants.TXTCOLOR,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
