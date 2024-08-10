import 'package:flutter/material.dart';

class GlobalWidgetDialog {
  GlobalWidgetDialog._sharedInstance();
  static final GlobalWidgetDialog _shared =
      GlobalWidgetDialog._sharedInstance();
  factory GlobalWidgetDialog.instance() => _shared;

  OverlayEntry? _overlayEntry;
  ValueNotifier<Widget?>? _childNotifier;

  bool get isShowing => _overlayEntry != null;

  void show({
    required BuildContext context,
    required Widget child,
  }) {
    if (isShowing) {
      update(child);
      return;
    }

    _childNotifier = ValueNotifier<Widget?>(child);

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _PersistentDialogOverlay(
        child: ValueListenableBuilder<Widget?>(
          valueListenable: _childNotifier!,
          builder: (_, child, __) => child ?? const SizedBox.shrink(),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void update(Widget child) {
    _childNotifier?.value = child;
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {}
    if (_childNotifier != null) {
      _childNotifier!.dispose();
      _childNotifier = null;
    } else {}
  }

  void dispose() {
    hide();
  }
}

class _PersistentDialogOverlay extends StatelessWidget {
  final Widget child;

  const _PersistentDialogOverlay({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
    );
  }
}
