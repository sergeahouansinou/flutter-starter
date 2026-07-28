import 'package:cardifly/config/storage_manager.dart';
import 'package:cardifly/main.dart';
import 'package:cardifly/screens/home/home_one/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageManager.init();
  });

  testWidgets('MainApp boots the HomeScreen', (tester) async {
    await tester.pumpWidget(const MainApp());
    // Drain the simulated initial fetch (900ms) + entry animation.
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
