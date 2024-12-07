// import 'package:flutter/material.dart';
// import 'package:sell_karo_india/homepage/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sell_karo_india/firebase_options.dart';
import 'package:sell_karo_india/language/model/locale.dart';

import 'bottomFile/Like_screen.dart';
import 'bottomFile/account.dart';
import 'bottomFile/add_post.dart';
import 'bottomFile/chat.dart';
import 'components/auth_page.dart';
import 'homepage/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Global object for accessing device screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase(); // Await the Firebase initialization
  await _requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeModel = Provider.of<LocaleModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeModel.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const AuthPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/LikeScreen': (context) => LikeScreen(),
        '/AddPost': (context) => const AddPost(),
        '/ChatBottom': (context) => const ChatBottom(),
        '/AccountBottom': (context) => const AccountBottom(),
      },
    );
  }
}

Future<void> _requestPermissions() async {
  if (Platform.isAndroid || Platform.isIOS) {
    await Permission.notification.request();
  }
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );

  log('\nNotification Channel Result: $result');
}
