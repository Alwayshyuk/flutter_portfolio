import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/board/model/lecture.dart';
import 'package:portfolio/common/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardDetail extends StatefulWidget {
  const BoardDetail({super.key});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId().then((value) => id = value);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String bid = Get.parameters['bid'].toString();
    String? comment;
    bool commentCount = false;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('board').doc(bid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final lecture = snapshot.data!;
          bool commentCount = lecture['comment'] > 0;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('게시글 디테일'),
                actions: [
                  if (id == lecture['writer'])
                    IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('board')
                            .doc(bid)
                            .delete();
                        Get.offAllNamed('/main');
                      },
                      icon: Icon(Icons.delete),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '제목',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  '${lecture['head']}',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 200),
                            child: Text(
                              '${lecture['body']}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        '${lecture['writer']}',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      onTap: () {
                        String target = lecture['writer'];
                        chat(id.toString(), target);
                        },
                    ),
                    Text(
                      '댓글',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: '댓글',
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (String value) {
                          comment = value;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var reply = await FirebaseFirestore.instance
                            .collection('comment')
                            .add({
                          'writer': id,
                          'content': comment,
                          'bid': bid,
                          'time': Timestamp.now(),
                          'cid': ''
                        });
                        await FirebaseFirestore.instance
                            .collection('comment')
                            .doc(reply.id)
                            .update({'cid': reply.id.toString()});

                        await FirebaseFirestore.instance
                            .collection('board')
                            .doc(bid)
                            .update({'comment': lecture['comment'] + 1});

                        setState(() {});
                      },
                      child: Text('등록하기'),
                    ),
                    if(commentCount)
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('comment')
                          .where('bid', isEqualTo: bid)
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final comment = snapshot.data!.docs;
                        String cid = '';
                        return ListView.builder(
                          shrinkWrap: true,
                          reverse: false,
                          itemCount: comment.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      '${comment[index]['writer']}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.green),
                                    ),
                                    onTap: () async {
                                      String target = comment[index]['writer'];
                                      chat(id.toString(), target);
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${comment[index]['content']}',
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void chat(String id, String target) async {

    if (id == target) {
      return;
    }
    String cid = '';
    await FirebaseFirestore
        .instance
        .collection('chatroom')
        .where(Filter.or(
      Filter.and(
        Filter('target',
            isEqualTo: id),
        Filter('sender', isEqualTo: target),
      ),
      Filter.and(
        Filter('target', isEqualTo: target),
        Filter('sender',
            isEqualTo: id),
      ),
    ))
        .limit(1)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        cid = docSnapshot.id;
      }
    });
    if (cid == '') {
      try {
        var newRoom = await FirebaseFirestore
            .instance
            .collection('chatroom')
            .add({
          'target': target,
          'sender': id,
          'time': Timestamp.now()
        });

        await FirebaseFirestore.instance
            .collection('chatroom')
            .doc(newRoom.id)
            .update({
          'cid': newRoom.id.toString()
        });
        Get.toNamed('/chat/room/${newRoom.id.toString()}');
      } catch (e) {
        print(e);
      }
    }else{
      Get.toNamed('/chat/room/${cid.toString()}');
    }

  }
}
