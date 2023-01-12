import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';

import '../util/dioUtil.dart';

//登录界面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _result = "";

  //登录成功后跳转到 AminPage
  toAdminPage(String name, String password) {
    Navigator.pushNamed(context, "/adminPage", arguments: {
      "name": name,
      "password": password,
    });
  }

  // 登录成功后跳转到 UserPage
  toUserPage(String name, String password) {
    Navigator.pushNamed(context, "/userPage", arguments: {
      "name": name,
      "password": password,
    });
  }

  //用户登录 HTTP
  login(String name, String password) async {
    dynamic data = {"name": name, "password": password};
    Response re = await DioUtils().post("/login", data: data);

    if (re.statusCode == HttpStatus.ok) {
      var jsonDate = jsonDecode(re.toString());
      //判断结果
      if (int.parse(jsonDate['code']) == 200) {
        //跳转
        // setState(() {
        //   _result = jsonDate['result'];
        // });

        // 根据登录名的长度不同跳转到不同的页面
        if (name.length < 10) {
          toAdminPage(name, password);
        }
        if (name.length == 18) {
          toUserPage(name, password);
        }
      } else {
        setState(() {
          _result = jsonDate['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //定义一个controller
    TextEditingController unameController = TextEditingController();
    TextEditingController upasswordController = TextEditingController();

    Widget editText() {
      return Container(
        color: Colors.white,
        width: double.infinity,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: unameController,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: "账号", prefixIcon: Icon(Icons.person)),
            ),
            TextField(
              controller: upasswordController,
              decoration: const InputDecoration(
                  labelText: "密码", prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            Text(
              _result,
            ),
          ],
        ),
      );
    }

    Widget loginButton() {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        height: 100,
        child: Container(
          color: Colors.blue,
          child: ElevatedButton(
            onPressed: () {
              var name = unameController.text;
              var password = upasswordController.text;
              if (name.isEmpty || password.isEmpty) {
                setState(() {
                  _result = "账号或密码为空";
                  print(_result);
                });
              } else {
                login(name, password);
              }
            },
            child: const Text("登录"),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            //设置登录背景图片
            image: AssetImage('images/login.png'),
            fit: BoxFit.cover, // 完全填充
          ),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      editText(),
                      loginButton(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
