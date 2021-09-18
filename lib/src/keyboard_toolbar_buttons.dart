import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_simple_mobile_keyboard_toolbar/flutter_simple_mobile_keyboard_toolbar.dart';


class DoneButton extends StatelessWidget {

  final OnPressed onPressed;

  const DoneButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
      child: PlatformText('Done'),
      onPressed: () {
        onPressed();
        KeyboardToolbar.of(context).hide();
      },
    );
  }

}