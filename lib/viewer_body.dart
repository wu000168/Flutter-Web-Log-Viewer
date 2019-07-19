import 'package:flutter_web/material.dart';
import 'file_entry.dart';
import 'log_selector.dart';
import 'file_service_provider.dart';
import 'long_text.dart';

class ViewerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewerBodyState();
}

class _ViewerBodyState extends State<ViewerBody> {
  String _fileContent;
  ValueNotifier<FileEntry> _currentFile;
  bool _fileLoading;

  @override
  void initState() {
    super.initState();
    _currentFile = ValueNotifier(null);
    _fileLoading = true;
    _currentFile.addListener(() {
      FileServiceProvider.getFileContent(_currentFile.value.filename)
          .then((content) {
        setState(() => _fileContent = content);
        _fileLoading = false;
      });
      setState(() {
        if (_fileLoading) {
          // Cancel existing loading
        } else {
          _fileLoading = true;
        }
      });
    });
  }

  void _clearFile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("确定清空日志？"),
        content: Text(_currentFile.value.path),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              "删除",
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            onPressed: () {
              FileServiceProvider.clearFile(_currentFile.value.filename)
                  .then((ret) {
                setState(() => _fileContent = ret);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeData.textTheme.body1.color),
        backgroundColor: themeData.scaffoldBackgroundColor,
        title: Text(
          "Log Viewer",
          style: TextStyle(
              fontFamily: "OpenSans", color: themeData.textTheme.body1.color),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LogSelector(
              onChanged: (newFileSelected) =>
                  _currentFile.value = newFileSelected,
            ),
          ),
        ),
      ),
      body: _fileLoading
          ? Center(child: CircularProgressIndicator())
          : LongText(text: _fileContent),
      floatingActionButton: _currentFile?.value?.canDelete ?? false
          ? FloatingActionButton.extended(
              icon: Icon(Icons.delete_forever),
              label: Text("清空"),
              backgroundColor: Theme.of(context).errorColor,
              onPressed: _clearFile,
            )
          : null,
    );
  }
}
