import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teelo_flutter/responsive/mobile_screen_Layout.dart';
import 'package:teelo_flutter/responsive/responsive_layout_screen.dart';
import 'package:teelo_flutter/responsive/web_screen_Layout.dart';
import 'package:teelo_flutter/screens/login_screen.dart';
import 'package:teelo_flutter/screens/signup_screen.dart';
import 'package:teelo_flutter/utils/colors.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyA1VUcb2fsmVJmHuPIP7bqgzVfjaK914g0',
            appId: '1:148999610966:web:60160e5d8b068ac44d91f7',
            messagingSenderId: '148999610966',
            projectId: 'teelo-mobile-app',
            storageBucket: 'teelo-mobile-app.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teelo social app',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // )
        home: SignUpScreen(),
        );
  }
}
