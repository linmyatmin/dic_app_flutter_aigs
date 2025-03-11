import 'package:dic_app_flutter/models/user_model.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/screens/aboutus_screen.dart';
import 'package:dic_app_flutter/screens/profile_screen.dart';
import 'package:dic_app_flutter/screens/register_screen.dart';
import 'package:dic_app_flutter/screens/login_screen.dart';
import 'package:dic_app_flutter/screens/setting_screen.dart';
import 'package:dic_app_flutter/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerNavigation extends ConsumerWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final member = authState.user;
    final bool userLoggedIn = authState.isAuthenticated && member != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? Theme.of(context).primaryColor : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: _buildHeader(context, userLoggedIn, member),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ..._buildMenuItems(context, userLoggedIn, isDark),
                ],
              ),
            ),
            _buildFooter(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool userLoggedIn, UserModel? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: userLoggedIn && user != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Text(
                      user.userName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildMenuItems(
      BuildContext context, bool userLoggedIn, bool isDark) {
    return [
      const SizedBox(height: 8),
      if (userLoggedIn) ...[
        _buildListTile(
          context: context,
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () => _navigateTo(context, const ProfileScreen()),
          isDark: isDark,
        ),
      ] else ...[
        _buildListTile(
          context: context,
          icon: Icons.login,
          title: 'Sign In',
          onTap: () => _navigateTo(context, LoginScreen()),
          isDark: isDark,
        ),
      ],
      _buildListTile(
        context: context,
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () => _navigateTo(context, const SettingScreen()),
        isDark: isDark,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(),
      ),
      _buildListTile(
        context: context,
        icon: Icons.info_outline,
        title: 'About Us',
        onTap: () => _navigateTo(context, const AboutUsScreen()),
        isDark: isDark,
      ),
    ];
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      leading: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.black54,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.diamond_outlined,
            size: 16,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          const SizedBox(width: 8),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
