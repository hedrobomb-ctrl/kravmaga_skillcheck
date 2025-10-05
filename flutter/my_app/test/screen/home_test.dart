import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screen/home.dart';

void main() {
  //ログイン画面描画の共通処理
  MaterialApp indexApp(String mail) {
    return MaterialApp(
      home: Scaffold(body: HomeScreen(e_mail: mail)),
    );
  }

  /*TODO: サーバーとの通信処理を画面生成クラス内で行う場合のテストの方法を確立する*/
  group('メニュー画面', () {
    testWidgets('ラベル表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('■会員情報'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：会員ID', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('会員ID'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：会員種別', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('会員種別'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：参加可能クラス数', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('今月参加できるクラス数'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：ベルト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('保有しているベルト'), findsOneWidget);
    });

    testWidgets('ラベル表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp('hogehoge@gmail.com'));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.text('■予約中のクラス'), findsOneWidget);
    });

    testWidgets('メニューバー表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp('hogehoge@gmail.com'));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('ホームメニュー表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp('hogehoge@gmail.com'));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('ホーム'), findsOneWidget);
    });

    testWidgets('カリキュラムメニュー表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(indexApp('hogehoge@gmail.com'));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('カリキュラム'), findsOneWidget);
    });
  }); //end of group
}
