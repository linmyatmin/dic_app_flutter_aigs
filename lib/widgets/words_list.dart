import 'package:dic_app_flutter/models/post.dart';
import 'package:dic_app_flutter/services/post_api.dart';
import 'package:flutter/material.dart';

class WordsList extends StatefulWidget {
  const WordsList({super.key});

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  // late WordModel word;
  List<Post> postDataList = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    print('post data list: ${postDataList.length}');
    return postDataList.length == 0
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: postDataList.length,
            itemBuilder: (context, index) {
              final post = postDataList[index];

              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            });
  }

  Future<void> fetchPosts() async {
    final response = await PostApi.fetchPosts();
    setState(() {
      postDataList = response;
    });
  }
}
