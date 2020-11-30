import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GroPlan());
}

class GroPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryTextTheme:
              TextTheme(headline1: TextStyle(fontFamily: 'Roboto')),
          primaryColor: Color(0xFF72C077),
          scaffoldBackgroundColor: Color(0xFFE0E5EC),
          appBarTheme: AppBarTheme(
              color: Color(0xFF72C077),
              centerTitle: true,
              textTheme: TextTheme(
                  title: TextStyle(fontFamily: 'Roboto', fontSize: 20)))),
      home: HomePage(),
    );
  }
}
