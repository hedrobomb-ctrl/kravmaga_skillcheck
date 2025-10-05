import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screen/skillCheckerTab.dart';

void main() {
  //ログイン画面描画の共通処理
  MaterialApp skillCheckerApp(String mail) {
    return MaterialApp(
      home: Scaffold(body: Skillchecker(e_mail: mail)),
    );
  }

  /*TODO: サーバーとの通信処理を画面生成クラス内で行う場合のテストの方法を確立する*/

  group('カリキュラム画面', () {
    testWidgets('コンテンツ表示テスト：ドロップダウン(技）', (WidgetTester tester) async {
      await tester.pumpWidget(skillCheckerApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(DropdownMenu).at(0), findsOneWidget);
      expect(find.text('習熟度を更新したい技を選択してください'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：ドロップダウン(レベル）', (WidgetTester tester) async {
      await tester.pumpWidget(skillCheckerApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(DropdownMenu).at(1), findsOneWidget);
      expect(find.text('習熟度を選択してください'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：ボタン', (WidgetTester tester) async {
      await tester.pumpWidget(skillCheckerApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('更新'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：ドロップダウン(ベルト）', (WidgetTester tester) async {
      await tester.pumpWidget(skillCheckerApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(DropdownMenu).at(2), findsOneWidget);
      expect(find.text('ベルト：'), findsOneWidget);
    });

    testWidgets('コンテンツ表示テスト：ドロップダウンメニュー', (WidgetTester tester) async {
      await tester.pumpWidget(skillCheckerApp("hogehoge@gmail.com"));
      await tester.pump(Duration(seconds: 1)); //状態変更を反映

      expect(find.byType(DropdownMenuItem).at(0), findsOneWidget);
      expect(find.text('イエローベルト'), findsOneWidget);

      expect(find.byType(DropdownMenuItem).at(1), findsOneWidget);
      expect(find.text('オレンジベルト'), findsOneWidget);

      expect(find.byType(DropdownMenuItem).at(2), findsOneWidget);
      expect(find.text('グリーンベルト'), findsOneWidget);

      expect(find.byType(DropdownMenuItem).at(3), findsOneWidget);
      expect(find.text('ブルーベルト'), findsOneWidget);

      expect(find.byType(DropdownMenuItem).at(4), findsOneWidget);
      expect(find.text('ブラウンベルト'), findsOneWidget);
    });
  }); //end of group
}
