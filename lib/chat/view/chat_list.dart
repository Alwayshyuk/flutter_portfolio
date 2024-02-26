import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/common/util/utils.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    getId().then((value) => id = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatroom')
              .where(Filter.or(
                Filter('target', isEqualTo: id),
                Filter('sender', isEqualTo: id),
              ))
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    '채팅',
                  ),
                ),
                body: Center(
                  child: Text('대화가 없습니다.'),
                ),
              );
            }
            final chat = snapshot.data!.docs;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '채팅',
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  reverse: false,
                  itemCount: chat.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // if (chat[index]['sender'] == id)
                            //   Text('${chat[index]['target']}'),
                            // if (chat[index]['sender'] != id)
                            //   Text('${chat[index]['sender']}'),
                            Text(chat[index]['sender'] == id
                                ? '${chat[index]['target']} 님과의 대화'
                                : '${chat[index]['sender']} 님과의 대화',style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey
                            ),)
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed('/chat/room/${chat[index]['cid']}');
                      },
                    );
                  },
                ),
              ),
            );
          });
    }
  }
}
