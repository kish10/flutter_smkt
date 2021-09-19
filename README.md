# Simple mobile toolbar for Flutter applications.

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Simple mobile flutter keyboard toolbar for flutter (fsmkt).

Other awesome & popular flutter keyboard packages:
- [keyboard_actions](https://pub.dev/packages/keyboard_actions)
- [math_keyboard](https://pub.dev/packages/math_keyboard)
- Honorable mention: [Medium: Stop fighting the native iOS keypad and build a custom number pad for Flutter. -by Casey Henson](https://medium.com/@caseyahenson/stop-fighting-the-native-ios-keypad-and-build-a-custom-number-pad-for-flutter-473404d1bbd6)

Unlike [math_keyboard](https://pub.dev/packages/math_keyboard) or Casey Henson's implementation, fsmfkt like [keyboard_actions](https://pub.dev/packages/keyboard_actions), simply puts a toolbar on top of the system keyboard.

If you'd like to replace the whole keyboard with your own keyboard please reference the other packages.

----
The name 'flutter_simple_mobile_keyboard_toolbar' was chosen as a commitment device, not just for the developers, but for the broader open source community.


So if you can make it simpler or better or greater, please let us know! Pull requests are welcome.

<!-- ## Features -->
<!-- TODO: List what your package can do. Maybe include images, gifs, or videos. -->


## Getting started

```yaml
flutter_simple_mobile_keyboard_toolbar:
    git: https://github.com/kish10/flutter_simple_mobile_keyboard_toolbar
```

## Usage

### Set up

Wrap the main app widget (or the widget that needs the toolbar) with the `KeyboardToolbar` widget. However `KeyboaardToolbar` relies on `MediaQuery` so need to make sure a global platform widget such as `MaterialApp`, `CupertinoApp`, `PlatformApp` is an ancestor of `KeyboardToolbar`.

```dart
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_simple_mobile_keyboard_toolbar/fsmkt.dart';

void main() {
  
   runApp(
     PlatformApp(
        home: KeyboardToolbar(
          child: MainApp()
        ),
     )
   );
}
```

### Example using `DoneButton`

Then for example can use the toolbar with a `DoneButton` (from fsmkt) for a multiline `TextField` widget where the system keyboard would only have a 'Newline Button' but not a 'Done' button, such as:

```dart
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_simple_mobile_keyboard_toolbar/fsmkt.dart';
import 'package:flutter/widgets.dart';

typedef EditOnChangedCallback = void Function(String text);

class MyApp extends StafulWidget {
  
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  bool editMode = false;
  
  String text = 'Hi';
  String? editedText;

  
  void editOnChangedCallback(String text) => setState(() => editedText = text);
  void onPressedCallback() {
    setState(() {
      text = editText;
      editMode = false;
    });
  }
   
  @override
  Widget build(BuildContext context) {
    if (editMode) 
      return _TextInput(
        initialText: text,
        editOnChangedCallback: editOnChangedCallback,
        onPress: onPressedCallback
      );
    
    return Row(
       children: [
         PlatformText(text),
          PlatformButton(
             child: PlatformText('EDIT'),
            onPressed: () => setState(() => editMode = true)
          )
       ]
    );
  }
}


class _TextInput extends StatefulWidget {
  final String initialText;
  final EditOnChangedCallback editOnChangedCallback;
  final OnToolbarButtonPressed onPress; // OnToolbarButtonPressed typedef provided by fsmkt
  
  _TextInput({
     required this.initialText,
     required this.EditOnChangedCallback,
     required this.onPress
  });

  @override
  State<StatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {

   late TextEditingController _controller;
  
   final String initialText;
   final EditOnChangedCallback editOnChangedCallback;
   final OnToolbarButtonPressed onPress; // OnToolbarButtonPressed typedef provided by fsmkt

   _TextInputState({
      required this.initialText,
      required this.EditOnChangedCallback,
      required this.onPress
   });
  
   // Need initialize a controller for interaction & the toolbar
   @override
   void initState() {
      super.initState();

      // initialize the TextEditingController
      _controller = TextEditingController(text: initialText);
      _controller.addListener(() => editOnChangedCallback(_controller.text));

      // Add a frame callback to show toolbar
      WidgetsBinding.instance!
        .addPostFrameCallback(
          (_) {
           KeyboardToolbar.of(context).makeVisible(
             toolbarButtons: [
                DoneButton(onPressed)
             ]
           );
        }
      );
   }

   @override
   void dispose() {
      _controller.dispose();
      super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return PlatformTextFormField(
        autofocus: true,
        controller: _controller,
        onFieldSubmitted: ,
        maxLines: null,
        validator: validator,
        inputFormatters: inputFormatters,
     );
   }
}
```

The keyboard toolbar gets built by this step, and is hidden right after `onPressed` is called in the `DoneButton` widget, with the call `KeyboardToolbar.of(context).hide()`.

```dart
// Add a frame callback to show toolbar
WidgetsBinding.instance!
  .addPostFrameCallback(
    (_) {
     KeyboardToolbar.of(context).makeVisible(
       toolbarButtons: [
          DoneButton(onPressed)
       ]
     );
  }
);
```

### Custom toolbar buttons

By extending the `onPress` callback you can use a custom `DoneButton` too.

```dart
// Add a frame callback to show toolbar
WidgetsBinding.instance!
  .addPostFrameCallback(
    (_) {
      KeyboardToolbar.of(context).makeVisible(
        toolbarButtons: [
          PlatformTextButton(
            child: PlatformText('Done'),
            onPressed: () {
               onPressed();
               KeyboardToolbar.of(context).hide();
            }
          )   
        ]
      );
    }
  );
```

### Custom toolbar view

Similarly you can extend `KeyboardToolbarView` to customize the whole toolbar view:

```dart
void main() {
   runApp(
     PlatformApp(
        home: KeyboardToolbar(
          child: MainApp(),
          toolbarViewBuilder: () => CustomToolbarView()
        ),
     )
   );
}

class CustomToolbarView extends KeyboardToolbarView {

   final List<Widget> toolbarButtons;

   const CustomToolbarView({required this.toolbarButtons}):
     super(toolbarButtons: toolbarButtons);

   @override
   Widget build(BuildContext context) {
      return Container(
         color: Colors.white,
         child: Row(
            children: [PlatformText('ʕ·͡ᴥ·ʔ'), ...toolbarButtons],
            mainAxisAlignment: MainAxisAlignment.end,
         ),
      );
   }
}
```

Where CustomToolbarView extends `KeyboardToolbarView`

### Troubleshooting

#### `inactive InputConnection`

Currently the following lines are printed when the toolbar is activated. Don't panic it's not an error on your end, the messages seem to be generated for brief time period when the toolbar is being built.

```
W/IInputConnectionWrapper(32148): beginBatchEdit on inactive InputConnection
W/IInputConnectionWrapper(32148): getTextBeforeCursor on inactive InputConnection
W/IInputConnectionWrapper(32148): getTextAfterCursor on inactive InputConnection
W/IInputConnectionWrapper(32148): getSelectedText on inactive InputConnection
W/IInputConnectionWrapper(32148): endBatchEdit on inactive InputConnection
W/IInputConnectionWrapper(32148): beginBatchEdit on inactive InputConnection
W/IInputConnectionWrapper(32148): endBatchEdit on inactive InputConnection
W/IInputConnectionWrapper(32148): beginBatchEdit on inactive InputConnection
W/IInputConnectionWrapper(32148): endBatchEdit on inactive InputConnection
```

Please let us know if you can fix this.


## Additional information

The name 'flutter_simple_mobile_keyboard_toolbar' was chosen as a commitment device, not just for the developers, but for the broader open source community. 


So if you can make it simpler or better or greater, please let us know! Pull requests are welcome.
