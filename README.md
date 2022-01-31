# Simple mobile keyboard toolbar for Flutter applications.

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

Simple mobile keyboard toolbar for flutter.

Other awesome & popular flutter keyboard packages:
- [keyboard_actions](https://pub.dev/packages/keyboard_actions)
- [math_keyboard](https://pub.dev/packages/math_keyboard)
- Honorable mention: [Medium: Stop fighting the native iOS keypad and build a custom number pad for Flutter. -by Casey Henson](https://medium.com/@caseyahenson/stop-fighting-the-native-ios-keypad-and-build-a-custom-number-pad-for-flutter-473404d1bbd6)

Unlike [math_keyboard](https://pub.dev/packages/math_keyboard) or Casey Henson's implementation, fsmfkt like [keyboard_actions](https://pub.dev/packages/keyboard_actions), simply puts a toolbar on top of the system keyboard.

If you would like to replace the system keyboard with your own custom keyboard please reference the other packages.

----
The name `flutter simple mobile keyboard toolbar` was chosen as a commitment device, not just for the developers, but for the broader open source community.


So if you can make it simpler or better or greater, please let us know! Pull requests are welcome.

----

## Getting started

```yaml
flutter_simple_mobile_keyboard_toolbar:
    git: https://github.com/kish10/flutter_simple_mobile_keyboard_toolbar
```

## Usage

### Set up

Wrap the main app widget (or the widget that needs the toolbar) with the `KeyboardToolbar` widget. However `KeyboardToolbar` relies on `MediaQuery` so need to make sure a global platform widget such as `MaterialApp`, `CupertinoApp`, or `PlatformApp` is an ancestor of `KeyboardToolbar`.

```dart
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smkt/flutter_smkt.dart';

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

Reference the [Troubleshooting](#troubleshooting) section for additional debugging related information. 

### Example using `DoneButton`

Then for example can use the toolbar with a `DoneButton` (from flutter_smkt) for a multiline `TextField` widget where the system keyboard would only have a 'Newline Button' but not a 'Done' button, such as:

```dart
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smkt/flutter_smkt.dart';
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

### <a='troubleshooting'>Troubleshooting</a>

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

#### `TextField`'s view is hidden below the toolbar's view.

##### `TextField` actually hidden below the virtual keyboard not the toolbar.

First if the `TextField` is hidden below the virtual keyboard without the toolbar.

Then try:
- Wrapping the whole view in a `Scaffold` with `resizeToAvoidBottomInset` property.
- Adding a `ListView` allowing the user to scroll up.

Reference:
- [Flutter Docs - resizeToAvoidBottomInset](https://api.flutter.dev/flutter/material/Scaffold/resizeToAvoidBottomInset.html)
- [StackOverflow - Answer to "Keyboard slides up and covers the TextField in Flutter"](https://stackoverflow.com/a/60600231)

##### `TextField actually hidden by the toolbar's view.

The KeyboardToolbar class exposes the `toolbarHeight` as a stream as `KeyboardToolbar.of(context).toolbarHeight`.

The `toolbarHeight` stream can then be used with a `StreamBuilder` (& `ListView` or `ListView.builder`) to create additional padding, allowing the user to scroll and access the `TextField`.

For example can wrap the `originalView` with the `TextField` as:

```Dart
Widget belowToolbarPadding = StreamBuilder(
  stream: KeyboardToolbar.of(context).toolbarHeight,
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) return Container();  
    return Padding(padding: EdgeInsets.only(bottom: snapshot.data));
  }
);

Widget wrappedOriginalView = ListView(
  children: const <Widget>[
    originalView,
    belowToolbarPadding
  ]
);
```

Note: It is very necessary to provide the `Padding` separately to avoid rebuilding the `originalView` on `toolbarHeight` change.

Let us know if there is a better solution.

## Additional information

The name 'flutter_simple_mobile_keyboard_toolbar' was chosen as a commitment device, not just for the developers, but for the broader open source community. 


So if you can make it simpler or better or greater, please let us know! Pull requests are welcome.
