import 'package:flutter_web/material.dart';
import 'file_entry_dialog.dart';
import 'file_service_provider.dart';
import 'file_entry.dart';

class LogSelector extends StatefulWidget {
  final void Function(FileEntry) onChanged;
  LogSelector({this.onChanged});

  @override
  State<StatefulWidget> createState() => _LogSelectorState();
}

class _LogSelectorState extends State<LogSelector> {
  List<FileEntry> _fileEntries;
  String _selected;

  void _onChangedInternal(String newSelected) {
    setState(() {
      _selected = newSelected;
      widget.onChanged(
          _fileEntries.firstWhere((entry) => entry.filename == newSelected));
    });
  }

  @override
  void initState() {
    super.initState();
    FileServiceProvider.fetchFileEntryList().then((fileList) {
      _fileEntries = fileList;
      _onChangedInternal(_fileEntries[0].filename);
    });
  }

  void _refresh() {
    FileServiceProvider.fetchFileEntryList().then((fileList) {
      setState(() {
        _fileEntries = fileList;
      });
    });
  }

  void _addEntry() {
    showDialog(
      context: context,
      builder: (context) => FileEntryDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("添加日志文件"),
            Text("若文件显示名已存在将覆盖原有条目",
                style: Theme.of(context).textTheme.overline),
          ],
        ),
        actionConfirm: "添加",
        onSubmit: (entry) =>
            FileServiceProvider.addFileEntry(entry).then((val) {
          _refresh();
        }),
      ),
    );
  }

  void _editEntry(FileEntry entry) {
    showDialog(
      context: context,
      builder: (context) => FileEntryDialog(
        initialData: entry,
        title: Text("编辑属性"),
        actionConfirm: "保存",
        onSubmit: (entry) =>
            FileServiceProvider.addFileEntry(entry).then((val) {
          _refresh();
        }),
        extension: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      color: Theme.of(context).errorColor,
                      textColor: Colors.white70,
                      elevation: 1,
                      icon: Icon(Icons.delete),
                      label: Text("移除关注"),
                      onPressed: () {
                        FileServiceProvider.removeFileEntry(entry).then((val) {
                          _refresh();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _fileEntries == null
              ? LinearProgressIndicator()
              : DropdownButton(
                  isExpanded: true,
                  items: _fileEntries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.filename,
                          child: GestureDetector(
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(entry.filename),
                                ),
                              ),
                            ]),
                            onLongPress: () => _editEntry(entry),
                          ),
                        ),
                      )
                      .toList()
                        ..add(DropdownMenuItem(
                            value: null,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.add, color: Colors.black45),
                                Text("添加文件",
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            ))),
                  value: _selected,
                  onChanged: (String newSelected) {
                    if (newSelected == null) {
                      _addEntry();
                    } else {
                      _onChangedInternal(newSelected);
                    }
                  },
                ),
        ),
      ],
    );
  }
}
