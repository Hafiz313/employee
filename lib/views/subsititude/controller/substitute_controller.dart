import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:employee/core/models/response/GetLocationModels.dart';
import 'package:employee/main.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../core/models/response/GetDesignationModels.dart';
import '../../../core/models/response/GetEmpModels.dart';
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

class SubstituteController extends GetxController {
  Rx<SubFormDetailsModel> getSubstituteFormModel = SubFormDetailsModel().obs;
  Rx<SubFormDetailsModel> getSubstituteToModel = SubFormDetailsModel().obs;
  Rx<GetEmpModels> getEmpModels = GetEmpModels().obs;
  Rx<GetDesignationModels> getDesignationModels = GetDesignationModels().obs;
  Rx<GetLocationModels> getLocationModels = GetLocationModels().obs;
  RxBool isFromLoading = false.obs;
  RxBool isToLoading = false.obs;
  RxBool isEmpLoading = false.obs;
  RxBool isJobHourLoading = false.obs;
  RxBool isDesignationLoading = false.obs;
  RxBool isLocationLoading = false.obs;
  RxBool isLeaveCountLoading = false.obs;
  String? selectedDayType;
  List<String> daysTypeList = [
    'Full',
    'Half',
  ];

  Rx<GetLeaveContModel> getLeaveContModel = GetLeaveContModel(
          result: LeaveContResult(
              totalLeaves: 0, usedLeaves: 0, remainingLeaves: 0))
      .obs;
  String? selectedLeaveType;
  List<String> leaveTypeList = ['Casual Leave', 'Sick Leave', 'Annual Leave'];

  final formKey = GlobalKey<FormState>();

  final jobHoursTxtField = TextEditingController();

  final substituteHoursTxtField = TextEditingController();
  final dateTxtField = TextEditingController();

  final selectSubstituteEmployeeField = TextEditingController();

  final selectSubstituteDesignationField = TextEditingController();

  final locationField = TextEditingController();

  final totalOverTimeTxtField = TextEditingController();

  final reasonTxtField = TextEditingController();
  DateTime today = DateTime.now();
  DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));

  RxBool isShowDatePicker = false.obs;
  String formattedStartDate = '';
  String formattedEndDate = '';
  DateTime? selectedDateTime;
  String selectedDate = '';
  String dateRange = '';

  Rx<ItemsEpm> selectedEmp = ItemsEpm().obs;
  Rx<LocationResult> selectedLocation = LocationResult().obs;
  Rx<ResultDesignation> selectedDesignation = ResultDesignation().obs;

  RxBool isShowEmployee = false.obs;
  RxBool isShowDesignation = false.obs;
  RxBool isShowLocation = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getSubFormDetails(Get.context!,
        startDate: '${formatDateWithDash(lastMonth.toString())}T14:45:46.603Z',
        endDate: '${formatDateWithDash(today.toString())}T14:45:46.603Z');
    getSubToDetails(Get.context!,
        startDate: '${formatDateWithDash(lastMonth.toString())}T14:45:46.603Z',
        endDate: '${formatDateWithDash(today.toString())}T14:45:46.603Z');
  }

  Future<void> getSubFormDetails(
    BuildContext context, {
    required String startDate,
    required String endDate,
  }) async {
    isFromLoading.value = true;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getSubstituteRequestsFromOther}?empId=${EmpId}&tenantId=${tenantId}&compId=${compId}&startDate=${startDate}&endDate=${endDate}";
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
          getSubstituteFormModel.value =
              SubFormDetailsModel.fromJson(jsonDecode(res));
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isFromLoading.value = false;
      },
    );
  }

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

  Future<void> getEmp(BuildContext context) async {
    isEmpLoading.value = true;

    var url = Apis.getEmp;
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
          getEmpModels.value = GetEmpModels.fromJson(jsonDecode(res));
        }
        isEmpLoading.value = false;
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
          substituteHoursTxtField.text =
              jsonDecode(res)['result'].toString().replaceAll("-", "");
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  Future<void> getDesignation(BuildContext context) async {
    isDesignationLoading.value = true;

    var url = Apis.getDesignation;
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        debugPrint("===== getDesignation.value : -- ${res}=====");
        if (!isNullString(res)) {
          getDesignationModels.value =
              GetDesignationModels.fromJson(jsonDecode(res));
        }
        isDesignationLoading.value = false;
      },
    );
  }

  Future<void> getLocation(BuildContext context) async {
    isLocationLoading.value = true;

    var url = Apis.getLocation;
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        debugPrint("===== getDesignation.value : -- ${res}=====");
        if (!isNullString(res)) {
          getLocationModels.value = GetLocationModels.fromJson(jsonDecode(res));
        }
        isLocationLoading.value = false;
      },
    );
  }

  Future<void> submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      debugPrint("=======okkkkk=====");
      leaveSubstituteApi(context);
    }
  }

  Future<void> leaveSubstituteApi(BuildContext context) async {
    var url = Apis.saveSubstituteRequestApi;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String leaveType = selectedLeaveType!.replaceAll(' ', '');

    // var helper = ApiProvider(context, url, {
    //   "tenantId": tenantId,
    //   "employeeId": empId,
    //   "companyId": compId,
    //   "companyFk": null,
    //   "fromDate": formattedStartDate,
    //   "toDate": formattedEndDate,
    //   "reason": "string",
    //   "countForLeaves": findDaysBetweenDates(
    //       startDateString: formattedStartDate, endDateString: formattedEndDate),
    //   "attendenceLeaveType": "CasualLeave",
    //   "status": "Pending",
    //   "jobHours": jobHoursTxtField.text,
    //   "leaveHours": jobHoursTxtField.text,
    //   "dayType": selectedDayType,
    //   "id": 0
    // });
    var helper = ApiProvider(context, url, {
      "tenantId": tenantId,
      "companyId": compId,
      "senderEmployeeId": empId,
      "receiverEmployeeId": selectedEmp.value.id,
      "fromDate": '',
      "toDate": '',
      "description": reasonTxtField.text,
      "substituteDay": selectedDayType,
      "companyLocationId": selectedLocation.value.key,
      "jobHour": jobHoursTxtField.text,
      "substituteHours": substituteHoursTxtField.text,
      "leaveHour": jobHoursTxtField.text,
      "attendenceLeaveType": leaveType,
      "substituteStatus": "Pending",
      "fromTime": '',
      "toTime": '',
      "multipleSubstituteRequest": [
        {
          "date": "2025-01-30T17:47:39.160Z",
          "fromTime": "2025-01-30T17:47:39.160Z",
          "toTime": "2025-01-30T17:47:39.160Z",
          "id": 0
        }
      ]
    });

    debugPrint("========helper:${helper.bodyData}========");
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

  Future<void> getSubToDetails(
    BuildContext context, {
    required String startDate,
    required String endDate,
  }) async {
    isToLoading.value = true;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url =
        "${Apis.getSubstituteRequestsToOther}?empId=${EmpId}&tenantId=${tenantId}&compId=${compId}&startDate=${startDate}&endDate=${endDate}";
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
          getSubstituteToModel.value =
              SubFormDetailsModel.fromJson(jsonDecode(res));
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
        isToLoading.value = false;
      },
    );
  }
}
