import 'package:flutter/material.dart';

// Kelas ini berfungsi untuk "mematikan" atau menyembunyikan scrollbar
// yang muncul secara otomatis di beberapa platform seperti web/desktop.
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
