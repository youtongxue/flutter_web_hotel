import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/bean/normalresult.dart';

import '../../bean/history.dart';
import '../../util/dioUtil.dart';

class HistoryShowWidget extends StatefulWidget {
  const HistoryShowWidget({super.key});

  @override
  State<HistoryShowWidget> createState() => _HistoryShowState();
}

class _HistoryShowState extends State<HistoryShowWidget> {
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

  // 根据 personId 查询 HTTP
  findByPersonId(String personId) async {
    Map<String, dynamic> query = {"personId": personId};
    Response re = await DioUtils().get("/history/personid", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      if (jsonDate["code"].toString() == "200") {
        History history = History.fromJson(jsonDate);

        if (history.result.isEmpty) {
          setState(() {
            listHistory.clear();
          });
          _showDialog("不存在此用户订单!");
        } else {
          setState(() {
            listHistory = history.result;
          });
        }
      } else {
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        _showDialog(norMalResult.message);
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var personIdController = TextEditingController();

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
                    controller: personIdController,
                    decoration: const InputDecoration(
                        labelText: "用户身份证号", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(personIdController.text);
                      if (personIdController.text.isEmpty) {
                        _showDialog("身份证号不开为空!");
                        return;
                      }
                      findByPersonId(personIdController.text);
                    },
                    child: const Text("查询"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // historyInfo 信息
  Widget historyInfo() {
    return Row(
      children: const [
        Text("订单"),
        Padding(padding: EdgeInsets.only(left: 8)),
        Text("房间"),
        Padding(padding: EdgeInsets.only(left: 8)),
        Text("用户名"),
        Padding(padding: EdgeInsets.only(left: 18)),
        Text("性别"),
        Padding(padding: EdgeInsets.only(left: 20)),
        Text("身份证号"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("手机号"),
        Padding(padding: EdgeInsets.only(left: 20)),
        Text("Email"),
        Padding(padding: EdgeInsets.only(left: 40)),
        Text("密码"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("入住"),
        Padding(padding: EdgeInsets.only(left: 160)),
        Text("结束"),
        Padding(padding: EdgeInsets.only(left: 60)),
        Text("费用"),
        Padding(padding: EdgeInsets.only(left: 40)),
        Text("订单时间"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("评价"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("评价时间"),
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
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listHistory[index].orderId.toString()),
                  Text(listHistory[index].roomId.toString()),
                  Text(listHistory[index].personName.toString()),
                  Text(listHistory[index].personSex.toString()),
                  Text(listHistory[index].personId.toString()),
                  Text(listHistory[index].personPhone.toString()),
                  Text(listHistory[index].personEmail.toString()),
                  Text(listHistory[index].password.toString()),
                  Text(listHistory[index].startTime.toString()),
                  Text(listHistory[index].endTime.toString()),
                  Text(listHistory[index].orderPrice.toString()),
                  Text(listHistory[index].createDate.toString()),
                  Text(listHistory[index].appRaise.toString()),
                  Text(listHistory[index].appRaiseDate.toString()),
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
              child: historyInfo(),
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
