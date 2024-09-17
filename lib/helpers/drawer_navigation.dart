import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/screens/aboutus_screen.dart';
import 'package:dic_app_flutter/screens/profile_screen.dart';
import 'package:dic_app_flutter/screens/register_screen.dart';
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerNavigation extends ConsumerStatefulWidget {
  const DrawerNavigation({super.key});

  @override
  ConsumerState<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends ConsumerState<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final member = authState.member;
    final bool userLoggedIn = member != null ? true : false;

    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            if (userLoggedIn)
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEbU7_44vb0L45FVVdJ69vbG7eUatiAAbEpacifjBnHcoPaFjvhMA_H-WpVO_yMXMIBc0&usqp=CAU'),
                ),
                accountName: Text(member.username),
                accountEmail: Text(member.email),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              )
            else
              Container(
                padding: EdgeInsets.all(16.0),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Text(
                  'Welcome to GEMPEDIA',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Home'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const HomeScreen()),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Sign Up / Sign In'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
