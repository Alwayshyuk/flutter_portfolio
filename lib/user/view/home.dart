import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/common/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    String id = '';
    String pw = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
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
                decoration: InputDecoration(
                  hintText: '아이디',
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (String value) {
                  id = value;
                },
                onSaved:(value){
                  id = value!;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  contentPadding: EdgeInsets.all(10),
                ),
                obscureText: true,
                onChanged: (String value) {
                  pw = value;
                },
                onSaved:(value){
                  pw = value!;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  print('id:$id, pw:$pw');
                  var user = await FirebaseFirestore.instance
                      .collection('user')
                      .where('id', isEqualTo: id)
                      .where('pw', isEqualTo: pw)
                      .get();

                  if (user.docs.isEmpty || id == '' || pw == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('가입 정보를 확인해주세요.'),
                      ),
                    );
                  } else {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('id', id);
                    Get.offNamed('/main');
                  }
                },
                child: Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/join');
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(color: Colors.white),
                ),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
