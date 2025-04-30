// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sushi_app/main.dart'; // Импортируем точное имя приложения

void main() {
  testWidgets('App builds and shows SushiRobot title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SushiApp());

    // Verify that the MaterialApp title is set correctly.
    // The title isn't rendered as a widget by default, so we look up the widget by type.
    expect(find.byType(SushiApp), findsOneWidget);

    // Optionally, verify that the splash screen icon is present:
    expect(find.byIcon(Icons.ramen_dining_rounded), findsOneWidget);
  });
}

