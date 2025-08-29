import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:employee/main.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../core/models/response/attendance_detail_model.dart';
import '../../../core/models/response/attendance_list_models.dart';
import '../../../networking/api_provider.dart';
import '../../../networking/api_ref.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/helper.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import '../../home/home_view.dart';

class AttendanceController extends GetxController {
  Rx<AttendanceListModels> getAttendanceListModel =
      AttendanceListModels(attendanceResultList: []).obs;
  Rx<AttendanceDetailModel> getAttendanceDetailModel = AttendanceDetailModel(
      result: AttendanceDetailResult(
    attendancePercentage: 0,
    workedHours: 0,
    leaveCount: 0,
  )).obs;

  RxBool isListLoading = false.obs;
  DateTime lastWeek = DateTime.now().subtract(const Duration(days: 7));
  DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));
  DateTime? selectedDateTime;
  RxString dateRange = ''.obs;
  DateTime today = DateTime.now();
  RxString startDate = formatDate(DateTime.now().toString()).obs;
  RxString endDate =
      formatDate(DateTime.now().subtract(const Duration(days: 30)).toString())
          .obs;
  RxString attendance = '0'.obs;
  RxString punctuality = '0'.obs;
  Future<void> getAttendanceList(
    BuildContext context, {
    required String startDate,
    required String endDate,
  }) async {
    debugPrint("=====getAttendanceDetailApi=====");
    isListLoading.value = true;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getAttendanceListApi}?empId=${EmpId}&tenantId=${tenantId}&compId=${compId}&startDate=${startDate}&endDate=${endDate}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        if (!isNullString(res)) {
          getAttendanceListModel.value =
              AttendanceListModels.fromJson(jsonDecode(res));

          if (getAttendanceListModel.value.attendanceResultList!.isNotEmpty) {
            attendance.value = (double.parse(getAttendanceListModel
                        .value.attendanceResultList![0].attendancePercentage
                        .toString()) /
                    100)
                .toStringAsFixed(0);
            punctuality.value = (double.parse(getAttendanceListModel
                        .value.attendanceResultList![0].punctuality
                        .toString()) /
                    100)
                .toStringAsFixed(0);
          }
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isListLoading.value = false;
      },
    );
  }

  Future<void> getAttendanceDetails(
    BuildContext context, {
    required String startDate,
    required String endDate,
  }) async {
    debugPrint("=====getAttendanceDetailApi=====");
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getAttendanceDetailsApi}?empId=${EmpId}&tenantId=${tenantId}&compId=${compId}&startDate=${startDate}&endDate=${endDate}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        debugPrint("===== getAttendanceDetailModel.value : -- ${res}=====");
        if (!isNullString(res)) {
          getAttendanceDetailModel.value =
              AttendanceDetailModel.fromJson(jsonDecode(res));
          debugPrint(
              "===== getAttendanceDetailModel.value : -- ${getAttendanceDetailModel.value.result!.attendancePercentage}=====");
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }
}
