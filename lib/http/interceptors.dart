import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/pages/login/controller/index.dart';

class ApiInterceptor extends Interceptor {
  final _apiCredentialController = Get.put(CredentialController());
  final _userController = Get.put(UserController());

  macGen(options, auth) async {
    Uri uri = options.uri;
    String query = uri.hasQuery ? "?${uri.query}" : "";
    String path = uri.path + query;
    String method = options.method.toUpperCase();
    String host = options.uri.host;
    String target =
        '$method\n$host\n$path\n${auth['nonce']}\n${auth['timestamp']}';
    var _hmac = Hmac(sha256, utf8.encode(auth['mackey']));
    var hmac = _hmac.convert(utf8.encode(target));
    String result = base64Encode(hmac.bytes)
        .replaceAll("+", "-")
        .replaceAll("=", "")
        .replaceAll("/", "_");
    return result;
  }

  @override
  void onRequest(options, handler) async {
    if (options.uri.host == "obs.goktech.cn" ||
        options.uri.host == "vod.goktech.cn") {
      handler.next(options);
      return;
    }
    if (options.extra['version'] != null &&
        options.extra['version'] == "android") {
      options.headers['user-agent'] =
          "Mozilla/5.0 (Linux; Android 15) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.0.1 Mobile Safari/537.36 uni-app Html5Plus/1.0 (Immersed/29.333334)";
      options.headers['X-AppVer'] = "android:teaching:app:3.1.14-1";
    } else if (options.extra['version'] != null &&
        options.extra['version'] == "ios") {
      options.headers['user-agent'] =
          "Mozilla/5.0 (iPad; CPU OS 16_2_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Html5Plus/1.0 (Immersed/20) uni-app";
      options.headers['X-AppVer'] = "ios:teaching:app:3.1.14-1";
    }
    log("request path: ${options.uri.path}");
    if (options.extra['target'] != null && options.extra['target'] == "login") {
      handler.next(options);
      return;
    }
    if (_apiCredentialController.isLoggedIn.value == false) {
      handler.next(options);
      return;
    }
    Map<String, dynamic> auth = await _apiCredentialController.loadCredential();
    var params = Map.fromEntries(options.uri.queryParameters.entries.toList()
      ..sort((a1, a2) => a1.key.compareTo(a2.key)));
    options.queryParameters = params;
    var jwt = jsonDecode(utf8.decode(base64Decode(base64.normalize(auth['token']
        .split('.')[1]
        .replaceAll("-", "+")
        .replaceAll("_", "/")))));
    try {
      if (DateTime.fromMillisecondsSinceEpoch(jwt['exp'])
              .isBefore(DateTime.now().add(Duration(hours: 1, minutes: 45))) &&
          !(options.extra['target'] != null &&
              options.extra['target'] == "refresh")) {
        await _apiCredentialController.refreshToken();
        auth = await _apiCredentialController.loadCredential();
      }
    } catch (e) {
      // await _apiCredentialController.logout();
      handler.reject(DioException(requestOptions: options, message: "凭据刷新异常"));
    }
    var tenantId = await _userController.loadTenant();
    String x_token = "MAC ";
    x_token += 'token="${auth["token"]}",';
    x_token += 'nonce="${auth["nonce"]}",';
    x_token += 'timestamp="${auth["timestamp"]}",';
    x_token += 'mac="${await macGen(options, auth)}"';
    options.headers['X-Authorization'] = x_token;
    options.headers['X-Tenant'] = tenantId == '-1' ? "" : tenantId;
    handler.next(options);
    return;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(err.response?.realUri.toString());
    print(err.response?.data);
    print(err.message);
    SmartDialog.showToast(
        "请求错误: ${err.response?.realUri.toString()}\n(${err.response?.data ?? err.message})");
    // if (err.response?.data['code'] == 10701) {
    //   _apiCredentialController.logout();
    // }
    handler.next(err);
  }
}
