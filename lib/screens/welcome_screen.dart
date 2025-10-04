import 'package:flutter/material.dart';
import '../main.dart'; // استدعاء LayoutScreen من main.dart

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "أهلاً بك 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LayoutScreen(), // ✅ صح هنا
                  ),
                );
              },
              child: const Text("ادخل للتطبيق"),
            ),
          ],
        ),
      ),
    );
  }
}
