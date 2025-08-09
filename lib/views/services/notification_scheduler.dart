import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/views/services/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskScheduler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NotificationService notiServices = NotificationService();
  Future<void> scheduleAllTaskNotifications() async {
    final querySnapshot = await _firestore.collection('tasks').get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      log("$data");

      final title = data['name'] ?? 'No title';
      final body = data['description'] ?? 'No body';
      if (data["remainder"] == null) {
        continue;
      }
      final timestamp = data['remainder'] as Timestamp;
      if (timestamp == null) {
        log("No timestamp found for document: ${doc.id}");
        continue; // Skip this document if no timestamp is found
      }
      // Convert the timestamp to a DateTime object
      final scheduledDate = timestamp.toDate().toUtc();
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      if (tzScheduledDate.isBefore(DateTime.now())) {
        continue;
      }

      await notiServices.initialize();
      try {
        await notiServices.scheduleNotification(
          id: doc.id.hashCode, // You can also use doc.id.hashCode
          title: "Reminder for $title task",
          body: body,
          scheduledDate: tzScheduledDate,
        );
      } catch (e) {
        log("$e");
      }
    }
  }
}
