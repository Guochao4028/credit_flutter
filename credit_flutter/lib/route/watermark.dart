import 'package:flutter/material.dart';

class Watermark extends StatelessWidget {
  final int rowCount;
  final int columnCount;
  final String text;

  const Watermark(
      {Key? key,
      required this.rowCount,
      required this.columnCount,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: createColumnWidgets(),
      ),
    );
  }

  List<Widget> createRowWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < rowCount; i++) {
      final widget = Expanded(
        child: Center(
          child: Transform.rotate(
            angle: 0.5,
            child: Text(
              text,
              style: const TextStyle(
                  color: Color(0x0F000000),
                  fontSize: 18,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      );
      list.add(widget);
    }
    return list;
  }

  List<Widget> createColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < columnCount; i++) {
      final widget = Expanded(
          child: Row(
        children: createRowWidgets(),
      ));
      list.add(widget);
    }
    return list;
  }
}
