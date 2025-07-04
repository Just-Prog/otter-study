import 'dart:developer';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/index.dart';
import 'package:otter_study/utils/ffmpeg.dart';

class CoursewareController extends GetxController {
  RxString chapterId = "0".obs;
  RxString dataId = "0".obs;

  RxString name = "".obs;
  RxString link = "".obs;
  RxString docId = "".obs;
  RxInt size = 0.obs;
  RxString vidKey = "".obs;
  RxString vidAddr = "".obs;
  RxString ext = "".obs;

  fetchCoursewareInfo() async {
    var resp = await Request().get(Api.fetchActivitiesDataInfo, params: {
      "chapterId": chapterId.value,
      "dataId": dataId.value,
    });
    name.value = resp.data['name'];
    link.value = resp.data['imageUrl'];
    vidKey.value = resp.data['videoKey'];
    docId.value = resp.data['docId'];
    ext.value = resp.data['typeStr'];
    size.value = int.parse(resp.data['size']);
    if (vidKey.value != "") {
      var resp_v = await Request().get(Api.fetchVideoAddress + vidKey.value);
      vidAddr.value = resp_v.data['address'];
      return vidAddr.value;
    }
    return link.value;
  }

  fetchTcPreview() async {
    var resp = await Request().get(Api.fetchDocPreview + docId.value);
    return resp.data['pathKey'];
  }

  download() async {
    if (link.value.isEmpty) {
      if (vidAddr.value.isNotEmpty) {
        await m3u8VideoExport(vidAddr.value, filename: name.value);
        return;
      } else {
        SmartDialog.showToast("暂未支持");
        return;
      }
    }
    await Request().download(link.value, name.value);
  }

  @override
  void onInit() async {
    chapterId.value = Get.parameters['chapterId'] ?? "0";
    dataId.value = Get.parameters['dataId'] ?? "0";
    super.onInit();
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
