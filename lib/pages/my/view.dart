import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

import 'package:otter_study/pages/login/controller/index.dart';

import 'package:otter_study/utils/geolocation.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  String info = "unknown";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((_) {
      info = "${_.version} (${_.buildNumber})";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _credentialController = Get.put(CredentialController());
    final _userController = Get.put(UserController());
    return Scaffold(
      body: ListView(
        children: [
          Obx(
            () {
              return InkWell(
                onTap: () {
                  if (!_credentialController.isLoggedIn.value) {
                    Get.toNamed("/user/login");
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    spacing: 15,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/avatar-default.jpg"),
                          foregroundImage: _credentialController
                                  .isLoggedIn.value
                              ? NetworkImage(_userController.userAvatar.value)
                              : null,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _credentialController.isLoggedIn.value
                                ? _userController.userName.value
                                : "请登录",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _credentialController.isLoggedIn.value
                                ? _userController.userCollegeDesc.value
                                : "请登录",
                            style: const TextStyle(
                              fontSize: 13.5,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text(
              _credentialController.isLoggedIn.value ? "切换" : "登录",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text("河狸学途 学生账号"),
            onTap: () {
              Get.toNamed("/user/login");
            },
          ),
          if (_credentialController.isLoggedIn.value) ...[
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text(
                "退出登录",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _credentialController.logout().then((_) {
                  Get.offAllNamed("/");
                });
              },
            ),
          ],
          ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text(
              "关于 OtterStudy",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(info),
            onTap: () async {
              Get.snackbar("DEBUG", "${await PackageInfo.fromPlatform()}",
                  backgroundColor: Colors.white);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.gps_fixed),
          //   title: Text("DEBUG GEOLOCATION"),
          //   onTap: () async {
          //     Get.snackbar(
          //         "GeoLocation", "${(await determinePosition()).toString()}");
          //   },
          // )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
