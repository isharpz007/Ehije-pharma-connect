import 'package:flutter/material.dart';
import 'package:my_app/home_screen.dart';

import 'login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmaConnect',
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const Color primaryBlue = Color(0xFF2F3FE0);
  static const Color tealGreen = Color(0xFF17B37A);
  static const Color darkNavy = Color(0xFF1A1B3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 48),
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryBlue, tealGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // App name
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(text: 'Pharma', style: TextStyle(color: darkNavy)),
                      TextSpan(text: 'Connect', style: TextStyle(color: tealGreen)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trusted medicines,\ndelivered to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8A8FA3),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Illustration area
                Expanded(child: _DeliveryIllustration()),

                const SizedBox(height: 8),

                // Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                

                // Continue as Guest
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: darkNavy,
                        side: const BorderSide(color: Color(0xFFE1E3EC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Secure badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF8A8FA3)),
                    SizedBox(width: 6),
                    Text(
                      '100% secure & trusted',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8FA3)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A stylized delivery-rider illustration built entirely from shapes,
/// so no external image assets are required.
class _DeliveryIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEFF3FF), Color(0xFFE3ECFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // City skyline silhouette
              Positioned(
                left: 0,
                right: 0,
                bottom: 30,
                child: Opacity(
                  opacity: 0.35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _building(30, 70),
                      _building(24, 100),
                      _building(28, 60),
                      _building(20, 90),
                      _building(26, 75),
                    ],
                  ),
                ),
              ),
              // Location pin
              const Positioned(
                top: 12,
                right: 24,
                child: Icon(Icons.location_on, color: SplashScreen.tealGreen, size: 32),
              ),
              // Delivery box + rider
              Positioned(
                bottom: 24,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Medicine crate
                        Container(
                          width: 44,
                          height: 40,
                          margin: const EdgeInsets.only(right: 4, bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: SplashScreen.tealGreen, width: 2),
                          ),
                          child: const Icon(Icons.add, color: SplashScreen.tealGreen, size: 20),
                        ),
                        // Rider + scooter
                        Column(
                          children: [
                            const Icon(Icons.sports_motorsports,
                                size: 34, color: SplashScreen.primaryBlue),
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: SplashScreen.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Icon(Icons.two_wheeler, size: 54, color: SplashScreen.primaryBlue.withOpacity(0.9)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _building(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF6C7AE0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    );
  }
}