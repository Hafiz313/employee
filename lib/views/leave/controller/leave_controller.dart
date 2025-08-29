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

class LeaveController extends GetxController {
  Rx<GetLeaveContModel> getLeaveContModel = GetLeaveContModel(
          result: LeaveContResult(
              totalLeaves: 0, usedLeaves: 0, remainingLeaves: 0))
      .obs;
  RxBool isShowDatePicker = false.obs;
  RxBool isJobHourLoading = false.obs;
  RxBool isLeaveCountLoading = false.obs;

  final dateTxtField = TextEditingController();

  final selectSubstituteEmployeeField = TextEditingController();

  final selectSubstituteDesignationField = TextEditingController();

  final locationField = TextEditingController();

  final totalOverTimeTxtField = TextEditingController();

  final reasonTxtField = TextEditingController();
  final jobHoursTxtField = TextEditingController();

  final startTimeTxtField = TextEditingController();
  String? selectedLeaveType;

  String formattedStartDate = '';
  String formattedEndDate = '';
  List<String> leaveTypeList = ['Casual Leave', 'Sick Leave', 'Annual Leave'];
  String? selectedDayType;
  List<String> daysTypeList = [
    'Full',
    'Half',
  ];

  DateTime? selectedDateTime;
  String selectedDate = '';
  String dateRange = '';

  Future<void> getLeaveCount(BuildContext context,
      {required String leaveType}) async {
    isLeaveCountLoading.value = true;

    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getLeaveCountApi}?empId=${EmpId}&tenantId=${tenantId}&leaveType=${leaveType}&compId=${compId}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          getLeaveContModel.value = getLeaveContModelFromJson(res);
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isLeaveCountLoading.value = false;
      },
    );
  }

  Future<void> getJobHours(BuildContext context,
      {required String fromDate, required String toDate}) async {
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getJobHoursApi}?fromDate=${fromDate}&toDate=${toDate}&empId=${empId}&tenantID=${tenantId}&compID=${compId}";
    isJobHourLoading.value = true;
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        isJobHourLoading.value = false;
        if (!isNullString(res)) {
          jobHoursTxtField.text =
              jsonDecode(res)['result'].toString().replaceAll("-", "");
          // getLeaveContModel.value = getLeaveContModelFromJson(res);
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  Future<void> requestLeave(BuildContext context,
      {required String leaveType}) async {
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getLeaveCountApi}?empId=${EmpId}&tenantId=${tenantId}&leaveType=${leaveType}&compId=${compId}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          getLeaveContModel.value = getLeaveContModelFromJson(res);
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  Future<void> leaveRequestApi(BuildContext context) async {
    var url = Apis.saveLeaveRequestApi;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String leaveType = selectedLeaveType!.replaceAll(' ', '');

    var helper = ApiProvider(context, url, {
      "tenantId": tenantId,
      "employeeId": empId,
      "companyId": compId,
      "companyFk": null,
      "fromDate": formattedStartDate,
      "toDate": formattedEndDate,
      "reason": "string",
      "countForLeaves": findDaysBetweenDates(
          startDateString: formattedStartDate, endDateString: formattedEndDate),
      "attendenceLeaveType": leaveType,
      "status": "Pending",
      "jobHours": jobHoursTxtField.text,
      "leaveHours": jobHoursTxtField.text,
      "dayType": selectedDayType,
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
              msg: 'Leave request submitted successfully',
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

  Future<void> leaveRequest(BuildContext context) async {
    if (selectedLeaveType == null) {
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: 'Please select the Leave type',
      ).show(context);
    } else if (formattedStartDate.isEmpty) {
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: 'Please select the Date Range',
      ).show(context);
    } else if (selectedDayType == null) {
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: 'Please select the Days',
      ).show(context);
    } else {
      leaveRequestApi(context);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    // emailTxtField.dispose();
    // passwordTxtField.dispose();
    super.onClose();
  }
}
