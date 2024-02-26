import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:portfolio/board/view/detail.dart';
import 'package:portfolio/board/view/post.dart';
import 'package:portfolio/chat/view/chat_screen.dart';
import 'package:portfolio/common/util/utils.dart';
import 'package:portfolio/common/view/root_tab.dart';
import 'package:portfolio/user/view/home.dart';
import 'package:portfolio/user/view/join.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'portfolio',
      getPages: [
        GetPage(
          name: '/',
          page: () {
            return Home();
          },
        ),
        GetPage(
          name: '/join',
          page: () => Join(),
        ),
        GetPage(
          name: '/main',
          page: () => RootTab(),
        ),
        GetPage(
          name: '/board/detail/:bid',
          page: () => BoardDetail(),
        ),
        GetPage(
          name: '/board/write',
          page: () => Post(title: '게시물 작성'),
        ),
        GetPage(
          name: '/chat/room/:rid',
          page: () => ChatScreen(),
        ),
      ],
    );
  }
}
