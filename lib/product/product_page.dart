import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Page')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              context.push('/product/${index.toString()}');
            },
            title: Text('Product $index'),
            subtitle: Text('Description for product $index'),
          );
        },
      ),
    );
  }
}
