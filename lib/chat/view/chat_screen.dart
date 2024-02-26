import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:portfolio/common/util/utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    String rid = Get.parameters['rid'].toString();
    print(rid);
    String tid = Get.parameters['target'].toString();
    String text = '';

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('rid', isEqualTo: rid)
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final message = snapshot.data!.docs;
          return Scaffold(
            appBar: AppBar(
              title: Text('채팅방'),
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('chatroom').doc(rid).delete();
                    Get.back();
                  },
                  icon: Icon(Icons.output),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: false,
                      itemCount: message.length,
                      itemBuilder: (context, index) {
                        bool myMessage = message[index]['sender'] == id;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: myMessage
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: myMessage
                                      ? const EdgeInsets.fromLTRB(45, 10, 0, 0)
                                      : const EdgeInsets.fromLTRB(0, 10, 45, 0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper8(
                                        type: myMessage
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble),
                                    backGroundColor: Color(0xffE7E7ED),
                                    margin: EdgeInsets.only(top: 20),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: myMessage
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            message[index]['message'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },

                        child: TextFormField(

                        controller: controller,
                        decoration: InputDecoration(
                          hintText: '채팅을 입력해주세요.',
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (String value) {
                          text = value;
                        },
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) {
                           FirebaseFirestore.instance
                              .collection('chat')
                              .add({
                            'sender': id,
                            'time': DateTime.now(),
                            'message': value,
                            'rid': rid
                          });
                        },

                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
