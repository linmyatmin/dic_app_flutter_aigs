import 'package:dic_app_flutter/screens/register_screen.dart';
import 'package:dic_app_flutter/screens/contactus_screen.dart';
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/screens/setting_screen.dart';
import 'package:dic_app_flutter/screens/words_screen.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEbU7_44vb0L45FVVdJ69vbG7eUatiAAbEpacifjBnHcoPaFjvhMA_H-WpVO_yMXMIBc0&usqp=CAU'),
              ),
              accountName: Text('DevTest'),
              accountEmail: Text('dev@test.com'),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Words'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => WordsScreen()),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Sign Up'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
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
            )
          ],
        ),
      ),
    );
  }
}
