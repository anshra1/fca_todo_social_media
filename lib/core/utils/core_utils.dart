import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CoreUtils {
  CoreUtils._();
  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    DateTime? selectedDate;

    await showDialog<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 320,
            width: context.width * .9,
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              maxDate: DateTime.now().add(const Duration(days: 365 * 5)),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  selectedDate = args.value as DateTime;
                }
              },
              monthViewSettings: const DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              selectionColor: Colors.blue.shade700,
              todayHighlightColor: context.theme.colorScheme.secondary,
              selectionTextStyle: const TextStyle(color: Colors.white),
              showActionButtons: true,
              onSubmit: (Object? value) {
                Navigator.of(context).pop();
              },
              onCancel: () {
                selectedDate = null;
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    return selectedDate;
  }


 
}
