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
    print('DrawerNavigation - Auth State:');
    print('isAuthenticated: ${authState.isAuthenticated}');
    print('user: ${authState.user?.email}');

    final member = authState.user;
    final bool userLoggedIn = authState.isAuthenticated && member != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context, userLoggedIn, member),
          ..._buildMenuItems(context, userLoggedIn),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool userLoggedIn, UserModel? user) {
    print('User logged in: $userLoggedIn');
    print('Member data: $user');

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: AssetImage('assets/images/drawer_header_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: userLoggedIn && user != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.image?.isNotEmpty == true
                      ? NetworkImage(user.image!)
                      : NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(height: 10),
                Text(
                  user.userName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            )
          : Center(
              child: Text(
                'Welcome to GEMPEDIA',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, bool userLoggedIn) {
    return [
      if (userLoggedIn) ...[
        _buildListTile(
          icon: Icons.account_circle,
          title: 'Profile',
          onTap: () => _navigateTo(context, ProfileScreen()),
        ),
      ] else ...[
        _buildListTile(
          icon: Icons.login,
          title: 'Sign In / Sign Up',
          onTap: () => _navigateTo(context, LoginScreen()),
        ),
      ],
      _buildListTile(
        icon: Icons.settings,
        title: 'Settings',
        onTap: () => _navigateTo(context, SettingScreen()),
      ),
      Divider(),
      _buildListTile(
        icon: Icons.info,
        title: 'About Us',
        onTap: () => _navigateTo(context, AboutUsScreen()),
      ),
    ];
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
