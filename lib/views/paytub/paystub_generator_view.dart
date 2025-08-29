import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/paytub/controller/paystub_controller.dart';
import 'package:employee/views/paytub/widget/PaystubDialog.dart';
import 'package:employee/views/widget/text_fields_des.dart';
import 'package:employee/views/widget/text_fields_v1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../consts/lang.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';
import '../widget/text_fields.dart';
import '../auth/login/login_view.dart';
import '../auth/Otp/otp_view.dart';

class PaystubGeneratorView extends StatefulWidget {
  PaystubGeneratorView({super.key});
  static const String routeName = '/PaystubGeneratorView';

  @override
  State<PaystubGeneratorView> createState() => _PaystubGeneratorViewState();
}

class _PaystubGeneratorViewState extends State<PaystubGeneratorView> {
  PayStubController payStubController = Get.put(PayStubController());
  @override
  void initState() {
    // TODO: implement initState
    payStubController.isShowList.value = true;
    payStubController.getPeriods(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        body: Obx(
          () => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth * 2.5),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: context.percentHeight * 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              subText4(Lang.paystubGenerator,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor),
                            ],
                          ),
                          // SizedBox(height: context.percentHeight * 3,),
                          // subText4(Lang.paystubGenerator,fontWeight: FontWeight.bold,color: AppColors.blackColor),
                          // SizedBox(height: context.percentHeight * 1,),
                          // CustomTxtField(
                          //   hintTxt: Lang.weekly,
                          //   suffixIcon:  Icon(FontAwesomeIcons.caretDown,color: AppColors.borderColor,size: context.screenHeight * 0.02,),
                          //   textEditingController: weeklyTxtField,
                          //   validator: (String? val) {
                          //     if (val!.isEmpty) {
                          //       return 'Please enter Email';
                          //     }
                          //     if (!emailExp.hasMatch(val)) {
                          //       return 'Please enter valid Email';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // SizedBox(height: context.screenHeight * 0.01,),
                          subText4(Lang.payPeriod,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor),
                          SizedBox(
                            height: context.percentHeight * 1,
                          ),
                          InkWell(
                            onTap: () {
                              payStubController.isShowList.value =
                                  !payStubController.isShowList.value;
                              if (payStubController.isShowList.value) {
                                payStubController.getPeriods(context);
                              }
                            },
                            child: CustomTxtField(
                              enabled: false,
                              hintTxt: '${payStubController.selectedItem}',
                              textEditingController:
                                  payStubController.dateTxtField,
                              suffixIcon: Icon(
                                FontAwesomeIcons.caretDown,
                                color: AppColors.borderColor,
                                size: context.screenHeight * 0.02,
                              ),
                              validator: (String? val) {
                                if (val!.isEmpty) {
                                  return 'Please enter Email';
                                }
                                if (!emailExp.hasMatch(val)) {
                                  return 'Please enter valid Email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: context.percentHeight * 2.0,
                          ),
                          if (payStubController.isShowList.value)
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.borderColor)),
                              height: 300,
                              child: payStubController.isPeriodsLoading.value
                                  ? const MyLoader()
                                  : ListView.builder(
                                      itemCount: payStubController
                                          .getPayperiodsModels
                                          .value
                                          .result!
                                          .length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              payStubController
                                                  .toggleSaveThisDevice(
                                                payStubController
                                                    .getPayperiodsModels
                                                    .value
                                                    .result![index],
                                              );
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        AppColors.borderColor)),
                                            child: Row(
                                              children: [
                                                // Checkbox(
                                                //   materialTapTargetSize:
                                                //       MaterialTapTargetSize
                                                //           .shrinkWrap,
                                                //   visualDensity:
                                                //       VisualDensity.compact,
                                                //   value: payStubController
                                                //       .isSaveThisDevice.value,
                                                //   onChanged: (value) {
                                                //     setState(() {
                                                //       payStubController
                                                //           .toggleSaveThisDevice(
                                                //               value);
                                                //     });
                                                //   },
                                                //   side: const BorderSide(
                                                //       color: Colors.grey, width: 1.5),
                                                // ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                subText2(
                                                    "${payStubController.getPayperiodsModels.value.result![index].name}",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color:
                                                        AppColors.blackColor),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            )
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter, child: btn(context)),
                  ],
                ),
              )),
        ));
  }

  Widget btn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.percentHeight * 3),
      child: Obx(() => SizedBox(
            width: double.infinity,
            height: context.percentWidth * 11,
            child: ElevatedButton(
              onPressed: payStubController.isGeneratingPaystub.value
                  ? null
                  : () => payStubController.genratePaytub(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: AppColors.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: payStubController.isGeneratingPaystub.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Generating...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        Lang.generatePaystub,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          )),
    );
  }

  void showPayrollDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          FontAwesomeIcons.xmark,
                          color: AppColors.redColor,
                        ),
                      ),
                    ],
                  ),
                  Text("Jimson Jonsy & Co.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("New York City, NY 11432"),
                  Divider(),
                  Text("Pay to the Order of",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Michal Moter"),
                  Text("Amount: \$405.55",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.green[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Paystub",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        buildInfoRow("Employer", "Jimson Jonsy & Co."),
                        buildInfoRow("Pay Period", "mm/dd/yyyy - mm/dd/yyyy"),
                        SizedBox(height: 8),
                        buildInfoRow("Tax Status", "Single"),
                        buildInfoRow("SSN", "654-45-6454"),
                        buildInfoRow("Payment Method", "Check"),
                        buildInfoRow("Check Issue Date", "11-19-2024"),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.green[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Payments",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        buildInfoRow("Salary", "\$500"),
                        buildInfoRow("Tips", "\$0"),
                        buildInfoRow("Other Benefits", "\$0"),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.green[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Deductions",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        buildInfoRow("Federal WH", "\$24.25"),
                        buildInfoRow("Medicare Tax", "\$7.54"),
                        buildInfoRow("Social Security Tax", "\$32.24"),
                        buildInfoRow("NYS WH", "\$17.6"),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.green[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        buildInfoRow("Gross Pay", "\$500"),
                        buildInfoRow("Deductions", "\$94.45"),
                        buildInfoRow("Net Pay", "\$405.55"),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: Text("Download"),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
