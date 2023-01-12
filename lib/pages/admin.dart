import 'package:flutter/material.dart';
import 'package:hotel/compoents/admin/adminshow.dart';
import 'package:hotel/compoents/appraise/appraiseshow.dart';
import 'package:hotel/compoents/history/historyshow.dart';
import 'package:hotel/compoents/notic/noticshow.dart';
import 'package:hotel/compoents/order/ordershow.dart';
import 'package:hotel/compoents/room/roomshow.dart';
import 'package:hotel/compoents/workorder/workshow.dart';

late String globSuperName;
late String globSuperPassWord;

class AdminPage extends StatefulWidget {
  final Map arguments;
  const AdminPage({super.key, required this.arguments});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _clickIndex = 0;
  int _hoverIndex = 0;
  final List<Widget> _showPages = const [
    RoomShowWidget(),
    OrderShowWidget(),
    WorkShowWidget(),
    NoticShowWidget(),
    AppRaiseShowWidget(),
    AdminShowWidget(),
    HistoryShowWidget(),
  ];

  final List<Icon> _icons = const [
    Icon(Icons.houseboat),
    Icon(Icons.money_off_csred_rounded),
    Icon(Icons.work),
    Icon(Icons.notification_add),
    Icon(Icons.pentagon),
    Icon(Icons.person),
    Icon(Icons.history),
  ];

  final List<Text> _texts = const [
    Text("房间信息"),
    Text("当前订单"),
    Text("工单信息"),
    Text("公告信息"),
    Text("评价信息"),
    Text("管理相关"),
    Text("历史订单"),
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
                        const Text("当前账户："),
                        const Padding(padding: EdgeInsets.only(bottom: 6)),
                        Text(widget.arguments["name"]),
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
                navItem(4),
                navItem(5),
                navItem(6),
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
    // 管理员的 name,password
    globSuperName = widget.arguments["name"];
    globSuperPassWord = widget.arguments["password"];

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
