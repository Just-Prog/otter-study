import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';
import 'package:otter_study/utils/permission/geolocation.dart';

class SignInController extends GetxController {
  RxString signId = "".obs;
  RxString typeStr = "".obs;
  String gesture = "";
  String classId = "";
  RxBool signActive = false.obs;
  RxString absenceType = "".obs;
  RxInt startTime = 0.obs;
  RxInt endTime = 0.obs;
  RxInt signTime = 0.obs;

  double longitude = 0.0;
  double latitude = 0.0;

  fetchSigninInfo() async {
    var resp = await Request().get(Api.fetchSigninInfoApp + signId.value,
        options: Options(extra: {'version': "android"}));
    var data = resp.data;
    gesture = data['gesture'];
    typeStr.value = data['typeStr'];
    classId = data['classId'];
    startTime.value = int.parse(data['startTime']);
    endTime.value = int.parse(data['endTime']);
    signActive.value = data['signActive'] == 1 ? true : false;
    absenceType.value = data['absenceType'];
    signTime.value = int.parse(data['signTime']);

    var geo = await determinePosition();
    longitude = geo.longitude;
    latitude = geo.latitude;
    return data;
  }

  sendSigninRequest({String gesture = ""}) async {
    var data = {
      "longitude": longitude,
      "latitude": latitude,
      "classId": classId,
      "signPlace": "$longitude,$latitude",
      "gesture": gesture
    };
    var resp = await Request().post(
        Api.submitSigninRequestApp + signId.value, data,
        options: Options(extra: {'version': "android"}));
    SmartDialog.showToast("${resp.data['message']}");
    Get.back();
  }

  getAbsenceType(String type) {
    switch (type) {
      case "EL":
        return "早退";
      case "LT":
        return "迟到";
      case "IL":
        return "病假";
      case "PL":
        return "事假";
      case "AB":
        return "缺勤";
      default:
        return "缺勤";
    }
  }

  @override
  void onInit() async {
    signId.value = Get.parameters['signId'] ?? "-1";
    // await fetchSigninInfo();
    super.onInit();
  }
}
