import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_simple_mobile_keyboard_toolbar/flutter_simple_mobile_keyboard_toolbar.dart';


class KeyboardToolbar extends StatefulWidget {

  final Widget child;
  final ToolbarViewBuilder? toolbarViewBuilder;

  const KeyboardToolbar({
    required this.child,
    required this.toolbarViewBuilder
  });

  static KeyboardToolbarState of(BuildContext context) {
    return (
        context
            .dependOnInheritedWidgetOfExactType<_InheritedKeyboardToolbar>()!
            .state
    );
  }

  @override
  State<StatefulWidget> createState() {
    return KeyboardToolbarState(
      child: child,
      toolbarViewBuilder: (
        toolbarViewBuilder ??
        ({required List<Widget> toolbarButtons})
          => _ToolbarView(toolbarButtons: toolbarButtons)
      )
    );
  }
}

class KeyboardToolbarState extends State<KeyboardToolbar> {
  final Widget child;
  final ToolbarViewBuilder toolbarViewBuilder;
  List<Widget> toolbarButtons = [];

  bool visible = false;

  KeyboardToolbarState({
    required this.child,
    required this.toolbarViewBuilder
  });

  void makeVisible({toolbarButtons}) {
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
    return _InheritedKeyboardToolbar(
        child: Stack(
          children: [
            child,
            Visibility(
              child: Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: toolbarViewBuilder(toolbarButtons: toolbarButtons),
              ),
              visible: visible,
            )
          ],
        ),
        state: this
    );
  }
}

class _InheritedKeyboardToolbar extends InheritedWidget {

  final KeyboardToolbarState state;

  const _InheritedKeyboardToolbar({
    required Widget child,
    required this.state
  }):
        super(child: child);

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

  const _ToolbarView({required this.toolbarButtons}):
    super(toolbarButtons: toolbarButtons);

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

