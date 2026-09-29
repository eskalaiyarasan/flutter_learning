import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixside/sixside.dart';

void main() {
  setUp(() {
    BaseObject.registry.clear();
  });

  testWidgets('BaseObject.action resets the matching widget and increments all others', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              CoreActionWidget(3, 100),
              CoreActionWidget(8, 100),
            ],
          ),
        ),
      ),
    );

    final firstState = tester.state(find.byType(CoreActionWidget).at(0)) as CoreActionWidgetState;
    final secondState = tester.state(find.byType(CoreActionWidget).at(1)) as CoreActionWidgetState;

    await BaseObject.action(firstState.getName());
    await tester.pump(const Duration(milliseconds: 700));

    expect(firstState.getNumber(), 0);
    expect(secondState.getNumber(), 9);
  });

  testWidgets('BaseObject.action skips the matching widget while incrementing the rest', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              CoreActionWidget(3, 100),
              CoreActionWidget(8, 100),
            ],
          ),
        ),
      ),
    );

    final firstState = tester.state(find.byType(CoreActionWidget).at(0)) as CoreActionWidgetState;
    final secondState = tester.state(find.byType(CoreActionWidget).at(1)) as CoreActionWidgetState;

    await BaseObject.action(secondState.getName());
    await tester.pump(const Duration(milliseconds: 700));

    expect(firstState.getNumber(), 4);
    expect(secondState.getNumber(), 8);
  });

  testWidgets('BaseObject.action increments all widgets when the requested name is missing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              CoreActionWidget(3, 100),
              CoreActionWidget(8, 100),
            ],
          ),
        ),
      ),
    );

    final firstState = tester.state(find.byType(CoreActionWidget).at(0)) as CoreActionWidgetState;
    final secondState = tester.state(find.byType(CoreActionWidget).at(1)) as CoreActionWidgetState;

    await BaseObject.action('missing-name');
    await tester.pump(const Duration(milliseconds: 700));

    expect(firstState.getNumber(), 4);
    expect(secondState.getNumber(), 9);
  });

  testWidgets('CoreActionWidget renders both active and inactive color states', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoreActionWidget(5, 100),
        ),
      ),
    );

    final coloredCells = tester
        .widgetList<Container>(
          find.byWidgetPredicate(
            (widget) => widget is Container &&
                (widget.color == Colors.amber || widget.color == Colors.limeAccent),
          ),
        )
        .toList();

    expect(coloredCells, isNotEmpty);
    expect(coloredCells.any((cell) => cell.color == Colors.amber), isTrue);
    expect(coloredCells.any((cell) => cell.color == Colors.limeAccent), isTrue);
  });
}
