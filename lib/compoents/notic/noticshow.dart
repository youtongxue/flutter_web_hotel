import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../bean/addnotice.dart';
import '../../bean/normalresult.dart';
import '../../bean/notice.dart';
import '../../util/dioUtil.dart';

class NoticShowWidget extends StatefulWidget {
  const NoticShowWidget({super.key});

  @override
  State<NoticShowWidget> createState() => _NoticShowWidgetState();
}

class _NoticShowWidgetState extends State<NoticShowWidget> {
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

  //根据 noticeId 删除公告 HTTP
  delByNoticeId(int noticeId) async {
    Map<String, dynamic> query = {"noticeId": noticeId};
    Response re = await DioUtils().get("/notice/del", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      NorMalResult notice = NorMalResult.fromJson(jsonDate);
      //判断结果
      if (notice.code.toString() == "200") {
        print("删除公告成功");
        setState(() {
          findAllNotice();
        });
      }
    }
  }

  // 新增公告
  addNotic(String content) async {
    Map<String, dynamic> data = {
      "noticeId": null,
      "createTime": null,
      "content": content
    };

    Response re = await DioUtils().post("/notice/add", data: data);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      AddNotice notice = AddNotice.fromJson(jsonDate);
      //判断结果
      if (notice.code.toString() == "200") {
        print("新增公告成功");
        setState(() {
          findAllNotice();
        });
        _showDialog("新增成功!");
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var noticeController = TextEditingController();

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
                    controller: noticeController,
                    decoration: const InputDecoration(
                        labelText: "新增公告内容", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(noticeController.text);
                      if (noticeController.text.isEmpty) {
                        _showDialog("内容不可为空!");
                        return;
                      } else {
                        addNotic(noticeController.text);
                      }
                    },
                    child: const Text("新增公告"),
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
        Padding(padding: EdgeInsets.only(left: 100)),
        Text("公告号"),
        Padding(padding: EdgeInsets.only(left: 236)),
        Text("内容"),
        Padding(padding: EdgeInsets.only(left: 300)),
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
          itemCount: listNotice.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listNotice[index].noticeId.toString()),
                  Text(listNotice[index].content.toString()),
                  Text(listNotice[index].createTime.toString()),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      print("删除公告");
                      delByNoticeId(listNotice[index].noticeId);
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
