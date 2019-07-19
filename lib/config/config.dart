class ServerInfo {
  static const String host = "log.quanzhuejia.com",
      fileServicesPath = "/scripts/file_services.php",
      actionQueryKey = "action",
      filenameQueryKey = "filename",
      actionFetchList = "fetch_list",
      actionClear = "clear",
      actionUpdateFileEntry = "update_entry",
      actionRemoveFileEntry = "remove_entry";
}

class OAuthInfo {
  static const String appid = "ww4bc16c5c2e154d95",
      verifyUserPath = "/scripts/verify_user.php",
      redirect_uri = ServerInfo.host + "/log_viewer_main.html",
      accessTokenKey = "access_token",
      codeKey = "code";
  static const int agentid = 1000007;
}
