import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/bean/addAdmin.dart';

import '../../bean/admin.dart';
import '../../bean/normalresult.dart';
import '../../util/dioUtil.dart';

class AdminShowWidget extends StatefulWidget {
  const AdminShowWidget({super.key});

  @override
  State<AdminShowWidget> createState() => _AdminShowWidgetState();
}

class _AdminShowWidgetState extends State<AdminShowWidget> {
  @override
  void initState() {
    super.initState();
    findAllAdmin();
  }

  List<Result> listAdmin = [];
  //查询所有管理员信息 HTTP
  findAllAdmin() async {
    Response re = await DioUtils().get("/admin/all");

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      Admin admin = Admin.fromJson(jsonDate);
      //判断结果
      if (admin.code.toString() == "200") {
        setState(() {
          listAdmin = admin.result;
        });
      }
    }
  }

  //根据 adminId 删除 HTTP
  delByNoticeId(int hotelAdminId) async {
    Map<String, dynamic> query = {"hotelAdminId": hotelAdminId};
    Response re = await DioUtils().get("/admin/del", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      NorMalResult notice = NorMalResult.fromJson(jsonDate);
      //判断结果
      if (notice.code.toString() == "200") {
        print("删除管理员成功");
        setState(() {
          findAllAdmin();
        });
      }
    }
  }

  _showDialog(String content) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("提示"),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("确定"))
            ],
          );
        }));
  }

  // 新增管理员
  addAdmin(String name, String password, String superName,
      String superPassWord) async {
    Map<String, dynamic> data = {
      "adminId": null,
      "adminName": name,
      "password": password,
      "superName": superName,
      "superPassword": superPassWord,
      "createDate": null,
    };
    Response re = await DioUtils().post("/admin/add", data: data);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      //判断结果
      if (jsonDate["code"].toString() == "200") {
        AddAdmin admin = AddAdmin.fromJson(jsonDate);
        print("添加管理员成功");
        setState(() {
          findAllAdmin();
        });
        _showDialog("创建成功!");
      } else {
        NorMalResult normal = NorMalResult.fromJson(jsonDate);
        _showDialog(normal.message.toString());
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var nameController = TextEditingController();
    var passwordController = TextEditingController();

    return Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
            ),
          ),

          // roomId 搜索
          Expanded(
            flex: 4,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: "管理员名称", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: "密码", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);

                      if (nameController.text.isEmpty) {
                        _showDialog("账户名不可为空!");
                        return;
                      }

                      if (passwordController.text.isEmpty) {
                        _showDialog("密码不可为空!");
                        return;
                      }

                      addAdmin(nameController.text, passwordController.text,
                          "super", "123456");
                    },
                    child: const Text("新增管理员"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // noticInfo 信息
  Widget noticeInfo() {
    return Row(
      children: const [
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("管理ID"),
        Padding(padding: EdgeInsets.only(left: 160)),
        Text("登录名"),
        Padding(padding: EdgeInsets.only(left: 200)),
        Text("密码"),
        Padding(padding: EdgeInsets.only(left: 240)),
        Text("创建时间"),
      ],
    );
  }

// 底部数据展示
  Widget dataShow() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: listAdmin.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listAdmin[index].adminId.toString()),
                  Text(listAdmin[index].adminName.toString()),
                  Text(listAdmin[index].password.toString()),
                  Text(listAdmin[index].createDate.toString()),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      print("删除管理员");
                      delByNoticeId(listAdmin[index].adminId);
                    },
                    child: const Text("删除"),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: topNav(),
            ),
            const Divider(
              color: Colors.black54,
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: noticeInfo(),
            ),
            const Divider(
              color: Colors.black54,
              height: 10,
            ),
            // 底部数据展示
            Expanded(
              flex: 13,
              child: dataShow(),
            ),
          ],
        ),
      ),
    );
  }
}
