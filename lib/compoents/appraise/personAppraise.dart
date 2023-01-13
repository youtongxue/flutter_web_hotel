import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../bean/history.dart';
import '../../bean/normalresult.dart';
import '../../bean/notice.dart';
import '../../pages/user.dart';
import '../../util/dioUtil.dart';

class PersonAppraise extends StatefulWidget {
  const PersonAppraise({super.key});

  @override
  State<PersonAppraise> createState() => _PersonAppraiseState();
}

class _PersonAppraiseState extends State<PersonAppraise> {
  @override
  void initState() {
    super.initState();
    findAllHistory();
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

  List<Result> listHistory = [];
  //查询所有公告信息 HTTP
  findAllHistory() async {
    Response re = await DioUtils().get("/history/all");

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      History history = History.fromJson(jsonDate);
      //判断结果
      if (history.code.toString() == "200") {
        setState(() {
          listHistory = history.result;
        });
      }
    }
  }

  //根据 orderId 查询所有工单信息 HTTP
  addWorkOrder(String content) async {
    Map<String, dynamic> data = {
      "appRaise": content,
      "orderId": globPersonOrderId,
    };
    Response re = await DioUtils().get("/history/appraise", data: data);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
      //判断结果
      if (jsonDate["code"].toString() == "200") {
        findAllHistory();
        _showDialog(norMalResult.result);
      } else {
        _showDialog(norMalResult.message);
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var appraiseController = TextEditingController();

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
            flex: 1,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: appraiseController,
                    decoration: const InputDecoration(
                        labelText: "新增评价", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(appraiseController.text);
                      if (appraiseController.text.isEmpty) {
                        _showDialog("内容不可为空!");
                        return;
                      }
                      if (globPersonOrderId == null) {
                        _showDialog("本地信息错误");
                        return;
                      }
                      addWorkOrder(appraiseController.text);
                    },
                    child: const Text("提交评价"),
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
        Padding(padding: EdgeInsets.only(left: 160)),
        Text("用户名"),
        Padding(padding: EdgeInsets.only(left: 360)),
        Text("内容"),
        Padding(padding: EdgeInsets.only(left: 380)),
        Text("发布时间"),
        Padding(padding: EdgeInsets.only(left: 18)),
      ],
    );
  }

// 底部数据展示
  Widget dataShow() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: listHistory.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            height: listHistory[index].appRaise.toString().isNotEmpty ? 50 : 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(listHistory[index].personName.toString()),
                Text(listHistory[index].appRaise.toString()),
                Text(listHistory[index].appRaiseDate.toString()),
              ],
            ),
          );
        },
      ),
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
