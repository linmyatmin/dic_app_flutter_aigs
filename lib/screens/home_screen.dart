import 'dart:async';

import 'package:dic_app_flutter/components/word_list.dart';
import 'package:dic_app_flutter/helpers/drawer_navigation.dart';
import 'package:dic_app_flutter/helpers/bottom_navigation.dart';
import 'package:dic_app_flutter/main.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/screens/aboutus_screen.dart';
import 'package:dic_app_flutter/screens/favorites_screen.dart';
import 'package:dic_app_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dic_app_flutter/providers/recent_searches_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dic_app_flutter/services/word_cache_service.dart';

enum SearchMode { contains, startsWith, exactMatch }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth status when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        ref.read(authProvider.notifier).checkStoredUser();
      }
    });
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FavoriteScreen(),
    AboutUsScreen(showAppBar: false),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    print('HomeScreen - Auth State:');
    print('isAuthenticated: ${authState.isAuthenticated}');
    print('user: ${authState.user?.email}');

    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).primaryColorLight : Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          _selectedIndex == 2 ? "About Us" : "GEMPEDIA",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (authState.isAuthenticated &&
              authState.user != null &&
              _selectedIndex != 2)
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
  SearchMode _currentSearchMode = SearchMode.contains;

  void _changeSearchMode(SearchMode mode) {
    setState(() {
      _currentSearchMode = mode;
      _filterWords(); // Re-filter with new mode
    });
  }

  List<Word> words = [];
  List<Word> filteredWords = [];
  TextEditingController searchController = TextEditingController();
  String selectedLetter = '';
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = false;
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final WordCacheService _cacheService = WordCacheService();

  bool _isInitialLoad = true;

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result.first);
    } catch (e) {
      print('Connectivity check failed: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
      if (_isConnected && words.isEmpty) {
        loadWords();
      }
    });
  }

  Future<void> loadWords() async {
    final cachedWords = await _cacheService.getCachedWords();

    if (cachedWords != null && cachedWords.isNotEmpty) {
      setState(() {
        words = cachedWords;
        filteredWords = cachedWords;
      });
    }

    if (_isConnected &&
        (_isInitialLoad || cachedWords == null || cachedWords.isEmpty)) {
      try {
        final value = await API().getWords();
        if (mounted) {
          setState(() {
            words = value;
            filteredWords = value;
            _isInitialLoad = false;
          });
          await _cacheService.cacheWords(value);
        }
      } catch (e) {
        print('API error: $e');
        if (mounted && cachedWords == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to load words. Please check your connection.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  Future<void> refreshWords() async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Using cached data.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final value = await API().getWords();
      if (mounted) {
        setState(() {
          words = value;
          filteredWords = value;
        });
        await _cacheService.cacheWords(value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            // content: Text('Words updated successfully!'),
            content: Text('Dictionary refreshed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update words. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterWords() {
    final query = searchController.text.toLowerCase();
    setState(() {
      // Start with all words
      filteredWords = words;

      // Apply search filter if there's a query
      if (query.isNotEmpty) {
        filteredWords = filteredWords.where((word) {
          // Add null check for pureNameEn
          if (word.pureNameEn == null) {
            // print('Warning: word has null pureNameEn: $word');
            return false;
          }

          final wordText = word.pureNameEn!.toLowerCase();
          // print('Filtering word: $wordText'); // Debug print

          switch (_currentSearchMode) {
            case SearchMode.contains:
              return wordText.contains(query);
            case SearchMode.startsWith:
              return wordText.startsWith(query);
            case SearchMode.exactMatch:
              return wordText == query;
            default:
              return wordText.contains(query);
          }
        }).toList();
      }

      // Apply letter filter if any
      if (selectedLetter.isNotEmpty && selectedLetter != 'all') {
        filteredWords = filteredWords
            .where((word) =>
                word.section != null &&
                word.section!.toLowerCase() == selectedLetter.toLowerCase())
            .toList();
      }
    });
  }

  void _filterByLetter(String letter) {
    setState(() {
      selectedLetter = letter;
      if (letter == 'all') {
        filteredWords = words; // Show all words
      } else {
        filteredWords = words
            .where(
                (word) => word.section?.toLowerCase() == letter.toLowerCase())
            .toList(); // Show words in the selected section
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });

    loadWords();

    // Make sure the listener is properly set up
    searchController.addListener(() {
      _filterWords();
    });

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
    _connectivitySubscription.cancel();
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

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).addSearch(value.toLowerCase());
      _filterWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected && words.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.signal_wifi_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your connection and try again',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadWords,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: refreshWords,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search gem dictionary...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _filterWords();
                            },
                          ),
                        PopupMenuButton<SearchMode>(
                          icon: const Icon(Icons.tune),
                          onSelected: _changeSearchMode,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: SearchMode.contains,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: _currentSearchMode ==
                                            SearchMode.contains
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Contains'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: SearchMode.startsWith,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: _currentSearchMode ==
                                            SearchMode.startsWith
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Starts with'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: SearchMode.exactMatch,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: _currentSearchMode ==
                                            SearchMode.exactMatch
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Exact match'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    print('onChanged: $value');
                    _filterWords(); // Add this to ensure immediate filtering
                  },
                ),
              ),
              // Display the filtered selection and total word count with background color
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  color:
                      Theme.of(context).primaryColor, // Apply background color
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
                child: words.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : WordList(
                        list: filteredWords,
                        scrollController: _scrollController,
                      ),
              ),
            ],
          ),
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
