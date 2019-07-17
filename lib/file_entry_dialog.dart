import 'package:flutter_web/material.dart';
import 'file_entry.dart';

class FileEntryDialog extends StatefulWidget {
  final void Function(FileEntry) onSubmit;
  final String actionConfirm;
  final Widget title, extension;
  final FileEntry initialData;
  FileEntryDialog(
      {this.onSubmit,
      this.actionConfirm,
      this.title,
      this.extension,
      this.initialData});

  @override
  State<StatefulWidget> createState() => FileEntryDialogState();
}

class FileEntryDialogState extends State<FileEntryDialog> {
  bool _canDelete = false, _bakOnDelete = true;
  FocusNode _nameNode, _pathNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController, _pathController;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _canDelete = widget.initialData.canDelete;
      _bakOnDelete = widget.initialData.bakOnDelete;
    }
    _nameController =
        TextEditingController(text: widget?.initialData?.filename);
    _nameNode = FocusNode(onKey: (node, keyEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.tab) {
        _pathNode.requestFocus();
        return true;
      }
      return false;
    });
    _pathController = TextEditingController(text: widget?.initialData?.path);
    _pathNode = FocusNode(onKey: (node, keyEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.tab) {
        _nameNode.requestFocus();
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              focusNode: _nameNode,
              decoration: InputDecoration(labelText: "显示名称"),
              validator: (filename) => filename.isEmpty ? "显示名不可为空" : null,
            ),
            TextFormField(
              controller: _pathController,
              focusNode: _pathNode,
              decoration: InputDecoration(labelText: "文件路径"),
              validator: (path) => path.isEmpty ? "路径不可为空" : null,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            CheckboxListTile(
              title: Text("允许删除"),
              value: _canDelete,
              onChanged: (val) => setState(() => _canDelete = val),
            ),
            CheckboxListTile(
              title: Text("保留一次记录"),
              value: _bakOnDelete,
              onChanged: (val) => setState(() => _bakOnDelete = val),
            ),
            if (widget.extension != null) widget.extension
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(widget.actionConfirm ?? "确认"),
          onPressed: () {
            FileEntry emit = FileEntry(
                filename: _nameController.text,
                path: _pathController.text,
                canDelete: _canDelete,
                bakOnDelete: _bakOnDelete);
            if (_formKey.currentState.validate()) {
              widget.onSubmit(emit);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
