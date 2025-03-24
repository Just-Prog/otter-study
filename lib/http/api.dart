class ApiBase {
  static const String baseUrl = "https://api.goktech.cn";
  static const String baseOriginUrl = "https://edu.goktech.cn";
}

class Api {
  //登录部分
  static const String loginBySMSCodeFetch =
      "/uc/teaching/v1/auto-login/acquire-sms";
  static const String loginBySMSCode = "/uc/teaching/v1/auto-login";
  static const String loginByPasswordInit = "/uc/v1/users/pwd-login/init";
  static const String loginByPassword = "/uc/v2/users/pwd-login";
  static const String loginFetchTokenByCodeUid = "/uc/v1/users/token";
  static const String refreshToken = "/uc/v1/users/refresh-token";

  //租户管理部分
  static const String getTenantList = "/uc/v1/users/tenants";
  static const String switchTenant = "/uc/v1/users/switch-tenant/";

  //用户信息
  static const String fetchUserInfo = "/uc/v1/users/info";

  //首页信息
  static const String homePageCarousels = "/tac/home-page/mngCarousels";
  static const String homePageNewsUrl = "/tac/home-page/news";

  //消息
  static const String fetchUnreadMsgsCount = "/tac/teaching-msg/v1/unread";
  static const String fetchMsgsList = "/tac/teaching-msg/v1/tab";
  static const String fetchMsgs = "/tac/teaching-msg/v1/category/";

  //签到功能
  //需要 APP 头
  static const String fetchSigninInfoApp = "/tac/app/signs/sign-info/";
  static const String submitSigninRequestApp = "/tac/apps/signs/sign/";

  //课件预览功能
  //需要 APP 头
  static const String fetchActivitiesDataInfo =
      "/tac/apps/activities/data-info";
  static const String fetchVideoAddress = "/tc/vod/videoAddress/";
  static const String fetchDocPreview = "/tc/doc/preview/";

  //学习-动态
  static const String fetchCourseMediumActivities =
      "/tac/home-page/course-medium";
  static const String fetchRecentContent = "/tac/home-page/recent-content";
  static const String fetchActivityActive = "/tac/home-page/activity/started";
  static const String fetchActivityInactive = "/tac/home-page/activity/over";

  //课程列表 网页端接口，弃用
  static const String fetchClassList = "/tac/class/v1/stu/class";
  static const String fetchArchivedClassList = "/tac/class/getArchivesClass";

  //课程列表 UniApp端接口
  static const String fetchClassListApp = "/tac/apps/class/my-class";

  //课程相关 网页端接口
  static const String fetchClassInfo = "/tac/class/classInfo";
  static const String fetchClassChapterDetails =
      "/tac/teachActivity/v1/chapterDetails";
  static const String fetchClassActivitiesList =
      "/tac/class/v1/stu/activities/";

  //课程相关 UniApp端接口
  static const String fetchClassChapterDetailsApp =
      "/tac/apps/activities/chapterDetails";
  static const String fetchClassActivitiesListApp = "/tac/apps/activities";

  //作业详细信息 UniApp端
  static const String fetchHomeworkDetailApp =
      "/tac/apps/homeworkStudent/getHomeWorkDet";
}
