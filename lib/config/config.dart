class ServerInfo {
  static const String host = "172.16.11.198",
      fileServicesPath = "/scripts/file_services.php",
      actionQueryKey = "action",
      filenameQueryKey = "filename",
      actionFetchList = "fetch_list",
      actionClear = "clear",
      actionAddFileEntry = "add_file",
      actionRemoveFileEntry = "remove_entry";
}

class OAuthInfo {
  static const String appid = "ww558b222409b5625f",
      verifyUserPath = "/scripts/verify_user.php",
      redirect_uri = ServerInfo.host + "/log_viewer_main.html",
      accessTokenKey = "access_token",
      codeKey = "code";
  static const int agentid = 1000002;
}
