import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  String id = '';
  String pw = '';
  bool pass = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    hintText: '아이디',
                    contentPadding: EdgeInsets.all(10),
                    errorText: checkText(4,idController),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                  ),
                  onChanged: (String value) {
                    setState(() {});
                    id = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pwController,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    contentPadding: EdgeInsets.all(10),
                    errorText: checkText(6,pwController),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {});
                    pw = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if(!pass){
                      return;
                    }
                    try {
                      await FirebaseFirestore.instance.collection('user').add({
                        'id': id,
                        'pw': pw,
                        'time': Timestamp.now(),
                      });
                    } catch (e) {
                      e.printError();
                    }
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('가입되었습니다.'),
                      ),
                    );
                  },
                  child: Text(
                    '가입하기',
                    style: TextStyle(color: Colors.white),
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String? checkText(int count,TextEditingController controller) {
    pass = false;
    if (controller.text.length < count) {
      return '$count자 이상 입력해주세요.';
    } else {
      pass = true;
      return null;
    }
  }
}
