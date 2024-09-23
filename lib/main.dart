import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_power/feature/controller/activity_cubit/activity_cubit.dart';
import 'package:youth_power/feature/controller/home_cubit/home_cubit.dart';
import 'package:youth_power/feature/controller/setting_cubit/setting_cubit.dart';
import 'package:youth_power/feature/controller/student_cubit/student_cubit.dart';
import 'package:youth_power/feature/controller/week_cubit/week_cubit.dart';

import 'core/constants/lists.dart';
import 'core/functions/global_variable.dart';
import 'core/services/bloc_observer.dart';
import 'core/theme/light.dart';
import 'feature/view/home/screen/home_layout.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
        BlocProvider(create: (context)=> HomeCubit()..createDatabase()),
        BlocProvider(create: (context)=> ActivityCubit()..getActivity()),
        BlocProvider(create: (context)=> StudentCubit()..getStudent()),
        BlocProvider(create: (context)=> WeekCubit()..getWeek()),
        BlocProvider(create: (context)=>SettingCubit()),
      ],
      child: MaterialApp(
        title: 'YOUTH Power',
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