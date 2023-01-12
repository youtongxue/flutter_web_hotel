import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/bean/normalresult.dart';

import '../../bean/workorder.dart';
import '../../util/dioUtil.dart';

class WorkShowWidget extends StatefulWidget {
  const WorkShowWidget({super.key});

  @override
  State<WorkShowWidget> createState() => _WorkShowWidgetState();
}

class _WorkShowWidgetState extends State<WorkShowWidget> {
  @override
  void initState() {
    super.initState();
    findAllByWorkOrderState("all");
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
  String updateResult = '';
  //根据 state 查询所有工单信息 HTTP
  findAllByWorkOrderState(String workOrderState) async {
    Map<String, dynamic> query = {"state": workOrderState};
    Response re = await DioUtils().get("/workorder/state", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      WorkOrder workOrder = WorkOrder.fromJson(jsonDate);
      //判断结果
      if (workOrder.code.toString() == "200") {
        setState(() {
          listWorkOrder = workOrder.result;
        });
      }
    }
  }

  //根据 orderId 查询所有工单信息 HTTP
  findAllByOrderId(int orderId) async {
    Map<String, dynamic> query = {"orderId": orderId};
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
        _showDialog(norMalResult.message);
      }
    }
  }

  //根据工单 id 修改 state 值
  updateByWorkOrderId(int workOrderId, String state) async {
    Map<String, dynamic> query = {
      "workOrderState": state,
      "workOrderId": workOrderId,
    };
    Response re = await DioUtils().get("/workorder/update", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      NorMalResult workOrder = NorMalResult.fromJson(jsonDate);
      //判断结果
      if (workOrder.code.toString() == "200") {
        findAllByWorkOrderState("all"); //刷新列表
        setState(() {
          updateResult = workOrder.result.toString();
          print(updateResult);
        });
      }
    }
  }

  // WorkOrderInfo 信息
  Widget workOrderInfo() {
    return Row(
      children: const [
        Padding(padding: EdgeInsets.only(left: 56)),
        Text("工单号"),
        Padding(padding: EdgeInsets.only(left: 106)),
        Text("订单号"),
        Padding(padding: EdgeInsets.only(left: 140)),
        Text("提交内容"),
        Padding(padding: EdgeInsets.only(left: 166)),
        Text("状态"),
        Padding(padding: EdgeInsets.only(left: 180)),
        Text("创建时间"),
      ],
    );
  }

  final itemTexts = ["所有工单", "待处理", "已完成", "异常工单"];
  int _clickIndex = 0;
  int _hoverIndex = 0;

  Color itemTextColor(int itemIndex, int hoverIndex) {
    Color color = Colors.black;

    if (itemIndex == _clickIndex) {
      color = Colors.green;
    }

    if (itemIndex == hoverIndex && itemIndex != _clickIndex) {
      color = Colors.green;
    }

    return color;
  }

  Color itemIndexColor(int itemIndex, int hoverIndex) {
    Color color = Colors.transparent;

    if (itemIndex == _clickIndex) {
      color = Colors.green;
    }

    if (itemIndex == hoverIndex && itemIndex != _clickIndex) {
      color = Colors.transparent;
    }

    return color;
  }

  Widget topNavItem(int itemIndex) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hoverIndex = itemIndex;
        });
      },
      onExit: (event) {
        setState(() {
          _hoverIndex = _clickIndex;
        });
      },
      child: InkWell(
        onTap: () {
          // 发起网络请求
          switch (itemIndex) {
            case 0:
              findAllByWorkOrderState("all");
              break;
            case 1:
              findAllByWorkOrderState("wait");
              break;
            case 2:
              findAllByWorkOrderState("done");
              break;
            case 3:
              findAllByWorkOrderState("withdraw");
              break;
          }

          setState(() {
            _clickIndex = itemIndex;
          });
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  //color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    itemTexts[itemIndex],
                    style: TextStyle(
                      color: itemTextColor(itemIndex, _hoverIndex),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        color: itemIndexColor(itemIndex, _hoverIndex),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "字符",
                      style: TextStyle(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 顶部导航栏
  Widget topNav() {
    var orderIdController = TextEditingController();

    return Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          // 房间分类
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  topNavItem(0),
                  topNavItem(1),
                  topNavItem(2),
                  topNavItem(3),
                ],
              ),
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
                    controller: orderIdController,
                    decoration: const InputDecoration(
                        labelText: "订单号", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      print(orderIdController.text);
                      if (orderIdController.text.isEmpty) {
                        _showDialog("工单号不可为空!");
                        return;
                      }
                      findAllByOrderId(int.parse(orderIdController.text));
                      setState(() {
                        _clickIndex = 4;
                        _hoverIndex = 4;
                      });
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
                  Text(listWorkOrder[index].workOrderId.toString()),
                  Text(listWorkOrder[index].orderId.toString()),
                  Text(listWorkOrder[index].content.toString()),
                  Text(listWorkOrder[index].state.toString()),
                  Text(listWorkOrder[index].createTime.toString()),
                  listWorkOrder[index].state.toString() == "wait"
                      ? ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: () {
                            print("确认处理");
                            updateByWorkOrderId(
                                listWorkOrder[index].workOrderId, "done");
                          },
                          child: const Text("确认处理"),
                        )
                      : const Padding(padding: EdgeInsets.only(right: 88)),
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
            // 顶部导航栏
            Expanded(flex: 1, child: topNav()),
            const Divider(
              color: Colors.black54,
              height: 10,
            ),
            Expanded(flex: 1, child: workOrderInfo()),
            const Divider(
              color: Colors.black54,
              height: 10,
            ),
            // 底部数据展示
            Expanded(flex: 13, child: dataShow()),
          ],
        ),
      ),
    );
  }
}
