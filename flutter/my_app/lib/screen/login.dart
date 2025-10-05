import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screen/home.dart';

//エラーメッセージ
const unexpectedErr = SnackBar(
  content: Text('予期しないエラーが発生しました。システム管理者にお問い合わせください。'),
  backgroundColor: Colors.red,
);

const loginFailed = SnackBar(
  content: Text('メールアドレスまたはパスワードが異なります。'),
  backgroundColor: Colors.red,
);

const internalServiceErr = SnackBar(
  content: Text('サーバー内エラーが発生しました。システム管理者にお問い合わせください。'),
  backgroundColor: Colors.red,
);
//////////////

class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({Key? key}) : super(key: key);

  @override
  _SimpleLoginScreenState createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  String email = '';
  String password = '';
  bool hidePassword = true;

  //ローカルホストにPOSTリクエストを送信
  //メールアドレス・パスワードを渡す
  Future<void> postData(String mail, String pw) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"mail_address": mail, "password": pw}),
    );

    switch (response.statusCode) {
      //200の場合 OK。ホーム画面へ遷移
      case 200:
        var data = json.decode(response.body);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(e_mail: mail);
            },
          ),
        );
        break;

      //500の場合 internal server error
      case 500:
        ScaffoldMessenger.of(context).showSnackBar(internalServiceErr);
        break;

      //599の場合 メールアドレスまたはパスワードが異なる
      case 599:
        ScaffoldMessenger.of(context).showSnackBar(loginFailed);
        break;

      //予期しないエラー
      default:
        ScaffoldMessenger.of(context).showSnackBar(unexpectedErr);
    } //end of switch
  } //end of postData

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クラヴマガ習熟度チェッカー'),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: 'hogehoge@qmail.com',
                  labelText: 'メールアドレス',
                ),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'パスワード',
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  postData(email, password);
                },
                child: const Text('ログイン'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
              ),
              Container(margin: EdgeInsets.only(bottom: 20)),
              RichText(
                text: TextSpan(
                  text: 'パスワードを忘れた場合',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
