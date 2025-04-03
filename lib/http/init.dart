import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:downloadsfolder/downloadsfolder.dart';

import 'package:otter_study/http/index.dart';
import 'interceptors.dart';

class Request {
  static final Request _instance = Request._internal();

  static late CookieManager cookieManager;
  static late final Dio dio;
  factory Request() => _instance;

  Request._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiBase.baseUrl,
      headers: {
        "accept": "application/json, text/plain, */*",
        "accept-language": "zh-CN,zh;q=0.9,en;q=0.8",
        "origin": ApiBase.baseOriginUrl,
        "referer": ApiBase.baseOriginUrl,
        'user-agent':
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
        'x-appver': "pc:teaching:pc:3.0-1",
        'x-authorization': "",
        'x-tenant': ""
      },
    );
    dio = Dio(options);
    dio.interceptors.add(ApiInterceptor());
  }

  get(String url, {params, options}) async {
    final Response resp =
        await dio.get(url, queryParameters: params, options: options);
    return resp;
  }

  post(String url, data, {params, options}) async {
    final Response resp = await dio.post(url,
        data: data, queryParameters: params, options: options);
    return resp;
  }

  download(String url, String name,
      {path, params, method = "GET", data}) async {
    String pathDivider = Platform.isWindows ? r"\" : r"/";
    var target = "${(await getDownloadDirectory()).path}$pathDivider$name";
    log(target);
    final Response resp = await dio.download(url, target,
        queryParameters: params, options: Options(method: method), data: data);
    return resp;
  }

  put(String url, {params, options}) async {
    final Response resp =
        await dio.put(url, queryParameters: params, options: options);
    return resp;
  }
}
