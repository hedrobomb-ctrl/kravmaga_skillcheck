import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screen/login.dart';

void main() {
  //ログイン画面描画の共通処理
  MaterialApp loginApp() {
    return MaterialApp(home: Scaffold(body: SimpleLoginScreen()));
  }

  group('ログイン画面', () {
    testWidgets('ラベル表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.text('クラヴマガ習熟度チェッカー'), findsOneWidget);
    });

    testWidgets('ログインボタン表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('ログイン'), findsOneWidget);
    });

    testWidgets('メールアドレス入力フィールド表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.text('メールアドレス'), findsOneWidget);
    });

    testWidgets('パスワード入力フィールド表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.text('パスワード'), findsOneWidget);
    });

    testWidgets('パスワードが初期表示でhideになっているか', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('パスワードリセットメニュー表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.byType(RichText).at(0), findsOneWidget);
    });

    testWidgets('ID・PW不正メッセージテスト', (WidgetTester tester) async {
      await tester.pumpWidget(loginApp());

      expect(find.text('メールアドレスまたはパスワードが異なります。'), findsNothing);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'hogehoge@gmail.com',
      );

      await tester.enterText(find.byType(TextFormField).at(1), 'testxxxxxx');

      await tester.tap(find.byType(ElevatedButton)); //ボタンをタップ
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(SnackBar), findsOneWidget);
    });
  }); //end of group
}
