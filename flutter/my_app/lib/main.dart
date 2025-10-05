import 'package:flutter/material.dart';
import 'package:my_app/screen/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //ログイン画面を表示する
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Form', home: SimpleLoginScreen());
  }
}
