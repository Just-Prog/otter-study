import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/utils/permission/storage.dart';
import 'interceptors.dart';

int _downloadCount = 1;
int _downloadTotal = 1;

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
    if (Platform.isAndroid) {
      bool result = await storagePermissionCheck();
      if (!result) {
        return;
      }
    }
    String pathDivider = Platform.isWindows ? r"\" : r"/";
    var target = "${(await getDownloadDirectory()).path}$pathDivider$name";
    final GlobalKey _loadingKey = GlobalKey();
    SmartDialog.showLoading(builder: (_) => _DownloadLoading(key: _loadingKey));
    late final Response resp;
    try {
      resp = await dio.download(
        url,
        target,
        queryParameters: params,
        options: Options(method: method),
        data: data,
        onReceiveProgress: (count, total) {
          _downloadCount = count;
          _downloadTotal = total;
          _loadingKey.currentState!.setState(
            () {},
          );
        },
      );
      SmartDialog.showToast("文件已保存至 ${target}");
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
    SmartDialog.dismiss(status: SmartStatus.loading);
    _downloadCount = 1;
    _downloadTotal = 1;
    return;
  }

  put(String url, {params, data, options}) async {
    final Response resp = await dio.put(url,
        queryParameters: params, options: options, data: data);
    return resp;
  }
}

class _DownloadLoading extends StatefulWidget {
  const _DownloadLoading({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadLoadingState();
}

class _DownloadLoadingState extends State<_DownloadLoading> {
  static final GlobalKey<_DownloadLoadingState> key = GlobalKey();

  reloadData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("下载"),
        contentPadding: EdgeInsets.symmetric(vertical: 30),
        content: Container(
            width: double.maxFinite,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    if (_downloadCount == 0) ...[
                      LinearProgressIndicator(),
                    ] else ...[
                      LinearProgressIndicator(
                        value: _downloadCount / _downloadTotal,
                      ),
                    ],
                    Text("$_downloadCount / $_downloadTotal")
                  ],
                ))));
  }
}
