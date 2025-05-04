import 'package:fcp_srt2xml/page/homepage.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Srt to Fcpxml Convertor');
  setWindowMinSize(const Size(400, 300));
  setWindowMaxSize(const Size(400, 800));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srt to Fcpxml Convertor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF007AFF),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
