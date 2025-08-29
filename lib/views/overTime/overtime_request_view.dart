import 'package:employee/networking/api_provider.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/overTime/controller/overtime_controller.dart';
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

class OvertimeRequestView extends StatelessWidget {
  OvertimeRequestView({super.key});
  static const String routeName = '/OvertimeRequestView';

  OverTimeController controller = Get.put(OverTimeController());
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
          width: double.infinity,
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: context.percentHeight * 3.0,
                        bottom: context.percentHeight * 8.0),
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 4.0,
                        vertical: context.percentHeight * 2),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(context.percentHeight * 0.3)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.screenHeight * 0.02,
                        ),
                        headline3(Lang.overtimeRequest.toUpperCase(),
                            color: AppColors.blue),
                        SizedBox(
                          height: context.screenHeight * 0.015,
                        ),
                        InkWell(
                          onTap: () async {
                            controller.pickDate(
                              context: context,
                              initialDate: controller.selectedDate.value,
                            );
                          },
                          child: CustomTxtField(
                            hintTxt: Lang.date,
                            isRequired: true,
                            enabled: false,
                            textEditingController: controller.dateTxtField,
                            suffixIcon: Icon(
                              FontAwesomeIcons.calendarDays,
                              color: AppColors.borderColor,
                              size: context.screenHeight * 0.02,
                            ),
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Please select date !';
                              }

                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        InkWell(
                          onTap: () async {
                            String? pickedTime =
                                await controller.pickTime(context: context);

                            if (pickedTime != null) {
                              print("Selected Time: $pickedTime");
                              controller.startTimeTxtField.text = pickedTime;
                              // Calculate total hours when start time is set
                              controller.calculateTotalHours();
                            }
                          },
                          child: CustomTxtField(
                            hintTxt: Lang.startTime,
                            textEditingController: controller.startTimeTxtField,
                            enabled: false,
                            isRequired: true,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Please select start time !';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        InkWell(
                          onTap: () async {
                            String? pickedTime =
                                await controller.pickTime(context: context);

                            if (pickedTime != null) {
                              print("Selected Time: $pickedTime");
                              controller.endTimeTxtField.text = pickedTime;
                              // Calculate total hours when end time is set
                              controller.calculateTotalHours();
                            }
                          },
                          child: CustomTxtField(
                            hintTxt: Lang.endTime,
                            enabled: false,
                            isRequired: true,
                            textEditingController: controller.endTimeTxtField,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Please select end time !';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        CustomTxtFieldV1(
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          hintTxt: Row(
                            children: [
                              subText4(Lang.totalOvertime,
                                  color: AppColors.borderColor),
                            ],
                          ),
                          textEditingController:
                              controller.totalOverTimeTxtField,
                          validator: (String? val) {},
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        CustomTxtFieldDes(
                          keyboardType: TextInputType.multiline,
                          hintTxt: Lang.reason,
                          isRequired: true,
                          textEditingController: controller.reasonTxtField,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return 'Please select end time !';
                            }
                          },
                        ),
                        Obx(() => mainLoading.value
                            ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const MyLoader(),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: context.percentHeight * 2.0,
                                  ),
                                  AppElevatedButton(
                                      backgroundColor: AppColors.blue,
                                      onPressed: () =>
                                          controller.overTimeRequest(context),
                                      title: Lang.submit),
                                  SizedBox(
                                    height: context.percentHeight * 2.0,
                                  ),
                                ],
                              ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
