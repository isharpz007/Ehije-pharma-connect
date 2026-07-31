// // Smoke test for Ehije Pharma Connect.
// //
// // Verifies the app boots without throwing and renders its root widget.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:ehije_pharma_connect/main.dart';

// void main() {
//   testWidgets('App boots and renders root widget', (WidgetTester tester) async {
//     // Note: Supabase.initialize is async and called in main(); here we just
//     // verify the MyApp widget itself builds without errors.
//     await tester.pumpWidget(const MyApp());

//     // MyApp uses a MaterialApp with SplashScreen as home — verify both mounted.
//     expect(find.byType(MaterialApp), findsOneWidget);
//   });
// }


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ehije_pharma_connect/main.dart';

void main() {

  testWidgets('App launches successfully',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MyApp()
    );

    expect(
      find.byType(MaterialApp),
      findsOneWidget
    );

  });

}