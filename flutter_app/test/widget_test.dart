import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_study/main.dart';
import 'package:nexus_study/screens/lab_screen.dart';
import 'package:nexus_study/widgets/visual_diagram_card.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusStudyApp());
    expect(find.byType(NexusStudyApp), findsOneWidget);
  });

  testWidgets('LabScreen renders all simulation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LabScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('NEXUS Lab (総合可視化実験室・全22種)'), findsOneWidget);
    expect(find.text('数学グラフ'), findsOneWidget);
    expect(find.text('物理・力学/光学'), findsOneWidget);
    expect(find.text('化学・周期表/平衡'), findsOneWidget);
    expect(find.text('生物・地学'), findsOneWidget);
    expect(find.text('歴史タイムライン'), findsOneWidget);
    expect(find.text('情報・アルゴリズム'), findsOneWidget);
  });

  testWidgets('VisualDiagramCard renders dynamically for math and physics', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VisualDiagramCard(
            subjectId: 'math',
            questionText: '2次関数のグラフ頂点を求めよ',
            explanation: '平方完成により頂点の座標を計算します。',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('数式・放物線グラフ可視化'), findsOneWidget);
  });
}
