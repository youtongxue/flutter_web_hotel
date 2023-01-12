import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hotel/bean/normalresult.dart';
import 'package:hotel/bean/oneOrder.dart';
import 'package:hotel/bean/oneRoom.dart';

import '../../bean/room.dart';
import '../../util/dioUtil.dart';

class RoomShowWidget extends StatefulWidget {
  const RoomShowWidget({super.key});

  @override
  State<RoomShowWidget> createState() => _RoomShowWidgetState();
}

class _RoomShowWidgetState extends State<RoomShowWidget> {
  @override
  void initState() {
    super.initState();
    findAllStateRoom("all");
  }

  // 新增Hotel订单
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var personIdController = TextEditingController();
  var emailController = TextEditingController();
  int groupValue = 1;
  String startString = "起始日期";
  String endString = "截止日期";

  int? roomId;
  String? username;
  String? sex = "男";
  String? personId;
  String? phone;
  String? email;
  DateTime? startTime;
  DateTime? endTime;

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

  _showNewOrderDialog() {
    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("入住办理"),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "姓名",
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Row(
                    children: [
                      const Text("男："),
                      Radio(
                          value: 1,
                          groupValue: groupValue,
                          onChanged: (value) {
                            print(value);
                            sex = "男";
                            setState(() {
                              groupValue = value!;
                            });
                          }),
                      const Padding(padding: EdgeInsets.only(left: 12)),
                      const Text("女："),
                      Radio(
                          value: 2,
                          groupValue: groupValue,
                          onChanged: (value) {
                            print(value);
                            sex = "女";
                            setState(() {
                              groupValue = value!;
                            });
                          }),
                    ],
                  ),
                  TextField(
                    controller: personIdController,
                    decoration: const InputDecoration(
                      labelText: "身份证号",
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "手机号",
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "邮箱",
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(startString),
                      ElevatedButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2023, 1, 1),
                              maxTime: DateTime(2023, 12, 31),
                              onConfirm: (date) {
                            print('选择时间为： $date');
                            startTime = date;
                            setState(() {
                              startString =
                                  "${date.year}年${date.month}月${date.day}日";
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.zh);
                        },
                        child: Text("起始日期"),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(endString),
                      ElevatedButton(
                        onPressed: () {
                          if (startTime == null) {
                            _showDialog("请先选择起始日期");
                            return;
                          }
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: startTime,
                              maxTime: DateTime(2023, 12, 31),
                              onConfirm: (date) {
                            print('选择时间为： $date');
                            endTime = date;
                            setState(() {
                              endString =
                                  "${date.year}年${date.month}月${date.day}日";
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.zh);
                        },
                        child: const Text("截止日期"),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  username = nameController.text;
                  personId = personIdController.text;
                  phone = phoneController.text;
                  email = emailController.text;
                  // 参数未填写完整
                  if (username == null ||
                      sex == null ||
                      personId == null ||
                      phone == null ||
                      email == null ||
                      startTime == null ||
                      endTime == null) {
                    _showDialog("请完整填写信息!");
                    return;
                  }

                  // 关闭弹窗，发送网络请求
                  Navigator.of(context).pop();
                  addHotelOrder();
                  // 清除输入框缓存
                  nameController.clear();
                  personIdController.clear();
                  phoneController.clear();
                  emailController.clear();
                  startString = "起始日期";
                  endString = "截止日期";
                },
                child: const Text("确定")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // 清除输入框缓存
                  nameController.clear();
                  personIdController.clear();
                  phoneController.clear();
                  emailController.clear();
                  startString = "起始日期";
                  endString = "截止日期";
                },
                child: const Text("取消"))
          ],
        );
      }),
    );
  }

  List<Result> listRoom = [];
  //查询所有房间信息 HTTP
  findAllStateRoom(String state) async {
    Map<String, dynamic> query = {"state": state};
    Response re = await DioUtils().get("/room/state", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());
      Room room = Room.fromJson(jsonDate);
      //判断结果
      if (room.code.toString() == "200") {
        setState(() {
          listRoom = room.result;
        });
      }
    }
  }

  // 新增 Hotel 订单
  addHotelOrder() async {
    Map<String, dynamic> data = {
      "orderId": null,
      "personPhone": phone,
      "personEmail": email,
      "personName": username,
      "personSex": sex,
      "personId": personId,
      "password": null,
      "roomId": roomId,
      "startTime": startTime.toString(),
      "endTime": endTime.toString(),
      "orderPrice": null,
      "createDate": null,
    };

    Response re = await DioUtils().post("/order/add", data: data);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      if (jsonDate["code"].toString() == "200") {
        //刷新列表
        findAllStateRoom("all");
        OneOrder oneOrder = OneOrder.fromJson(jsonDate);
        _showDialog("用户密码: ${oneOrder.result.password}");
      } else {
        NorMalResult norMalResult = NorMalResult.fromJson(jsonDate);
        _showDialog(norMalResult.message);
      }
    }
  }

  // 根据 roomID 查询房间信息 HTTP
  findRoomByRoomId(String roomId) async {
    Map<String, dynamic> query = {"roomId": roomId};
    Response re = await DioUtils().get("/room/roomid", data: query);

    if (re.statusCode == 200) {
      var jsonDate = jsonDecode(re.toString());

      if (jsonDate["code"].toString() == "200") {
        OneRoom room = OneRoom.fromJson(jsonDate);
        Result oneRoom = Result(
            roomId: room.result.roomId,
            state: room.result.state,
            price: room.result.price,
            orderId: room.result.orderId);

        setState(() {
          listRoom.clear();
          listRoom.add(oneRoom); // 将查询到的数据添加进列表

          _clickIndex = 3;
          _hoverIndex = 3;
        });
      } else {
        // 清除列表数据
        setState(() {
          listRoom.clear();
          _clickIndex = 3;
          _hoverIndex = 3;
        });
        NorMalResult normal = NorMalResult.fromJson(jsonDate);
        _showDialog(normal.message);
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
        findAllStateRoom("all");
      }
    }
  }

  final itemTexts = ["所有房间", "正在使用", "空闲房间"];
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
              findAllStateRoom("all");
              break;
            case 1:
              findAllStateRoom("use");
              break;
            case 2:
              findAllStateRoom("leisure");
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
    var roomIdController = TextEditingController();

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
                    controller: roomIdController,
                    decoration: const InputDecoration(
                        labelText: "房间号", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    onPressed: () {
                      if (roomIdController.text.isEmpty) {
                        _showDialog("房间号不能为空！");
                        return;
                      } else {
                        findRoomByRoomId(roomIdController.text);
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

// roomInfo 信息
  Widget roomInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text("房间号"),
        Text("订单号"),
        Text("单日价"),
        Text("状态"),
        Padding(padding: EdgeInsets.only(right: 130))
      ],
    );
  }

// 底部数据展示
  Widget dataShow() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: listRoom.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(listRoom[index].roomId.toString()),
                  Text(listRoom[index].orderId.toString()),
                  Text(listRoom[index].price.toString()),
                  Text(
                      listRoom[index].state.toString() == "use" ? "使用中" : "空闲"),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          listRoom[index].state.toString() == "use"
                              ? Colors.blue
                              : Colors.green),
                    ),
                    onPressed: () {
                      switch (listRoom[index].state.toString()) {
                        case "use":
                          // 退房
                          delByOrderId(int.parse(listRoom[index].orderId));
                          setState(() {
                            _clickIndex = 0;
                            _hoverIndex = 0;
                          });
                          break;
                        case "leisure":
                          // 入住
                          print("object");
                          roomId = listRoom[index].roomId;
                          _showNewOrderDialog();
                          break;
                      }
                    },
                    child: Text(listRoom[index].state.toString() == "use"
                        ? "退房"
                        : "入住"),
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
              child: roomInfo(),
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
