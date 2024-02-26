import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BoardList extends StatefulWidget {
  const BoardList({super.key});

  @override
  State<BoardList> createState() => _ListState();
}

class _ListState extends State<BoardList> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('board')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final post = snapshot.data!.docs;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                '게시판',
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed('/board/write');
                  },
                  icon: Icon(Icons.edit_outlined),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                reverse: false,
                itemCount: post.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('제목: ${post[index]['head']} [${post[index]['comment']}]',style: TextStyle(
                          fontSize: 20,fontWeight: FontWeight.bold,
                        ),),
                        Text(
                          '${post[index]['body']}',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Get.toNamed('/board/detail/${post[index]['bid']}');
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}
