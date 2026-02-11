import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.productId});
  final String productId;
  //dkjds
  @override
  Widget build(BuildContext context) {
    // log('Product ID: $productId');
    final String deepLink =
        'https://fl-deep-link-host.vercel.app/product/$productId';

    // Check if user came from deep link (no navigation history)
    final bool cameFromDeepLink = !context.canPop();

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          leading: cameFromDeepLink
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                  tooltip: 'Go to Home',
                )
              : null, // Use default back button
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                // Copy full deep link to clipboard
                Clipboard.setData(ClipboardData(text: deepLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deep link copied to clipboard'),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Share the product deep link
                SharePlus.instance.share(ShareParams(text: deepLink));
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Detailed information about the product $productId goes here.',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SelectableText(
                'Link: $deepLink',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
