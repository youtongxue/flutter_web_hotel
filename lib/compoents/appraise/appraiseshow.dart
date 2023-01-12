import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../bean/history.dart';
import '../../util/dioUtil.dart';

class AppRaiseShowWidget extends StatefulWidget {
  const AppRaiseShowWidget({super.key});

  @override
  State<AppRaiseShowWidget> createState() => _AppRaiseShowWidgetState();
}

class _AppRaiseShowWidgetState extends State<AppRaiseShowWidget> {
  @override
  void initState() {
    super.initState();
    findAllHistory();
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

  // historyInfo 信息
  Widget historyInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Padding(padding: EdgeInsets.only(left: 100)),
        Text("评价者"),
        Padding(padding: EdgeInsets.only(left: 236)),
        Text("内容"),
        Padding(padding: EdgeInsets.only(left: 300)),
        Text("时间"),
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
