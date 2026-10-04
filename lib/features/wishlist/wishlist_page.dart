import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAF0),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 48,
                  color: Color(0xFFFF5C7A),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Your wishlist is empty',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Save products you love and find them here later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text(
                  'Explore Products',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}