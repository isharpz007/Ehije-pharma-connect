import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ehije_pharma_connect/main.dart';
import 'package:ehije_pharma_connect/address.dart';
import 'package:ehije_pharma_connect/addresses_screen.dart';
import 'package:ehije_pharma_connect/login_screen.dart';
import 'package:ehije_pharma_connect/order.dart';
import 'package:ehije_pharma_connect/orders_screen.dart';

void main() {
  group('App Smoke Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Model Tests', () {
    testWidgets('Address model creates correctly', (WidgetTester tester) async {
      // Test Address model directly - note: Address doesn't have userId field
      final testAddress = Address(
        id: 1,
        label: 'Home',
        line1: '123 Main Street',
        line2: 'Apt 4B',
        isDefault: true,
      );

      expect(testAddress.id, equals(1));
      expect(testAddress.label, equals('Home'));
      expect(testAddress.line1, equals('123 Main Street'));
      expect(testAddress.line2, equals('Apt 4B'));
      expect(testAddress.isDefault, equals(true));
    });

    testWidgets('Address fromMap factory works correctly', (WidgetTester tester) async {
      final Map<String, dynamic> mapData = {
        'id': 2,
        'label': 'Office',
        'line1': '456 Business Rd',
        'line2': 'Suite 100',
        'is_default': false,
      };

      final address = Address.fromMap(mapData);

      expect(address.id, equals(2));
      expect(address.label, equals('Office'));
      expect(address.line1, equals('456 Business Rd'));
      expect(address.line2, equals('Suite 100'));
      expect(address.isDefault, equals(false));
    });

    testWidgets('OrderData model works correctly', (WidgetTester tester) async {
      final testOrder = OrderData(
        id: 789,
        orderNumber: '#PC-MODELTEST',
        pharmacy: 'Model Test Pharmacy',
        status: 'processing',
        subtotal: 50.00,
        deliveryFee: 7.50,
        total: 57.50,
        deliveryAddress: '789 Model Test Lane',
        createdAt: DateTime(2024, 1, 20, 9, 15),
        items: [],
      );

      expect(testOrder.id, equals(789));
      expect(testOrder.orderNumber, equals('#PC-MODELTEST'));
      expect(testOrder.pharmacy, equals('Model Test Pharmacy'));
      expect(testOrder.status, equals('processing'));
      expect(testOrder.subtotal, equals(50.00));
      expect(testOrder.deliveryFee, equals(7.50));
      expect(testOrder.total, equals(57.50));
      expect(testOrder.deliveryAddress, equals('789 Model Test Lane'));
      expect(testOrder.items.isEmpty, isTrue);
    });
  });

  group('Screen Smoke Tests', () {
    testWidgets('Orders screen renders without throwing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: OrdersScreen(),
      ));

      // Wait for any initial loading
      await tester.pump(const Duration(seconds: 2));

      // Should at least show the app structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);
    });

    testWidgets('Addresses screen renders without throwing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AddressesScreen(),
      ));

      // Wait for any initial loading
      await tester.pump(const Duration(seconds: 2));

      // Should at least show the app structure
      expect(find.byType(Scaffold), findsOneWidget);
      // AddressesScreen has a back button instead of AppBar
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('My Addresses'), findsOneWidget);
    });

    testWidgets('Login screen renders without throwing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: LoginScreen(),
      ));

      // Wait for any initial loading
      await tester.pump();

      // Should show login form elements
      expect(find.byType(Scaffold), findsOneWidget);
      // LoginScreen has a back button instead of AppBar
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextField), findsAtLeast(2)); // Email and password
    });
  });

  group('Navigation Tests', () {
    testWidgets('Navigation from splash screen works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Wait for splash screen to show
      await tester.pumpAndSettle();

      // Tap "Get Started" button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('Widget Tests (Direct Rendering)', () {
    // Test that we can render key widgets without errors
    testWidgets('Can render orders screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: OrdersScreen(),
      ));

      await tester.pumpAndSettle();

      // Just verify it doesn't throw during build
      expect(find.byType(OrdersScreen), findsOneWidget);
    });

    testWidgets('Can render addresses screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AddressesScreen(),
      ));

      await tester.pumpAndSettle();

      // Just verify it doesn't throw during build
      expect(find.byType(AddressesScreen), findsOneWidget);
    });

    testWidgets('Address model validation', (WidgetTester tester) async {
      // Test Address model which is used in addresses screen
      final testAddress = Address(
        id: 1,
        label: 'Test Address',
        line1: '123 Test Street',
        line2: 'Test City, TC',
        isDefault: true,
      );

      expect(testAddress.label, equals('Test Address'));
      expect(testAddress.line1, equals('123 Test Street'));
      expect(testAddress.isDefault, isTrue);
    });
  });
}