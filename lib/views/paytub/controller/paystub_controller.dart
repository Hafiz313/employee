import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/BankListModel.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:employee/core/models/response/PaystubModel.dart';
import 'package:employee/main.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../../../core/models/response/GetPayperiodsModels.dart';
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
import '../widget/PaystubDialog.dart';

class PayStubController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final weeklyTxtField = TextEditingController();
  final dateTxtField = TextEditingController();
  RxBool isSaveThisDevice = false.obs;
  RxString selectedPeriodId = ''.obs;

  var selectedItem = 'mm/dd/yyyy - mm/dd/yyyy'.obs;
  void toggleSaveThisDevice(GetPayperiodsResult value) {
    isShowList.value = false;
    dateTxtField.text = value.name!;
    selectedPeriodId.value = value.id!.toString();
  }

  RxBool isShowList = true.obs;
  Rx<GetPayperiodsModels> getPayperiodsModels = GetPayperiodsModels().obs;
  Rx<BankListModel> bankList = BankListModel(
          result:
              BankResult(bankName: '', accountNumber: '', paymentMethod: ''))
      .obs;
  RxBool isLoading = false.obs;
  RxBool isPeriodsLoading = false.obs;
  RxBool isGeneratingPaystub =
      false.obs; // Add new loading state for generate paystub

  // Add paystub data storage
  Rx<PaystubModel> paystubData = PaystubModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // getBankDetails(Get.context!);
  }

  Future<void> getBankDetails(
    BuildContext context,
  ) async {
    isLoading.value = true;
    String EmpId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url = "${Apis.getBankListApi}?input=${EmpId}";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: true,
    )
        .then(
      (res) async {
        debugPrint("===== getLeaveBalanceListApi.value : -- ${res}=====");
        if (!isNullString(res)) {
          bankList.value = BankListModel.fromJson(jsonDecode(res));
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

  Future<void> getPeriods(BuildContext context) async {
    isPeriodsLoading.value = true;

    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    var url = "${Apis.getPeriodsApi}?employeeId=$empId";
    var helper = ApiProvider(context, url, {});
    await helper
        .getApiData(
      showSuccess: false,
      showLoader: false,
    )
        .then(
      (res) async {
        isPeriodsLoading.value = false;
        if (!isNullString(res)) {
          getPayperiodsModels.value =
              GetPayperiodsModels.fromJson(jsonDecode(res));
        } else {
          EasyLoading.dismiss();
        }
      },
    );
    isPeriodsLoading.value = false;
  }

  void genratePaytub(BuildContext context) async {
    if (selectedPeriodId.value.isEmpty) {
      // Show error message for missing period selection
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: "Please select a pay period first",
      ).show(context);
    } else {
      // Generate paystub and show dialog
      bool success =
          await generatePayStub(context, periodId: selectedPeriodId.value);
      if (success) {
        final firstPaystub = paystubData.value.result?.isNotEmpty == true
            ? paystubData.value.result!.first
            : null;
        if (firstPaystub != null) {
          showDialog(
            context: context,
            builder: (_) => PaystubDialog(paystub: firstPaystub),
          );
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: "No paystub data found.",
          ).show(context);
        }
      }
    }
  }

  Future<bool> generatePayStub(BuildContext context,
      {required String periodId}) async {
    isGeneratingPaystub.value = true;

    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String comId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    var url =
        "${Apis.genratePayStub}?periodId=${periodId}&companyId=$comId&employeeId=$empId";
    var helper = ApiProvider(context, url, {});

    try {
      final res = await helper.getApiData(
        showSuccess: false,
        showLoader: false, // We'll handle our own loading state
      );

      if (!isNullString(res)) {
        final decoded = jsonDecode(res);

        if (decoded is List && decoded.isNotEmpty) {
          // Not expected anymore, but keep for safety
          paystubData.value =
              PaystubModel(result: [PaystubResult.fromJson(decoded[0])]);
        } else if (decoded is Map<dynamic, dynamic> ||
            decoded is Map<String, dynamic>) {
          paystubData.value =
              PaystubModel.fromJson(Map<String, dynamic>.from(decoded));
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: "Unexpected paystub response format.",
          ).show(context);
          return false;
        }
        return true;
      } else {
        await CustomDialog(
          stylishDialogType: StylishDialogType.ERROR,
          msg: "Failed to generate paystub. Please try again.",
        ).show(context);
        return false;
      }
    } catch (e, s) {
      debugPrint("=======sss:${s}====");
      await CustomDialog(
        stylishDialogType: StylishDialogType.ERROR,
        msg: "Error generating paystub: $e",
      ).show(context);
      return false;
    }
  }
}
