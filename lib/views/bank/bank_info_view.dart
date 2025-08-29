import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/bank/controller/bank_controller.dart';
import 'package:employee/views/bank/widget/AddNewBankAccountDialog.dart';
import 'package:employee/views/widget/text_fields_des.dart';
import 'package:employee/views/widget/text_fields_v1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../consts/lang.dart';
import '../../utils/localStorage/storage_consts.dart';
import '../../utils/localStorage/storage_service.dart';
import '../base_view/base_scaffold.dart';
import '../subsititude/widget/RequestSubstituteDialog.dart';
import '../trainingAndCourses/course_details_view.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';
import '../widget/text_fields.dart';
import '../auth/login/login_view.dart';
import '../auth/Otp/otp_view.dart';

class BankInfoView extends StatefulWidget {
  BankInfoView({super.key});
  static const String routeName = '/BankInfoView';

  @override
  State<BankInfoView> createState() => _BankInfoViewState();
}

class _BankInfoViewState extends State<BankInfoView> {
  BankController controller = Get.put(BankController());

  @override
  void initState() {
    // TODO: implement initState

    controller.getBankDetails(Get.context!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        isBackArrow: true,
        body: Obx(() => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
              width: double.infinity,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        color: AppColors.green,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: subText3("Bank Information",
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.percentWidth * 3),
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.percentHeight * 1,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: AppColors.primary),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                                SizedBox(
                                  width: context.percentWidth * 1,
                                ),
                                subText4('Primary',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold)
                              ],
                            ),
                            SizedBox(
                              height: context.percentHeight * 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subText4('Payment Method',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                                subText4(
                                    controller.bankList.value.result!
                                            .paymentMethod!.isEmpty
                                        ? ""
                                        : '${controller.bankList.value.result!.paymentMethod}',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                            SizedBox(
                              height: context.percentHeight * 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subText4('Bank Name',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                                subText4(
                                    controller.bankList.value.result!.bankName!
                                                .isEmpty &&
                                            controller.bankList.value.result!
                                                    .bankName! ==
                                                null
                                        ? ""
                                        : '${controller.bankList.value.result!.bankName}',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                            SizedBox(
                              height: context.percentHeight * 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subText4('Bank Account #',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                                subText4(
                                    controller.bankList.value.result!
                                            .accountNumber!.isEmpty
                                        ? ""
                                        : '${controller.bankList.value.result!.accountNumber}',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                            SizedBox(
                              height: context.percentHeight * 0.5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: btn(context),
                  )
                ],
              ),
            )));
  }

  Widget btn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.percentHeight * 3),
      child: AppElevatedButton(
          width: double.infinity,
          backgroundColor: AppColors.green,
          onPressed: () {
            String email = StorageService().getData(StorageConsts.kUserEmail);

            controller.emailTxtField.text = email;
            controller.bankNameTxtField.text =
                controller.bankList.value.result!.bankName;
            controller.routingField.text =
                controller.bankList.value.result!.routingNumber;
            controller.accountTypeField.text =
                controller.bankList.value.result!.accountType;
            controller.accountNoField.text =
                controller.bankList.value.result!.accountNumber;

            showDialog(
              context: context,
              builder: (context) => AddNewBankAccountDialog(
                onPressedSubmit: () {
                  // Navigator.pop(context);
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => SubstituteRequestDialog(
                  //     onPressedAccept: () => Navigator.pop(context),
                  //     onPressedDecline: () {
                  //       debugPrint(
                  //           "========onPressedSubmit========");
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // );
                },
              ),
            );
          },
          title: 'Edit'),
    );
  }
}
