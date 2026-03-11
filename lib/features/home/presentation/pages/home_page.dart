import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routing/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.register),
              child: const Text('Go to Register Introduction'),
            ),
          ],
        ),
      ),
    );
  }
}
