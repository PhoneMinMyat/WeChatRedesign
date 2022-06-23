import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/fcm/fcm_service.dart';
import 'package:wechat_redesign/pages/home_page.dart';
import 'package:wechat_redesign/pages/registration_pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForNotification();
  FCMService().getFcmToken().then(((value) => print('fcm token ===> $value')));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationModel authenticationModel = AuthenticationModelImpl();

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (authenticationModel.isLoggedIn())
          ? const HomePage()
          : const WelcomePage(),
    );
  }
}
