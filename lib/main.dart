import 'package:flutter/material.dart';
import 'page.dart'; // Corrected import assuming 'page.dart' is in the same folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MapPage(), // Added `const` for consistency
    );

  }
}
