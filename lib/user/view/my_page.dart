import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('id');
        Get.offAllNamed('/');
      }, child: Text('로그아웃'))
    );
  }
}
