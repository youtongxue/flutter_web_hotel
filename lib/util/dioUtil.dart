import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class DioUtils {
  //static const String BASE_URL = "http://localhost:8096/hotel"; //base url
  static const String BASE_URL = "https://singlestep.cn/hotel"; //base url
  static late DioUtils _instance;
  late Dio _dio;
  late BaseOptions _baseOptions;

  static DioUtils getInstance() {
    _instance ??= DioUtils();
    return _instance;
  }

  /// dio初始化配置
  DioUtils() {
    //请求参数配置
    _baseOptions = BaseOptions(
      baseUrl: BASE_URL,
    );

    //创建dio实例
    _dio = Dio(_baseOptions);
  }

  /// get请求
  get(url, {data, options}) async {
    print('get request path ------${url}-------请求参数${data}');
    late Response response;
    try {
      response = await _dio.get(url, queryParameters: data, options: options);
      debugPrint('<get> result->${response.data}');
    } on DioError catch (e) {
      print('请求失败---错误类型${e.type}--错误信息${e.message}');
    }

    return response;
  }

  /// Post请求
  post(url, {data, options}) async {
    print('post 请求 path ------${url}-------请求参数${data}');
    late Response response;
    try {
      response = await _dio.post(url, data: data, options: options);
      print('post 结果 -----${response.data}');
    } on DioError catch (e) {
      print('请求失败---错误类型${e.type}--错误信息${e.message}');
    }

    return response;
  }
}
