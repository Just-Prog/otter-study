import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otter_study/pages/signIn/index.dart';

class SignInClickPage extends StatefulWidget {
  const SignInClickPage({super.key});

  @override
  State<SignInClickPage> createState() => _SignInClickState();
}

class _SignInClickState extends State<SignInClickPage> {
  @override
  Widget build(BuildContext context) {
    final _signinController = Get.put(SignInController());
    return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(_signinController.typeStr.value)),
        ),
        body: SizedBox.expand(
          child: Center(
              child: FutureBuilder(
                  future: _signinController.fetchSigninInfo(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: ElevatedButton(
                              onPressed: _signinController.signActive.value
                                  ? () async => (await _signinController
                                      .sendSigninRequest())
                                  : null,
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty
                                      .fromMap(<WidgetStatesConstraint, Color?>{
                                    WidgetState.disabled: Colors.orange,
                                    WidgetState.any: Colors.blue
                                  }),
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Colors.white)),
                              child: Text(
                                _signinController.signActive.value
                                    ? "签到"
                                    : "签到已结束",
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Obx(
                            () => _signinController.signTime.value != 0
                                ? Text(
                                    "已签到: ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(_signinController.signTime.value))}",
                                    style: const TextStyle(color: Colors.blue),
                                  )
                                : Text(
                                    _signinController.signActive.value == true
                                        ? "可签到"
                                        : "未签到，类别: ${_signinController.getAbsenceType(_signinController.absenceType.value)}",
                                    style: const TextStyle(color: Colors.red)),
                          ),
                          Obx(() => Text(
                              "开始时间: ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(_signinController.startTime.value))}")),
                          Obx(() => Text(
                              "结束时间: ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(_signinController.endTime.value))}")),
                          if (_signinController.endTime.value <= 0) ...[
                            Text("手动截止，由教师端操作")
                          ] else ...[
                            StreamBuilder(
                              stream:
                                  Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                var time = DateTime.fromMillisecondsSinceEpoch(
                                        _signinController.endTime.value)
                                    .difference(DateTime.now());
                                if (_signinController.signTime.value != 0) {
                                  return Text("已签到");
                                } else {
                                  return time.isNegative
                                      ? Text("已超时")
                                      : Text(
                                          "剩余时间: ${time.toString().split('.').first.padLeft(8, "0")}");
                                }
                              },
                            )
                          ]
                        ],
                      );
                    } else {
                      return Text("Loading");
                    }
                  })),
        ));
  }
}
