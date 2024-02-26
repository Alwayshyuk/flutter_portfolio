import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/common/util/utils.dart';

class Post extends StatelessWidget {
  final String title;

  const Post({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final TextEditingController headController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();

    String head = '';
    String body = '';
    String? id;
    getId().then((value) => id = value);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title',
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: headController,
                decoration: InputDecoration(
                  hintText: '제목',
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (String value) {
                  head = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: bodyController,
                decoration: InputDecoration(
                  hintText: '내용',
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (String value) {
                  body = value;
                },
                maxLines: 18,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    var post = await FirebaseFirestore.instance
                        .collection('board')
                        .add({
                      'writer': id,
                      'head': head,
                      'body': body,
                      'time': Timestamp.now(),
                      'bid':'',
                      'comment':0
                    });
                    await FirebaseFirestore.instance
                        .collection('board')
                        .doc(post.id)
                        .update({'bid' : post.id.toString()});

                    Get.offAllNamed('/main');
                  } catch (e) {
                    e.printError;
                  }
                },
                child: Text('등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
