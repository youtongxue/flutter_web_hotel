import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/pages/user.dart';

import '../../bean/normalresult.dart';
import '../../bean/workorder.dart';
import '../../util/dioUtil.dart';

class PersonWorkOrder extends StatefulWidget {
  const PersonWorkOrder({super.key});

  @override
  State<PersonWorkOrder> createState() => _PersonWorkOrderState();
}

class _PersonWorkOrderState extends State<PersonWorkOrder> {
  @override
  void initState() {
    super.initState();
    findAllByOrderId();
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

  List<Result> listWorkOrder = [];
  //根据 orderId 查询所有工单信息 HTTP
  findAllByOrderId() async {
    Map<String, dynamic> query = {"orderId": globPersonOrderId};
    Response re = await DioUtils().get("/workorder/orderid", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      //判断结果
      if (jsonDate["code"].toString() == "200") {
        WorkOrder workOrder = WorkOrder.fromJson(jsonDate);
        setState(() {
          listWorkOrder = workOrder.result;
        });
      } else {
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        //_showDialog(norMalResult.message);
      }
    }
  }

  //根据 orderId 查询所有工单信息 HTTP
  addWorkOrder(String content) async {
    Map<String, dynamic> data = {
      "workOrderId": null,
      "createTime": null,
      "orderId": globPersonOrderId,
      "content": content,
      "state": null,
    };
    Response re = await DioUtils().post("/workorder/add", data: data);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      //判断结果
      if (jsonDate["code"].toString() == "200") {
        findAllByOrderId();
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        _showDialog(norMalResult.message);
      } else {
        //_showDialog(norMalResult.message);
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var workOrderController = TextEditingController();

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
                    controller: workOrderController,
                    decoration: const InputDecoration(
                        labelText: "新增工单", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(workOrderController.text);
                      if (workOrderController.text.isEmpty) {
                        _showDialog("内容不可为空!");
                        return;
                      }
                      if (globPersonOrderId == null) {
                        _showDialog("本地信息错误");
                        return;
                      }

                      addWorkOrder(workOrderController.text);
                    },
                    child: const Text("提交"),
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
        Text("用户名"),
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
          itemCount: listWorkOrder.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listWorkOrder[index].content.toString()),
                  Text(listWorkOrder[index].state.toString()),
                  Text(listWorkOrder[index].createTime.toString()),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    print("全局变量 > > >$globPersonOrderId");
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
