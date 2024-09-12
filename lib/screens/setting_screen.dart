import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dark_mode),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Dark Mode'),
                      ],
                    ),
                    Switch(
                        value: dark,
                        onChanged: (bool value) {
                          setState(() {
                            dark = value;
                          });
                        })
                  ],
                )
              ],
            ),
          ),
        )
        // Column(children: [
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         const Icon(Icons.dark_mode),
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         Expanded(
        //             child: Text(
        //           'Dark Mode',
        //           textAlign: TextAlign.left,
        //           maxLines: 1,
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        //         )),
        //         Expanded(
        //             child: Switch(
        //                 value: dark,
        //                 onChanged: (bool value) {
        //                   setState(() {
        //                     dark = value;
        //                   });
        //                 })),
        //       ],
        //     ),
        //   ),
        // ]

        );
  }
}
