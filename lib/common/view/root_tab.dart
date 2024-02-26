import 'package:flutter/material.dart';
import 'package:portfolio/board/view/board_list.dart';
import 'package:portfolio/chat/view/chat_list.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/user/view/my_page.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    // TODO: implement dispose
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          // RestraurantScreen()
          BoardList(),
          ChatList(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: '게시판'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: '채팅'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '개인 정보'
          ),
        ],
      ),
    );
  }
}
