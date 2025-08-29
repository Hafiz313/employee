import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../networking/api_provider.dart';
import '../../../networking/api_ref.dart';
import '../../../utils/DateForm.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/helper.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import '../../home/home_view.dart';

class OverTimeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dateTxtField = TextEditingController();
  final startTimeTxtField = TextEditingController();
  final endTimeTxtField = TextEditingController();
  final totalOverTimeTxtField = TextEditingController();
  final reasonTxtField = TextEditingController();
  RxString selectedDate = '${DateTime.now()}'.obs;

  RxString? selectedTime;

  // Helper method to convert AM/PM format to 24-hour format
  String _convertTo24HourFormat(String timeString) {
    if (timeString.contains('AM') || timeString.contains('PM')) {
      String timeOnly = timeString.replaceAll(' AM', '').replaceAll(' PM', '');
      List<String> timeParts = timeOnly.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 24-hour format
      if (timeString.contains('PM') && hour != 12) {
        hour += 12;
      } else if (timeString.contains('AM') && hour == 12) {
        hour = 0;
      }

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    }
    return timeString; // Return as is if already in 24-hour format
  }

  // Method to calculate total hours between start and end time
  void calculateTotalHours() {
    if (startTimeTxtField.text.isNotEmpty && endTimeTxtField.text.isNotEmpty) {
      try {
        // Parse start time (handle AM/PM format)
        int startHour, startMinute;
        if (startTimeTxtField.text.contains('AM') ||
            startTimeTxtField.text.contains('PM')) {
          String timeOnly = startTimeTxtField.text
              .replaceAll(' AM', '')
              .replaceAll(' PM', '');
          List<String> startParts = timeOnly.split(':');
          startHour = int.parse(startParts[0]);
          startMinute = int.parse(startParts[1]);

          // Convert to 24-hour format
          if (startTimeTxtField.text.contains('PM') && startHour != 12) {
            startHour += 12;
          } else if (startTimeTxtField.text.contains('AM') && startHour == 12) {
            startHour = 0;
          }
        } else {
          // Parse 24-hour format
          List<String> startParts = startTimeTxtField.text.split(':');
          startHour = int.parse(startParts[0]);
          startMinute = int.parse(startParts[1]);
        }

        // Parse end time (handle AM/PM format)
        int endHour, endMinute;
        if (endTimeTxtField.text.contains('AM') ||
            endTimeTxtField.text.contains('PM')) {
          String timeOnly =
              endTimeTxtField.text.replaceAll(' AM', '').replaceAll(' PM', '');
          List<String> endParts = timeOnly.split(':');
          endHour = int.parse(endParts[0]);
          endMinute = int.parse(endParts[1]);

          // Convert to 24-hour format
          if (endTimeTxtField.text.contains('PM') && endHour != 12) {
            endHour += 12;
          } else if (endTimeTxtField.text.contains('AM') && endHour == 12) {
            endHour = 0;
          }
        } else {
          // Parse 24-hour format
          List<String> endParts = endTimeTxtField.text.split(':');
          endHour = int.parse(endParts[0]);
          endMinute = int.parse(endParts[1]);
        }

        // Convert to minutes for easier calculation
        int startTotalMinutes = startHour * 60 + startMinute;
        int endTotalMinutes = endHour * 60 + endMinute;

        // Calculate difference
        int differenceMinutes = endTotalMinutes - startTotalMinutes;

        // Handle case where end time is on the next day
        if (differenceMinutes < 0) {
          differenceMinutes += 24 * 60; // Add 24 hours
        }

        // Convert back to hours and minutes
        int totalHours = differenceMinutes ~/ 60;
        int remainingMinutes = differenceMinutes % 60;

        // Format the result as decimal hours
        double totalDecimalHours = totalHours + (remainingMinutes / 60);
        totalOverTimeTxtField.text = totalDecimalHours.toStringAsFixed(2);
      } catch (e) {
        print('Error calculating hours: $e');
        totalOverTimeTxtField.text = '';
      }
    }
  }

  Future<void> leaveRequestApi(BuildContext context) async {
    var url = Apis.saveOverTimeRequestApi;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();

    // Convert AM/PM format to 24-hour format for API
    String startTime24 = _convertTo24HourFormat(startTimeTxtField.text);
    String endTime24 = _convertTo24HourFormat(endTimeTxtField.text);
    debugPrint(
        "======formatDateWithDash(dateTxtField.text):${dateTxtField.text},${formatDateWithDash(dateTxtField.text)}=====");

    var helper = ApiProvider(context, url, {
      "tenantId": tenantId,
      "employeeId": empId,
      "employeeFk": null,
      "companyId": compId,
      "companyFk": null,
      "date": "${formatDateWithDash(dateTxtField.text)}T13:10:28.694Z",
      "startTime": "${dateTxtField.text}T${startTime24}:00.694Z",
      "endTime": "${dateTxtField.text}T${endTime24}:00.694Z",
      "totalOverTime": double.tryParse(totalOverTimeTxtField.text) ?? 0,
      "reason": reasonTxtField.text,
      "overTimeRequestStatus": "Pending",
      "id": 0
    });

    // debugPrint("========helper:${helper.bodyData}========");
    await helper.postApiData(showSuccess: false).then(
      (res) async {
        debugPrint("=========res:${res}==========");
        EasyLoading.dismiss();
        if (!isNullString(res)) {
          await CustomDialog(
              stylishDialogType: StylishDialogType.SUCCESS,
              msg: 'Over request submitted successfully',
              callBack: () {
                Get.back();
                Get.back();
              }).show(context);
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  Future<void> pickDate({
    required BuildContext context,
    String? initialDate, // Initial date as String
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default to current date if no initial date
      firstDate: DateTime.now(), // minimum date
      lastDate: DateTime(2101), // maximum date
    );

    if (pickedDate != null) {
      selectedDate.value = DateFormat('MM/dd/yyyy').format(pickedDate);
      dateTxtField.text = selectedDate.value;
    }
  }

  Future<String?> pickTime({
    required BuildContext context,
    String? initialTime,
  }) async {
    TimeOfDay initial = TimeOfDay.now();

    if (initialTime != null) {
      // Parse time in AM/PM format if it contains AM/PM
      if (initialTime.contains('AM') || initialTime.contains('PM')) {
        // Remove AM/PM and parse
        String timeOnly =
            initialTime.replaceAll(' AM', '').replaceAll(' PM', '');
        List<String> timeParts = timeOnly.split(":");
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        // Convert to 24-hour format for TimeOfDay
        if (initialTime.contains('PM') && hour != 12) {
          hour += 12;
        } else if (initialTime.contains('AM') && hour == 12) {
          hour = 0;
        }

        initial = TimeOfDay(hour: hour, minute: minute);
      } else {
        // Parse 24-hour format
        List<String> timeParts = initialTime.split(":");
        initial = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (pickedTime != null) {
      // Format time in 12-hour format with AM/PM
      String period = pickedTime.hour >= 12 ? 'PM' : 'AM';
      int hour12 = pickedTime.hour == 0
          ? 12
          : (pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour);
      String formattedTime =
          "${hour12.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} $period";
      return formattedTime;
    }

    return null; // Return null if no time is picked
  }

  Future<void> overTimeRequest(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      leaveRequestApi(context);
    }
  }

  @override
  void onClose() {
    // emailTxtField.dispose();
    // passwordTxtField.dispose();
    super.onClose();
  }
}
