import 'dart:convert';

import 'package:employee/consts/lang.dart';
import 'package:employee/core/models/response/BankListModel.dart';
import 'package:employee/core/models/response/GetLeaveContModel.dart';
import 'package:employee/main.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

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

class BankController extends GetxController {
  Rx<BankListModel> bankList = BankListModel(
          result:
              BankResult(bankName: '', accountNumber: '', paymentMethod: ''))
      .obs;
  RxBool isLoading = false.obs;

  final emailTxtField = TextEditingController();
  final bankNameTxtField = TextEditingController();
  final routingField = TextEditingController();
  final accountNoField = TextEditingController();
  final accountTypeField = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getBankDetails(Get.context!);
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

  Future<void> addBankApi(BuildContext context) async {
    var url = Apis.createOrEditEmployeePayment;
    String tenantId =
        StorageService().getData(StorageConsts.kTenantId).toString();
    String compId =
        StorageService().getData(StorageConsts.kCompanyId).toString();
    String empId =
        StorageService().getData(StorageConsts.kEmployeeId).toString();
    String userId = StorageService().getData(StorageConsts.kUserId).toString();
    debugPrint("=========emailTxtField:${emailTxtField.text}========");
    debugPrint("========bankNameTxtField:${bankNameTxtField.text}=========");
    debugPrint("=========routingField:${routingField.text}========");
    debugPrint("=========routingField:${accountNoField.text}========");
    debugPrint("=========accountTypeField:${accountTypeField.text}========");
    var helper = ApiProvider(context, url, {
      "paymentMethod": "DirectDeposit",
      "routingNumber": routingField.text,
      "accountNumber": accountNoField.text,
      "accountType": "Checking",
      "bankName": bankNameTxtField.text,
      "isActive": true,
      "fromDate": null,
      "toDate": null,
      "tenantId": tenantId,
      "employeeId": empId,
      "contractorId": null,
      "companyId": compId,
      "emailAddress": null,
      "id": userId
    });

    debugPrint("========helper:${helper.bodyData}========");
    await helper.postApiData(showSuccess: false).then(
      (res) async {
        debugPrint("=========res:${res}==========");
        Get.back();
        EasyLoading.dismiss();
        getBankDetails(Get.context!);

        if (!isNullString(res)) {
          // await CustomDialog(
          //   stylishDialogType: StylishDialogType.SUCCESS,
          //   msg: 'Add Bank Details ',
          // ).show(context);
        } else {
          await CustomDialog(
            stylishDialogType: StylishDialogType.ERROR,
            msg: Lang.somethingWentWrong,
          ).show(context);
        }
      },
    );
  }

  save() {
    debugPrint("=========emailTxtField:${emailTxtField.text}========");
    debugPrint("========bankNameTxtField:${bankNameTxtField.text}=========");
    debugPrint("=========routingField:${routingField.text}========");
    debugPrint("=========accountTypeField:${accountTypeField.text}========");

    addBankApi(Get.context!);
  }
}
