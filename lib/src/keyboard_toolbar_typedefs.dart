import 'package:flutter/widgets.dart';

import 'package:flutter_simple_mobile_keyboard_toolbar/flutter_simple_mobile_keyboard_toolbar.dart';

// for KeyboardToolbar
typedef ToolbarViewBuilder = KeyboardToolbarView Function({required List<Widget> toolbarButtons});

// for toolbar buttons
typedef OnPressed = void Function();