import 'package:dic_app_flutter/components/product_list.dart';
import 'package:dic_app_flutter/components/search_list.dart';
import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _api = API();
  List<Product>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: TextField(
                style: const TextStyle(color: Colors.black),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    print(value);
                    _api.searchProducts(value).then((value) {
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
                    hintText: 'Search your words...'))),
        body: result == null
            ? const Text('Please search first...',
                style: TextStyle(color: Colors.white))
            : ProductList(list: result!)
        // SearchList(list: result!),
        );
  }
}
