import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Gem Dictionary | 汉英宝石字典',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(
              'The English Chinese Gem Dictionary is the most complete resource of its kind, allowing industry professionals, students, and consumers alike to learn more about gemstones, no matter where they are!\n汉英宝石字典 是同类产品中最为完善的，使得行业内专业人士，学生，以及消费者能够学到更多的宝石学知识，无论何时何地！',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'The e-dictionary is based on Akira Chikayama’s seminal work, the Dictionary of Gemstones & Jewelry - which covers all facets of the subject; including scientific, technical and commercial terms, as well as those concerning the myths, superstition and lore traditionally associated with gemstones - and has been adapted by the Asian Institute of Gemological Sciences (AIGS) for use with electronic formats.\n此电子字典是基于日本宝石学家近山晶（Akira Chikayama）的开创性著作，《宝石宝饰大字典》。这本著作涵盖了宝石学的所有方面，包括科研、技术和商业，以及传说、迷信和与宝石有关的传统等等。AIGS则在此基础上将其改编成了便于使用的电子版本。',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'This application also allows for both English and Chinese language search inputs, as well as two-way translation between the two languages.\n此应用软件允许英语和中文两种语言的输入，并能够实现两种语言的双向翻译。',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        )),
      ),
    );
  }
}
