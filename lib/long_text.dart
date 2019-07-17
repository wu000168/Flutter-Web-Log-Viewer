import 'dart:convert';
import 'package:flutter_web/material.dart';

class LongText extends StatefulWidget {
  final String text;
  final List<String> _lines;
  LongText({this.text}) : _lines = LineSplitter().convert(text);

  @override
  _LongTextState createState() => _LongTextState();
}

class _LongTextState extends State<LongText> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    int len = widget._lines.length;
    return Scrollbar(
      child: ListView.builder(
          controller: scrollController,
          itemCount: len,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          reverse: true,
          itemBuilder: (context, index) {
            String text = widget._lines[len - index - 1];
            return index < len
                ? // InkWell(
                // child:
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0, index != len - 1 ? 0 : 16, 0, index != 0 ? 0 : 64),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: text.contains(RegExp(
                                  "Error|Exception|Stderr|Failed|Fatal",
                                  caseSensitive: false))
                              ? Theme.of(context).errorColor
                              : null),
                    ),
                  ) // ,
                // onLongPress: () {
                //   Clipboard.setData(ClipboardData(text: text));
                //   Scaffold.of(context).removeCurrentSnackBar();
                //   Scaffold.of(context).showSnackBar(SnackBar(
                //       content: Text("Line# ${len - index} copied to clipboard")));
                // }) // Only works on mobile
                : null;
          }),
    );
  }
}
