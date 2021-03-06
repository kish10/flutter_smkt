import 'package:flutter/widgets.dart';

import 'package:flutter_smkt/flutter_smkt.dart';

// for KeyboardToolbar
typedef ToolbarViewBuilder = KeyboardToolbarView Function(
    {required List<Widget> toolbarButtons});

// for toolbar buttons
typedef OnToolbarButtonPressed = void Function();
