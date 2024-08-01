import 'package:flutter_learning_go_router/core/common/dialog/alert_dialog_model.dart';

class ErrorDialog extends AlertDialogModel<bool> {
  ErrorDialog({required super.message})
      : super(
          title: 'Error',
          buttons: {
            'cancel': false,
            'ok': true,
          },
        );
}
