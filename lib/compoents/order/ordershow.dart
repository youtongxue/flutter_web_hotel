import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/bean/normalresult.dart';
import 'package:hotel/bean/oneOrder.dart';
import 'package:hotel/bean/order.dart';

import '../../util/dioUtil.dart';

class OrderShowWidget extends StatefulWidget {
  const OrderShowWidget({super.key});

  @override
  State<OrderShowWidget> createState() => _OrderShowWidgetState();
}

class _OrderShowWidgetState extends State<OrderShowWidget> {
  @override
  void initState() {
    super.initState();
    findAllOrder();
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

  List<Result> listOrder = [];
  //查询所有订单信息 HTTP
  findAllOrder() async {
    Response re = await DioUtils().get("/order/all");

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      Order room = Order.fromJson(jsonDate);
      //判断结果
      if (room.code.toString() == "200") {
        setState(() {
          listOrder = room.result;
        });
      }
    }
  }

  //根据 personId 查询所有订单信息 HTTP
  findByPersonId(String personId) async {
    Map<String, dynamic> query = {"personId": personId};
    Response re = await DioUtils().get("/order/personid", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      //判断结果
      if (jsonDate["code"].toString() == "200") {
        OneOrder order = OneOrder.fromJson(jsonDate);
        Result result = Result(
            orderId: order.result.orderId,
            personPhone: order.result.personPhone,
            personEmail: order.result.personEmail,
            personName: order.result.personName,
            personSex: order.result.personSex,
            personId: order.result.personId,
            password: order.result.password,
            roomId: order.result.roomId,
            startTime: order.result.startTime,
            endTime: order.result.endTime,
            orderPrice: order.result.orderPrice,
            createDate: order.result.createDate);
        setState(() {
          listOrder.add(result);
        });
      } else {
        setState(() {
          listOrder.clear();
        });
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        _showDialog(norMalResult.message);
      }
    }
  }

  // 根据 orderID 删除订单
  delByOrderId(int orderId) async {
    Map<String, dynamic> query = {"orderId": orderId};
    Response re = await DioUtils().get("/order/del", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      if (jsonDate["code"].toString() == "200") {
        findAllOrder();
      }
    }
  }

  // 根据 orderId 查询订单
  findByOrderId(int orderId) async {
    Map<String, dynamic> query = {"orderId": orderId};
    Response re = await DioUtils().get("/order/orderid", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      if (jsonDate["code"].toString() == "200") {
        OneOrder oneOrder = OneOrder.fromJson(jsonDate);
        Result result = Result(
            orderId: oneOrder.result.orderId,
            personPhone: oneOrder.result.personPhone,
            personEmail: oneOrder.result.personEmail,
            personName: oneOrder.result.personName,
            personSex: oneOrder.result.personSex,
            personId: oneOrder.result.personId,
            password: oneOrder.result.password,
            roomId: oneOrder.result.roomId,
            startTime: oneOrder.result.startTime,
            endTime: oneOrder.result.endTime,
            orderPrice: oneOrder.result.orderPrice,
            createDate: oneOrder.result.createDate);
        listOrder.clear();
        setState(() {
          listOrder.add(result);
        });
      } else {
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        setState(() {
          listOrder.clear();
        });
        _showDialog(norMalResult.message);
      }
    }
  }

  // 顶部导航栏
  Widget topNav() {
    var personIdController = TextEditingController();
    var orderIdController = TextEditingController();

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
                        _showDialog("身份证号不能为空!");
                        return;
                      } else {
                        findByPersonId(personIdController.text);
                      }
                    },
                    child: const Text("查询"),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: orderIdController,
                    decoration: const InputDecoration(
                        labelText: "订单ID", prefixIcon: Icon(Icons.search)),
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
                        _showDialog("订单号不能为空!");
                        return;
                      } else {
                        findByOrderId(int.parse(orderIdController.text));
                      }
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

// orederInfo 信息
  Widget orderInfo() {
    return Row(
      children: const [
        Text("订单"),
        Padding(padding: EdgeInsets.only(left: 8)),
        Text("房间"),
        Padding(padding: EdgeInsets.only(left: 8)),
        Text("用户名"),
        Padding(padding: EdgeInsets.only(left: 18)),
        Text("性别"),
        Padding(padding: EdgeInsets.only(left: 60)),
        Text("身份证号"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("手机号"),
        Padding(padding: EdgeInsets.only(left: 60)),
        Text("Email"),
        Padding(padding: EdgeInsets.only(left: 40)),
        Text("密码"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("入住"),
        Padding(padding: EdgeInsets.only(left: 160)),
        Text("结束"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("费用"),
        Padding(padding: EdgeInsets.only(left: 80)),
        Text("创建时间"),
      ],
    );
  }

// 底部数据展示
  Widget dataShow() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: listOrder.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listOrder[index].orderId.toString()),
                  Text(listOrder[index].roomId.toString()),
                  Text(listOrder[index].personName.toString()),
                  Text(listOrder[index].personSex.toString()),
                  Text(listOrder[index].personId.toString()),
                  Text(listOrder[index].personPhone.toString()),
                  Text(listOrder[index].personEmail.toString()),
                  Text(listOrder[index].password.toString()),
                  Text(listOrder[index].startTime.toString()),
                  Text(listOrder[index].endTime.toString()),
                  Text(listOrder[index].orderPrice.toString()),
                  Text(listOrder[index].createDate.toString()),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      print("退房");
                      delByOrderId(listOrder[index].orderId);
                    },
                    child: Text("退房"),
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
            // 顶部导航栏
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
              child: orderInfo(),
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
