import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:ehije_pharma_connect/main.dart';


void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets(
    'Complete app user journey',
    (WidgetTester tester) async {


      // Start the app
      await tester.pumpWidget(
        const MyApp()
      );


      // Wait for app loading
      await tester.pumpAndSettle();


      // Check app opens
      expect(
        find.byType(MaterialApp),
        findsOneWidget
      );


      // Check login screen
      expect(
        find.text('Login'),
        findsOneWidget
      );


      // Tap login button
      await tester.tap(
        find.text('Login')
      );


      await tester.pumpAndSettle();


      // Check dashboard opens
      expect(
        find.text('Dashboard'),
        findsOneWidget
      );


      // Navigate profile
      await tester.tap(
        find.text('Profile')
      );


      await tester.pumpAndSettle();


      expect(
        find.text('Profile'),
        findsOneWidget
      );


    }
  );
}