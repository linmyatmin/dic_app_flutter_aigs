import 'package:dic_app_flutter/components/word_list.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _api = API();
  List<Word>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            title: TextField(
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    print(value);
                    _api.searchWords(value).then((value) {
                      setState(() {
                        result = value;
                      });
                    });
                    print(result!.length);
                    print(result!);
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                    // icon: Icon(
                    //   Icons.search,
                    //   color: Colors.green,
                    // ),
                    hintText: 'Search your words...',
                    hintStyle: TextStyle(color: Colors.white)))),
        body: result == null
            ? const Text('Please search first...',
                style: TextStyle(color: Colors.black))
            : WordList(list: result!)
        // SearchList(list: result!),
        );
  }
}
