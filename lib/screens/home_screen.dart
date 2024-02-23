import 'package:dic_app_flutter/components/product_list.dart';
import 'package:dic_app_flutter/helpers/drawer_navigation.dart';
import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:dic_app_flutter/screens/detail_screen.dart';
import 'package:dic_app_flutter/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<User>? users;
  List<Product>? products;

  loadProducts() {
    API().getProducts().then((value) => {
          setState(() {
            products = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "GEMPEDIA",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
      ),
      body: products == null
          ? const Center(child: CircularProgressIndicator())
          : ProductList(
              list: products!,
            ),

      // ListView.separated(
      //     itemCount: products?.length as int,
      //     itemBuilder: (ctx, i) {
      //       return InkWell(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => DetailScreen(
      //                         product: products![i],
      //                       )));
      //         },
      //         child: ListTile(
      //           leading: CircleAvatar(
      //             backgroundImage: NetworkImage(products![i].images[0]),
      //           ),
      //           // leading: CircleAvatar(
      //           //   child: FadeInImage.assetNetwork(
      //           //     placeholder:
      //           //         'assets/placeholder_image.png', // Placeholder image asset path
      //           //     image: products![i].images[0],
      //           //     fit: BoxFit.cover,
      //           //   ),
      //           // ),
      //           title: Text(
      //             products![i].title,
      //             style: const TextStyle(color: Colors.white),
      //           ),
      //           subtitle: Text(
      //             // "${users![idx].users[0].address}, ${users![idx].company.catchPhrase}, ${users![idx].company.bs}",
      //             products![i].description,
      //             style: const TextStyle(color: Colors.white54),
      //           ),
      //           trailing: IconButton(
      //             icon: const Icon(Icons.favorite_border),
      //             onPressed: () {
      //               // Add logic to handle adding product to favorites
      //               print('added fav');
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //     separatorBuilder: (BuildContext context, int index) =>
      //         const Divider(),
      //   ),
      drawer: const DrawerNavigation(),
    );
  }
}
