import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../bean/notice.dart';
import '../../util/dioUtil.dart';

class PersonNotic extends StatefulWidget {
  const PersonNotic({super.key});

  @override
  State<PersonNotic> createState() => _PersonNoticState();
}

class _PersonNoticState extends State<PersonNotic> {
  @override
  void initState() {
    super.initState();
    findAllNotice();
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

  List<NoticeResult> listNotice = [];
  //查询所有公告信息 HTTP
  findAllNotice() async {
    Response re = await DioUtils().get("/notice/all");

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      Notice notice = Notice.fromJson(jsonDate);
      //判断结果
      if (notice.code.toString() == "200") {
        setState(() {
          listNotice = notice.result;
        });
      }
    }
  }

  // noticInfo 信息
  Widget noticeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text("内容"),
        Text("发布时间"),
      ],
    );
  }

// 底部数据展示
  Widget dataShow() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: listNotice.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listNotice[index].content.toString()),
                  Text(listNotice[index].createTime.toString()),
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
