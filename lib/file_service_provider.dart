import 'dart:convert';
import 'package:http/http.dart';
import 'config/config.dart';
import 'file_entry.dart';

class FileServiceProvider {
  // static final String host = "172.16.11.198";

  static Future<List<FileEntry>> fetchFileEntryList() async {
    try {
      Response response = await get(Uri.https(
          ServerInfo.host,
          ServerInfo.fileServicesPath,
          {ServerInfo.actionQueryKey: ServerInfo.actionFetchList}));
      Map<String, dynamic> responseObject = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          return responseObject.entries
              .map((entry) => FileEntry.fromMapEntry(entry))
              .toList();
          break;
        default:
          assert(responseObject is Map);
          throw Exception(
              "HTTP ERROR ${response.statusCode} ${responseObject["message"]}");
          break;
      }
    } catch (e) {
      // TODO: handle errors
      rethrow;
    }
  }

  /// Returns a future of [filename]'s file content as String,
  /// [filename] is the entry name in the config json file
  static Future<String> getFileContent(String filename) async {
    try {
      Response response = await get(Uri.https(
          ServerInfo.host, ServerInfo.fileServicesPath, {
        ServerInfo.actionQueryKey: "get_content",
        ServerInfo.filenameQueryKey: filename
      }));
      // return response.body;
      switch (response.statusCode) {
        case 200:
          return response.body;
          break;
        default:
          Map responseObject = json.decode(response.body);
          throw Exception(
              "HTTP ERROR ${response.statusCode} ${responseObject["message"]}");
          break;
      }
    } catch (e) {
      // TODO: handle errors
      return e.toString();
    }
  }

  static Future<String> clearFile(String filename) async {
    try {
      Response response =
          await get(Uri.https(ServerInfo.host, ServerInfo.fileServicesPath, {
        ServerInfo.actionQueryKey: ServerInfo.actionClear,
        ServerInfo.filenameQueryKey: filename
      }));
      switch (response.statusCode) {
        case 200:
          return response.body;
          break;
        default:
          Map responseObject = json.decode(response.body);
          throw Exception(
              "HTTP ERROR ${response.statusCode} ${responseObject["message"]}");
          break;
      }
    } catch (e) {
      // TODO: handle errors
      return e.toString();
    }
  }

  static Future<dynamic> updateFileEntry(FileEntry fileEntry) async {
    try {
      Response response = await post(
        Uri.https(ServerInfo.host, ServerInfo.fileServicesPath, {
          ServerInfo.actionQueryKey: ServerInfo.actionUpdateFileEntry,
        }),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fileEntry.toMap()),
      );
      switch (response.statusCode) {
        case 200:
          return 0;
          break;
        default:
          Map responseObject = json.decode(response.body);
          throw Exception(
              "HTTP ERROR ${response.statusCode} ${responseObject["message"]}");
          break;
      }
    } catch (e) {
      // TODO: handle errors
      return e.toString();
    }
  }

  static Future<dynamic> removeFileEntry(FileEntry fileEntry) async {
    try {
      Response response = await post(
        Uri.https(ServerInfo.host, ServerInfo.fileServicesPath, {
          ServerInfo.actionQueryKey: ServerInfo.actionRemoveFileEntry,
        }),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fileEntry.toMap()),
      );
      switch (response.statusCode) {
        case 200:
          return 0;
          break;
        default:
          Map responseObject = json.decode(response.body);
          throw Exception(
              "HTTP ERROR ${response.statusCode} ${responseObject["message"]}");
          break;
      }
    } catch (e) {
      // TODO: handle errors
      return e.toString();
    }
  }
}
