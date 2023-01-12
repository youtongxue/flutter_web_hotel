import 'package:flutter/material.dart';
import 'package:hotel/compoents/appraise/personAppraise.dart';

import '../compoents/notic/personNotic.dart';
import '../compoents/order/personOrder.dart';
import '../compoents/workorder/personWorkOrder.dart';

int? globPersonOrderId;
late String globPersonId;
String globPersonName = '';

class UserPage extends StatefulWidget {
  final Map arguments;
  const UserPage({super.key, required this.arguments});
  //const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _clickIndex = 0;
  int _hoverIndex = 0;
  final List<Widget> _showPages = const [
    PersonOrder(),
    PersonWorkOrder(),
    PersonNotic(),
    PersonAppraise(),
  ];

  final List<Icon> _icons = const [
    Icon(Icons.houseboat),
    Icon(Icons.work),
    Icon(Icons.notification_add),
    Icon(Icons.pentagon),
  ];

  final List<Text> _texts = const [
    Text("个人信息"),
    Text("工单信息"),
    Text("公告信息"),
    Text("评价信息"),
  ];

  // Color _contentDefColor = Colors.black;
  // Color _backgroundDefColor = Colors.white;

  Color itemColor(int itemIndex, int hoverIndex, int type) {
    Color contentDefColor = Colors.black54;
    Color backgroundDefColor = Colors.white;

    if (type == 0) {
      // 返回背景色
      if (itemIndex == _clickIndex) {
        backgroundDefColor = Colors.blue;
      }

      if (itemIndex == _hoverIndex && itemIndex != _clickIndex) {
        backgroundDefColor = Colors.black12;
        //print("重构背景色");
      }
      return backgroundDefColor;
    } else {
      // 返回内容颜色
      if (itemIndex == _clickIndex) {
        contentDefColor = Colors.white;
      }
      return contentDefColor;
    }
  }

  // 导航栏 item
  navItem(int itemIndex) {
    return MouseRegion(
      onEnter: (event) {
        //print("enter item $itemIndex");
        setState(() {
          _hoverIndex = itemIndex;
        });
      },
      onExit: (event) {
        setState(() {
          _hoverIndex = _clickIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: itemColor(itemIndex, _hoverIndex, 0),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          // content 内间距
          hoverColor: Colors.red,
          leading: _icons[itemIndex],
          iconColor: itemColor(itemIndex, _hoverIndex, 1),
          title: _texts[itemIndex],
          textColor: itemColor(itemIndex, _hoverIndex, 1),
          onTap: () {
            setState(() {
              _clickIndex = itemIndex;
            });
          },
        ),
      ),
    );
  }

  // 左侧导航栏
  Widget leftNav() {
    return Expanded(
      flex: 1,
      // 左边菜单栏纵向 Flex
      child: Flex(
        direction: Axis.vertical,
        children: [
          // 当前登录账号信息
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "当前账户：",
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 6)),
                        Text(globPersonName),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 导航栏Item
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(0),
                navItem(1),
                navItem(2),
                navItem(3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 右侧数据部分
  Widget rightShow() {
    return Expanded(
      flex: 6,
      child: _showPages[_clickIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 管理员的 name
    globPersonId = widget.arguments['name'];

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            leftNav(),
            rightShow(),
          ],
        ),
      ),
    );
  }
}
