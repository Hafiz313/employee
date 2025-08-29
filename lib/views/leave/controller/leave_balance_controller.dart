import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:employee/main.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../core/models/response/LeaveBalanceHistory.dart';
import '../../../core/models/response/LeaveBalanceListModel.dart';
import '../../../core/models/response/SubFormDetailsModel.dart';
import '../../../core/models/response/attendance_detail_model.dart';
import '../../../core/models/response/attendance_list_models.dart';
import '../../../networking/api_provider.dart';
import '../../../networking/api_ref.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/helper.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import '../../home/home_view.dart';

class LeaveBalanceController extends GetxController {
  Rx<LeaveBalanceListModel> leaveBalanceList =
      LeaveBalanceListModel(result: []).obs;
  Rx<LeaveBalanceHistory> leaveBalanceHistory = LeaveBalanceHistory().obs;
  RxBool isLoading = false.obs;

  double totalLeave = 0;
  double totalCasualLeave = 0;
  double totalAnnulLeave = 0;
  double totalSickLeave = 0;
  double usedLeave = 0;
  double usedCasualLeave = 0;
  double usedAnnulLeave = 0;
  double usedSickLeave = 0;
  double usedTotalLeavePercentage = 0;
  double usedCasualLeavePercentage = 0;
  double usedAnnulLeavePercentage = 0;
  double usedSickLeavePercentage = 0;

  DateTime today = DateTime.now();
  DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getLeaveBalanceList(Get.context!,
        startDate: '${formatDateWithDash(lastMonth.toString())}T14:45:46.603Z',
        endDate: '${formatDateWithDash(today.toString())}T14:45:46.603Z');
    getLeaveHistory(Get.context!);
  }

  Future<void> getLeaveHistory(
    BuildContext context,
  ) async {
    isLoading.value = true;
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url = "${Apis.getLeaveBalanceHistoryApi}?empId=${empId}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        debugPrint("===== getLeaveBalanceListApi.value : $res=====");
        if (!isNullString(res)) {
          leaveBalanceHistory.value =
              LeaveBalanceHistory.fromJson(jsonDecode(res));
          for (int i = 0; i < leaveBalanceHistory.value.result!.length; i++) {
            totalLeave += leaveBalanceHistory.value.result![i].totalLeaves;
            usedLeave += leaveBalanceHistory.value.result![i].usedLeaves;

            if (leaveBalanceHistory.value.result![i].employeeLeaveType ==
                'CasualLeave') {
              totalCasualLeave =
                  leaveBalanceHistory.value.result![i].totalLeaves;
              usedCasualLeave = leaveBalanceHistory.value.result![i].usedLeaves;
              usedCasualLeavePercentage = totalCasualLeave > 0
                  ? (usedCasualLeave / totalCasualLeave)
                  : 0.0;
            } else if (leaveBalanceHistory.value.result![i].employeeLeaveType ==
                'SickLeave') {
              totalSickLeave = leaveBalanceHistory.value.result![i].totalLeaves;
              usedSickLeave = leaveBalanceHistory.value.result![i].usedLeaves;
              usedSickLeavePercentage =
                  totalSickLeave > 0 ? (usedSickLeave / totalSickLeave) : 0.0;
            } else if (leaveBalanceHistory.value.result![i].employeeLeaveType ==
                'AnnualLeave') {
              totalAnnulLeave =
                  leaveBalanceHistory.value.result![i].totalLeaves;
              usedAnnulLeave = leaveBalanceHistory.value.result![i].usedLeaves;
              usedAnnulLeavePercentage = totalAnnulLeave > 0
                  ? (usedAnnulLeave / totalAnnulLeave)
                  : 0.0;
            }
            debugPrint(
                "====totalLeave:${totalLeave},usedLeave:${usedLeave}=====");
          }
          try {
            usedTotalLeavePercentage =
                totalLeave > 0 ? (usedLeave / totalLeave) : 0.0;
            debugPrint(
                "====usedLeavePercentage:${usedTotalLeavePercentage}=====");
          } catch (e) {}

          // debugPrint("===== getAttendanceDetailModel.value : -- ${getSubstituteFormModel.value.result!.length}=====");
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> getLeaveBalanceList(
    BuildContext context, {
    required String startDate,
    required String endDate,
  }) async {
    isLoading.value = true;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getLeaveBalanceListApi}?empId=${EmpId}&tenantId=${tenantId}&compId=${compId}&startDate=${startDate}&endDate=${endDate}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        debugPrint("===== getLeaveBalanceListApi.value : -- ${res}=====");
        if (!isNullString(res)) {
          leaveBalanceList.value =
              LeaveBalanceListModel.fromJson(jsonDecode(res));
          // debugPrint("===== getAttendanceDetailModel.value : -- ${getSubstituteFormModel.value.result!.length}=====");
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isLoading.value = false;
      },
    );
  }
}
