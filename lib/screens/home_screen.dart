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
import 'package:flutter/rendering.dart';
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
  String selectedLetter = ''; // Track selected letter
  ScrollController _scrollController = ScrollController();
  bool _isFabVisible = false; // Track FAB visibility

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
      // Start by showing all words or filtering by the selected letter
      if (selectedLetter.isEmpty || selectedLetter == 'all') {
        filteredWords = words;
      } else if (selectedLetter == 'numbers') {
        // Filter words that start with a number
        filteredWords = words
            .where((word) => RegExp(r'^[0-9]').hasMatch(word.nameEn))
            .toList();
      } else if (selectedLetter == 'symbols') {
        // Filter words that start with a symbol
        filteredWords = words
            .where((word) => RegExp(r'^[^a-zA-Z0-9]').hasMatch(word.nameEn))
            .toList();
      } else {
        // Filter words by the selected alphabet letter
        filteredWords = words
            .where(
                (word) => word.nameEn.toLowerCase().startsWith(selectedLetter))
            .toList();
      }

      // Now apply the search query on top of the filtered result
      if (query.isNotEmpty) {
        filteredWords = filteredWords
            .where((word) => word.nameEn.toLowerCase().startsWith(query))
            .toList();
      }
    });
  }

  void _filterByLetter(String letter) {
    setState(() {
      selectedLetter = letter;
      if (letter == 'all') {
        filteredWords = words; // Show all words
      } else if (letter == 'numbers') {
        filteredWords = words
            .where((word) => RegExp(r'^[0-9]').hasMatch(word.nameEn))
            .toList(); // Show words starting with numbers
      } else if (letter == 'symbols') {
        filteredWords = words
            .where((word) => RegExp(r'^[^a-zA-Z0-9]').hasMatch(word.nameEn))
            .toList(); // Show words starting with symbols
      } else {
        filteredWords = words
            .where((word) => word.nameEn.startsWith(letter))
            .toList(); // Show words starting with selected letter
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadWords();
    searchController.addListener(_filterWords);

    // Listen to scroll changes and show/hide the floating button
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isFabVisible = true;
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isFabVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showAlphabetFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Alphabet'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Adjust the height to ensure all items fit
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // 4 buttons per row to accommodate more filters
                childAspectRatio: 2.0, // Make the buttons wider
                crossAxisSpacing: 4.0, // Add some space between buttons
                mainAxisSpacing: 4.0, // Add some space between rows
              ),
              itemCount: 29, // 26 letters + All, Number, Symbol
              itemBuilder: (context, index) {
                String label;
                String letter;
                if (index == 0) {
                  label = "All";
                  letter = 'all';
                } else if (index == 1) {
                  label = "Number";
                  letter = 'numbers';
                } else if (index == 2) {
                  label = "Symbol";
                  letter = 'symbols';
                } else {
                  label = String.fromCharCode(65 + index - 3); // A-Z
                  letter = label.toLowerCase();
                }
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _filterByLetter(letter);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text(label),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return words.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              Column(
                children: [
                  // Alphabet filter buttons
                  // SizedBox(
                  //   height: 50,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: 26,
                  //     itemBuilder: (context, index) {
                  //       final letter = String.fromCharCode(65 + index); // A-Z
                  //       return Padding(
                  //         padding: const EdgeInsets.all(4.0),
                  //         child: ElevatedButton(
                  //           onPressed: () {
                  //             _filterByLetter(letter.toLowerCase());
                  //           },
                  //           child: Text(letter),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                            labelText: 'Search gem dictionary...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search)),
                      )),
                  // Display the filtered selection and total word count with background color
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      color: const Color.fromARGB(
                          255, 45, 66, 87), // Apply background color
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0), // Add padding inside the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filtered: ${selectedLetter.isEmpty ? 'All' : (selectedLetter == 'numbers' ? 'Number' : (selectedLetter == 'symbols' ? 'Symbol' : selectedLetter.toUpperCase()))}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Text color to contrast the background
                            ),
                          ),
                          Text(
                            'Total: ${filteredWords.length}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Text color to contrast the background
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                      child: WordList(
                    list: filteredWords,
                    scrollController: _scrollController,
                  ))
                ],
              ),
              if (_isFabVisible)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _showAlphabetFilterDialog,
                    child: const Icon(Icons.filter_list),
                  ),
                ),
            ],
          );
  }
}
