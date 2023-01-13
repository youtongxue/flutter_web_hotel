import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel/pages/user.dart';

import '../../bean/normalresult.dart';
import '../../bean/oneOrder.dart';
import '../../bean/order.dart';
import '../../util/dioUtil.dart';

class PersonOrder extends StatefulWidget {
  const PersonOrder({super.key});

  @override
  State<PersonOrder> createState() => _PersonOrderState();
}

class _PersonOrderState extends State<PersonOrder> {
  @override
  void initState() {
    super.initState();
    findByPersonId(globPersonId);
  }

  Result? personData;
  String infoResult = "正在查询...";
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
          personData = result;
          globPersonOrderId = result.orderId; // 拿到用户 orderID 设置全局变量
          globPersonName = result.personName;
        });
      } else {
        setState(() {
          infoResult = "获取用户信息失败!";
        });
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (personData == null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(infoResult),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(left: 40),
      color: Colors.white,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("姓名："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.personName),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("性别："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.personSex),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("身份证号："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.personId),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("邮箱："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.personEmail),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("起始日期："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.startTime.toString()),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("截止日期："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.endTime.toString()),
            ],
          ),
          const Padding(padding: EdgeInsets.only(left: 100, top: 50)),
          Row(
            children: [
              const Text("预估费用："),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(personData!.orderPrice.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
