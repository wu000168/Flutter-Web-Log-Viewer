import 'package:flutter_web/material.dart';

@immutable
class FileEntry {
  final String filename, path;
  final bool canDelete, bakOnDelete;
  FileEntry(
      {@required this.filename,
      @required this.path,
      this.canDelete = false,
      this.bakOnDelete = true});

  FileEntry.fromMapEntry(MapEntry<String, dynamic> mapEntry)
      : filename = mapEntry.key,
        path = mapEntry.value["path"],
        canDelete = mapEntry.value["can_delete"],
        bakOnDelete = mapEntry.value["bak_on_delete"];

  Map<String, Map<String, dynamic>> toMap() => {
        filename: {
          "path": path,
          "can_delete": canDelete,
          "bak_on_delete": bakOnDelete
        }
      };
}
