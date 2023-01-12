import 'package:flutter/material.dart';

import 'routes/route.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      initialRoute: "/loginPage",
      // 2.配置 onGenerateRoute 固定写法
      onGenerateRoute: appOnGenerateRoute,
    ),
  );
}
