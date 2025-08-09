import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_app/blocs/login/login_bloc.dart';
import 'package:task_app/blocs/register/register_bloc.dart';
import 'package:task_app/blocs/task/task_bloc.dart';
import 'package:task_app/views/auth_handler/auth_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_app/views/services/notification_scheduler.dart';
import 'package:task_app/views/services/notification_services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestExactAlarmPermission();
  await NotificationService().initialize();
  runApp(MyApp());
  await TaskScheduler().scheduleAllTaskNotifications();
  await requestNotificationPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => TaskBloc()),
      ],
      child: MaterialApp(home: AuthHandler(), themeMode: ThemeMode.system),
    );
  }
}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;

  if (!status.isGranted) {
    if (await Permission.notification.request().isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  } else {
    print('Notification permission already granted');
  }
}

Future<bool> requestExactAlarmPermission() async {
  const platform = MethodChannel('exact_alarm_channel');
  try {
    final result = await platform.invokeMethod('requestExactAlarmPermission');
    return result == true;
  } on PlatformException catch (e) {
    print("Failed to request exact alarm permission: ${e.message}");
    return false;
  }
}
