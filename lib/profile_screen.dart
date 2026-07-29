import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_bottom_nav.dart';
import 'addresses_screen.dart';
import 'auth/auth_service.dart';
import 'notifications_screen.dart';
import 'prescription_upload_screen.dart';
import 'help_support_screen.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currentModeLabel = 'System';
  final Color primaryBlue = const Color(0xFF3B3FE0);
  final Color darkNavy = const Color(0xFF1A1B3A);
  final Color hintGrey = const Color(0xFF9B9FB1);
  final Color borderGrey = const Color(0xFFE1E3EC);
  final Color green = const Color(0xFF1F8B3F);

  @override
  void initState() {
    super.initState();
    _loadCurrentMode();
  }

  Future<void> _loadCurrentMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? modeString = prefs.getString('theme_mode');
    if (mounted) {
      setState(() {
        _currentModeLabel = modeString ?? 'system';
        // Capitalize first letter
        _currentModeLabel =
            _currentModeLabel[0].toUpperCase() + _currentModeLabel.substring(1);
      });
    }
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    // Use the global key to access the MyAppState
    await appKey.currentState?.setThemeMode(mode);
    if (mounted) {
      await _loadCurrentMode(); // Reload the mode to update the UI
    }
  }

  void _showThemeModeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: _themeModeFromString(_currentModeLabel.toLowerCase()),
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: const Text('System'),
              ),
              ListTile(
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: _themeModeFromString(_currentModeLabel.toLowerCase()),
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: const Text('Light'),
              ),
              ListTile(
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: _themeModeFromString(_currentModeLabel.toLowerCase()),
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      _setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: const Text('Dark'),
              ),
            ],
          ),
        );
      },
    );
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, const Color(0xFF5B5FEA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: primaryBlue, size: 34),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AuthService.instance.currentUser?['name'] as String? ??
                                      'Guest',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AuthService.instance.currentUser?['email'] as String? ??
                                      'Not signed in',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                                if ((AuthService.instance.currentUser?['phone'] as String?)
                                        ?.isNotEmpty ==
                                    true)
                                  Text(
                                    AuthService.instance.currentUser!['phone'] as String,
                                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.verified, size: 14, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Theme Mode Tile
                    ListTile(
                      leading: const Icon(Icons.brightness_6_outlined),
                      title: const Text('Theme Mode'),
                      trailing: Text(_currentModeLabel),
                      onTap: _showThemeModeDialog,
                    ),
                    const Divider(height: 1),

                    _MenuTile(
                      icon: Icons.location_on_outlined,
                      label: 'My Addresses',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AddressesScreen()),
                        );
                      },
                    ),
                    _MenuTile(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () {},
                    ),
                    _MenuTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifications',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        );
                      },
                    ),
                    _MenuTile(
                      icon: Icons.upload_file_outlined,
                      label: 'Prescription Uploads',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PrescriptionUploadScreen()),
                        );
                      },
                    ),
                    _MenuTile(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () async {
                          await AuthService.instance.logOut();
                          if (!context.mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MyApp()),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE0473F),
                          side: BorderSide(color: borderGrey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNav(current: AppTab.profile),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: darkNavy),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkNavy,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: hintGrey),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: borderGrey),
      ],
    );
  }
}