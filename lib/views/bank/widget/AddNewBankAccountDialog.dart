import 'package:employee/consts/colors.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../../utils/my_loader.dart';
import '../../subsititude/controller/substitute_controller.dart';
import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../../widget/text_fields_des.dart';
import '../controller/bank_controller.dart';

class AddNewBankAccountDialog extends StatefulWidget {
  final Function()? onPressedSubmit;
  AddNewBankAccountDialog({
    super.key,
    this.onPressedSubmit,
  });

  @override
  State<AddNewBankAccountDialog> createState() =>
      _AddNewBankAccountDialogState();
}

class _AddNewBankAccountDialogState extends State<AddNewBankAccountDialog> {
  final controller = Get.find<BankController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(vertical: context.percentHeight * 1.5),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: subText2('Edit New Bank Account',
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 4.0,
                        vertical: context.percentHeight * 2),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(context.percentHeight * 0.3)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.screenHeight * 0.01,
                          ),
                          CustomTxtField(
                            isRequired: true,
                            hintTxt: '${Lang.email} *',
                            enabled: false,
                            hintStyle: const TextStyle(
                                fontSize: 10, color: AppColors.textColor),
                            textEditingController: controller.emailTxtField,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Empty';
                              }

                              return null;
                            },
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              CustomTxtField(
                                isRequired: true,
                                hintTxt: '${Lang.bankName} *',
                                textEditingController:
                                    controller.bankNameTxtField,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Empty';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              CustomTxtField(
                                isRequired: true,
                                hintTxt: '${Lang.routing} *',
                                textEditingController: controller.routingField,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Empty';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              CustomTxtField(
                                isRequired: true,
                                hintTxt: '${Lang.account} *',
                                textEditingController:
                                    controller.accountNoField,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Empty';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: context.screenHeight * 0.01,
                          ),
                          CustomTxtField(
                            isRequired: true,
                            hintTxt: '${Lang.accountType} *',
                            textEditingController: controller.accountTypeField,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Empty';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: context.percentHeight * 2.0,
                          ),
                          AppElevatedButton(
                              backgroundColor: AppColors.blueV1,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.save();
                                }
                              },
                              title: 'Save'),
                          SizedBox(
                            height: context.percentHeight * 1.0,
                          ),
                          AppElevatedButton(
                              backgroundColor: AppColors.redColor,
                              onPressed: () => Navigator.pop(context),
                              title: Lang.cancel),
                          SizedBox(
                            height: context.percentHeight * 2.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leaveCard(BuildContext context,
      {required String title, required String cont}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 1,
            vertical: context.percentHeight * 1.2),
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
        child: subText4('${title}: $cont', color: AppColors.white),
      ),
    );
  }
}
