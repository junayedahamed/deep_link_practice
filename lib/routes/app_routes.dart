import 'package:deeplink/home/my_home_page.dart';
import 'package:deeplink/product/product_details.dart';
import 'package:deeplink/product/product_page.dart';
import 'package:go_router/go_router.dart';

GoRouter routes = GoRouter(
  redirect: (context, state) {
    // You can add logic here to redirect based on authentication or other conditions
    return null; // No redirection
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => MyHomePage()),
    GoRoute(path: '/product', builder: (context, state) => ProductPage()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetails(productId: productId);
      },
    ),
  ],
);
