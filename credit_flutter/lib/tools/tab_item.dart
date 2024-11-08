import 'package:flutter/material.dart';

class TabItem {
  late String tabTitle;
  late Widget childWidget;

  @override
  String toString() {
    return 'TabItem{tabTitle: $tabTitle, childWidget: $childWidget}';
  }
}
