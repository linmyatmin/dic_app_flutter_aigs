import 'package:dic_app_flutter/models/product_model.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  Product? product;

  DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 148, 34),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.product!.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: widget.product == null
          ? const Text('Please search first...',
              style: TextStyle(color: Colors.white))
          : Text(
              widget.product!.description,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}
