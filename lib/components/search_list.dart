import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/screens/detail_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchList extends StatefulWidget {
  List<Product> list;

  SearchList({Key? key, required this.list}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    print("searchList page: ${widget.list.length}");

    return ListView.separated(
        // scrollDirection: Axis.vertical,
        itemCount: widget.list.length,
        itemBuilder: (ctx, i) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            product: widget.list[i],
                          )));
            },
            child: ListTile(
              title: Text(
                widget.list[i].title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                // "${users![idx].users[0].address}, ${users![idx].company.catchPhrase}, ${users![idx].company.bs}",
                widget.list[i].description,
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }
}
