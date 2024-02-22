import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  List<Product> list;

  ProductList({Key? key, required this.list}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEbU7_44vb0L45FVVdJ69vbG7eUatiAAbEpacifjBnHcoPaFjvhMA_H-WpVO_yMXMIBc0&usqp=CAU'),
              // NetworkImage(widget.list[i].images[0]),
              // widget.list[i].thumbnail),
            ),
            // leading: CircleAvatar(
            //   child: FadeInImage.assetNetwork(
            //     placeholder:
            //         'assets/placeholder_image.png', // Placeholder image asset path
            //     image: products![i].images[0],
            //     fit: BoxFit.cover,
            //   ),
            // ),
            title: Text(
              widget.list[i].title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              // "${users![idx].users[0].address}, ${users![idx].company.catchPhrase}, ${users![idx].company.bs}",
              widget.list[i].description,
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // Add logic to handle adding product to favorites
                print('added fav');
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
