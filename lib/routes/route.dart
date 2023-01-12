import 'package:flutter/material.dart';
import 'package:hotel/pages/admin.dart';
import 'package:hotel/pages/login.dart';
import 'package:hotel/pages/user.dart';

// 1.配置路由
Map routes = {
  // "/mainPage": (context) => const MyTabe(),
  "/loginPage": (context) => const LoginPage(),
  "/adminPage": (context, {arguments}) => AdminPage(arguments: arguments),
  //"/adminPage": (context, {arguments}) => const AdminPage(),
  "/userPage": (context, {arguments}) => UserPage(arguments: arguments),
  //"/userPage": (context) => const UserPage(),
  // "/gridPage": (context) => const GridViewWidget(),
  // "/rowPage": (context) => const RowWidget(),
  // "/flexPage": (context) => const FlexWidget(),
  // "/stackPage": (context) => const StackWidget(),
  // "/arPage": (context) => const AspectRatioWidget(),
  // "/cardPage": (context) => const CardWidget(),
  // "/buttonPage": (context) => const ButtonWidget(),
  // "/warpPage": (context) => const WarpWidget(),
  // "/statefulPage": (context) => const MyStatefulWidget(),
  // "/drawerPage": (context) => const MyDrawerWidget(),
  // "/tabbarPage": (context) => const MyTabBar(),
  // "/navigatorPage": (context) => const MyNavigator(),
  // "/dioPage": (context) => const DioPage(),
  // "/..": (context, {arguments}) => FromPage(arguments: arguments),
};

// 2.配置 onGenerateRoute 固定写法 相当于一个中间件，可以做权限判断
var appOnGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name; // "/frompage" 命名路由名称
  final Function? pageContentBuilder = routes[
      name]; // Function (context, {arguments}) => FromPage(arguments: arguments)
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};
