import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter_smkt/flutter_smkt.dart';

class KeyboardToolbar extends StatefulWidget {
  final Widget child;
  final ToolbarViewBuilder? toolbarViewBuilder;

  const KeyboardToolbar({required this.child, this.toolbarViewBuilder});

  static _KeyboardToolbarState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<_InheritedKeyboardToolbar>()!
        .state);
  }

  @override
  State<StatefulWidget> createState() {
    return _KeyboardToolbarState(
        child: child,
        toolbarViewBuilder: (toolbarViewBuilder ??
            ({required List<Widget> toolbarButtons}) =>
                _ToolbarView(toolbarButtons: toolbarButtons)));
  }
}

class _KeyboardToolbarState extends State<KeyboardToolbar> {
  final GlobalKey toolbarKey = GlobalKey();
  final Widget child;
  final ToolbarViewBuilder toolbarViewBuilder;
  List<Widget> toolbarButtons = [];

  bool visible = false;

  final StreamController<double> _toolbarHeightStreamController =
      (StreamController<double>.broadcast());
  late final Stream<double> toolbarHeight;

  _KeyboardToolbarState(
      {required this.child, required this.toolbarViewBuilder}) {
    toolbarHeight = _toolbarHeightStreamController.stream;
  }

  @override
  dispose() {
    _toolbarHeightStreamController.close();
    super.dispose();
  }

  _calculateToolbarHeight() {
    return toolbarKey.currentContext!.size!.height;
  }

  void makeVisible({required List<Widget> toolbarButtons}) {
    setState(() {
      visible = true;
      this.toolbarButtons = toolbarButtons;
    });
  }

  void hide() {
    setState(() {
      visible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget toolbar = Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      child: VisibilityDetector(
        key: Key('KeyboardToolbar - VisibilityDetector'),
        onVisibilityChanged: (VisibilityInfo visibilityInfo) {
          final height = _calculateToolbarHeight();
          _toolbarHeightStreamController.add(height);
        },
        child: Visibility(
          key: toolbarKey,
          child: toolbarViewBuilder(toolbarButtons: toolbarButtons),
          visible: visible,
        ),
      ),
    );

    return _InheritedKeyboardToolbar(
        child: Stack(
          children: [child, toolbar],
        ),
        state: this);
  }
}

class _InheritedKeyboardToolbar extends InheritedWidget {
  final _KeyboardToolbarState state;

  _InheritedKeyboardToolbar({required Widget child, required this.state})
      : super(child: child);

  @override
  bool updateShouldNotify(_InheritedKeyboardToolbar oldWidget) {
    return state != oldWidget.state;
  }
}

// Toolbar views

abstract class KeyboardToolbarView extends StatelessWidget {
  List<Widget> get toolbarButtons;

  const KeyboardToolbarView({required List<Widget> toolbarButtons});
}

class _ToolbarView extends KeyboardToolbarView {
  final List<Widget> toolbarButtons;

  const _ToolbarView({required this.toolbarButtons})
      : super(toolbarButtons: toolbarButtons);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: toolbarButtons,
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }
}
