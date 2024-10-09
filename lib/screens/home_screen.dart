import 'package:dic_app_flutter/components/word_list.dart';
import 'package:dic_app_flutter/helpers/drawer_navigation.dart';
import 'package:dic_app_flutter/helpers/bottom_navigation.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/screens/aboutus_screen.dart';
import 'package:dic_app_flutter/screens/favorites_screen.dart';
import 'package:dic_app_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FavoriteScreen(),
    AboutUsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final member = authState.member;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "GEMPEDIA",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (member != null)
            IconButton(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout))
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: const DrawerNavigation(),
      bottomNavigationBar: BottomNavigation(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Word> words = [];
  List<Word> filteredWords = [];
  TextEditingController searchController = TextEditingController();

  loadWords() {
    API().getWords().then((value) => {
          setState(() {
            words = value;
            filteredWords = value; // Initialize filteredWords with all words
          })
        });
  }

  void _filterWords() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredWords = words
          .where((word) => word.nameEn.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadWords();
    searchController.addListener(_filterWords);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return words.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        labelText: 'Search gem dictionary...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search)),
                  )),
              Expanded(
                  child: WordList(
                list: filteredWords,
              ))
            ],
          );
  }
}
