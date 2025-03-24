import 'package:get/get.dart';
import 'package:flutter/material.dart';

String extToIcons(String ext) {
  switch (ext) {
    case "mp4":
    case "ts":
    case "mov":
    case "flv":
    case "mpg":
    case "wmv":
    case "avi":
      return "assets/icons/files/icon-video.png";

    case "png":
    case "jpg":
    case "jpeg":
    case "svg":
    case "bmp":
    case "gif":
    case "webp":
      return "assets/icons/files/icon-img.png";

    case "rar":
    case "zip":
      return "assets/icons/files/icon-rar.png";

    case "doc":
    case "docx":
      return "assets/icons/files/icon-word.png";

    case "xls":
    case "xlsx":
      return "assets/icons/files/icon-excel.png";

    case "ppt":
    case "pptx":
      return "assets/icons/files/icon-ppt.png";

    case "pdf":
      return "assets/icons/files/icon-pdf.png";

    case "txt":
      return "assets/icons/files/icon-txt.png";

    case "md":
      return "assets/icons/files/icon-md.png";

    default:
      return "assets/icons/files/icon-other.png";
  }
}

String type2Icons(String type) {
  switch (type) {
    case "0":
      return "assets/icons/activity/icon-homework.png";
    case "1":
      return "assets/icons/activity/icon-brainstorm.png";
    case "2":
      return "assets/icons/activity/icon-test.png";
    case "3":
      return "assets/icons/activity/icon-notice.png";
    case "4":
      return "assets/icons/activity/icon-sign-in.png";
    case "5":
      return "assets/icons/activity/icon-courseware.png";
    case "6":
      return "assets/icons/message/icon-system-notice.png";
    case "12":
      return "assets/icons/activity/icon-video.png";
    case "13":
      return "assets/icons/activity/icon-vote.png";
    case "14":
      return "assets/icons/activity/icon-exam-notice.png";
    case "15":
      return "assets/icons/activity/icon-practive.png";
    case "16":
      return "assets/icons/activity/icon-external_links.png";
    case "-1":
      return "assets/icons/message/icon-system-notice.png";
    default:
      return "assets/icons/activity/icon-unknown.png";
  }
}

Map<String, dynamic> recordTypeDesc = {
  "CLASS_COURSE": "班课",
  "GROWTH_COURSE": "成长",
  "PRACTICE_ARENA": "练习"
};
