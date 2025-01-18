import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:youth_power/core/component/my_toast.dart';

import 'core/constants/app_constant.dart';
import 'core/constants/lists.dart';
import 'core/functions/global_variable.dart';
import 'core/services/bloc_observer.dart';
import 'core/theme/light.dart';
import 'feature/controller/activity_cubit/activity_cubit.dart';
import 'feature/controller/home_cubit/home_cubit.dart';
import 'feature/controller/setting_cubit/setting_cubit.dart';
import 'feature/controller/student_cubit/student_cubit.dart';
import 'feature/controller/week_cubit/week_cubit.dart';
import 'feature/view/home/screen/home_layout.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
@pragma('vm:entry-point')
void callbackDispatcher() async{
  Workmanager().executeTask((task, inputData) async {
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      MyToast(msg: 'hi there it works $task', state: ToastStates.SUCCESS);
      GlobalFunction.print('hi there it works');
      await StudentCubit.scheduleBirthdayNotifications();


      return Future.value(true);
    }catch(e,stack){
      print("WorkManager task failed: $e");
      MyToast(msg: 'hi there it $e', state: ToastStates.FAILED);

      print("Stack trace: $stack");
      return Future.value(false); // Task failed
    }


  });
}
void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // Provide your app icon.

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  tz.initializeTimeZones();
  Workmanager().initialize(callbackDispatcher,);
  Workmanager().registerPeriodicTask(
      "birthdayCheck",
      "birthdayNotification",
      initialDelay: Duration(seconds: 1),
      frequency: Duration(minutes: 15),
      inputData: {},
      constraints: Constraints(networkType: NetworkType.connected,requiresBatteryNotLow: false,requiresCharging: false,requiresDeviceIdle: false,requiresStorageNotLow: false)
  );
  Bloc.observer = MyBlocObserver();
  runApp(
    EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: lang,
      path: 'assets/languages',
      startLocale: const Locale('ar'),
      child:  const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> WeekCubit()..createDatabase()),
        BlocProvider(create: (context)=> HomeCubit()),
        BlocProvider(create: (context)=> ActivityCubit()..getActivity()),
        BlocProvider(create: (context)=> StudentCubit()..getStudent()),
        BlocProvider(create: (context)=> SettingCubit()),
      ],
      child: MaterialApp(
            title: AppConstant.appTitle,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: light,
            home:  const HomeLayout(),
          ),
    );
  }
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Fire store,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GlobalFunction.print("Handling a background message: ${message.messageId}");
}