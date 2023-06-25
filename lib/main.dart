import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:trelloboard/Support/string.dart';
import 'package:trelloboard/view/home_screen_ui.dart';

void main() {
  runApp(const TrelloBoardApp());
}

class TrelloBoardApp extends StatelessWidget {
  const TrelloBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyString.trelloBoard,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
