import 'package:dic_app_flutter/models/post.dart';
import 'package:dic_app_flutter/services/post_api.dart';
import 'package:flutter/material.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  List<Post> postDataList = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Words Screen');
  }

  Future<void> fetchPosts() async {
    final response = await PostApi.fetchPosts();
    // print(response);
    setState(() {
      postDataList = response;
    });
  }
}
