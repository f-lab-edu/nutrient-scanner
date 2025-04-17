import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_scanner/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Main page - Tap Scan Button', (WidgetTester tester) async {
    Future<void> pumpUntil(
      WidgetTester tester,
      Finder finder, {
      Duration timeout = const Duration(seconds: 10),
      Duration interval = const Duration(milliseconds: 100),
    }) async {
      final endTime = DateTime.now().add(timeout);

      while (DateTime.now().isBefore(endTime)) {
        await tester.pump(interval);

        if (finder.evaluate().isNotEmpty) {
          return;
        }
      }
      throw Exception('timeout');
    }

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MyHomePage(title: 'Test Title'),
        ),
      ),
    );
    await tester.tap(find.text('Scan Nutrient Label'));
    await tester.pumpAndSettle();
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    await tester.tap(find.text('GPT한테 물어보러 가기'));
    await tester.pumpAndSettle();

    expect(find.text('OCR 데이터 확인하기'), findsOneWidget);
    await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'GPT 역할 입력...'),
        '너는 영양사야. 이 제품의 영양 성분을 분석해줘.');

    // Enter text into the user text field
    await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'GPT에게 어떻게 물어볼지 입력...'),
        '무슬림, 비건, 알러지 관련해서 문제가 될 만한 성분이 있는지 확인하고 결과를 알려줘. 성분:밀,대두,우유,땅콩,계란,돼지고기,쇠고기');
    await tester.tap(find.text('OCR데이터와 함께 GPT에게 물어보기'));
    await pumpUntil(
      tester,
      find.textContaining('GPT의 답변:'),
      timeout: const Duration(seconds: 20),
    );
  });
}
