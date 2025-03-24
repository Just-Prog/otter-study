import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otter_study/pages/signIn/index.dart';
import 'package:pattern_lock/pattern_lock.dart';

class SignInGesturePage extends StatefulWidget {
  const SignInGesturePage({super.key});

  @override
  State<SignInGesturePage> createState() => _SignInGestureState();
}

class _SignInGestureState extends State<SignInGesturePage> {
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
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: PatternLock(
                              selectedColor: Colors.orange,
                              showInput: true,
                              dimension: 3,
                              pointRadius: 20,
                              onInputComplete: (List<int> gesture) async {
                                await _signinController.sendSigninRequest(
                                    gesture: gesture
                                        .map((_) => _ + 1)
                                        .toList()
                                        .join());
                              }),
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
                            stream: Stream.periodic(const Duration(seconds: 1)),
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
      ),
    );
  }
}
