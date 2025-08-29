import 'package:employee/consts/colors.dart';
import 'package:employee/networking/api_provider.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../consts/lang.dart';
import '../../../utils/DateForm.dart';
import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../../widget/text_fields_des.dart';
import '../controller/substitute_controller.dart';

class RequestSubstituteDialog extends StatefulWidget {
  final Function()? onPressedSubmit;
  const RequestSubstituteDialog({super.key, this.onPressedSubmit});

  @override
  State<RequestSubstituteDialog> createState() =>
      _RequestSubstituteDialogState();
}

class _RequestSubstituteDialogState extends State<RequestSubstituteDialog> {
  final controller = Get.find<SubstituteController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Obx(
          () => SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: context.percentHeight * 1.5),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: subText2(Lang.requestASubstitute,
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
                            borderRadius: BorderRadius.circular(
                                context.percentHeight * 0.3)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              // // leaveCount(),
                              // SizedBox(
                              //   height: context.screenHeight * 0.01,
                              // ),
                              leaveType(),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.isShowEmployee.value =
                                      !controller.isShowEmployee.value;
                                  if (controller.isShowEmployee.value) {
                                    controller.getEmp(context);
                                  }
                                },
                                child: CustomTxtField(
                                  hintTxt: Lang.selectSubstituteEmployee,
                                  enabled: false,
                                  isRequired: true,
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blackColor),
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.caretDown,
                                    color: AppColors.textColor,
                                    size: context.screenHeight * 0.015,
                                  ),
                                  textEditingController:
                                      controller.selectSubstituteEmployeeField,
                                  validator: (String? val) {
                                    if (val!.isEmpty) {
                                      return 'Please ${Lang.selectSubstituteEmployee}';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              if (controller.isShowEmployee.value)
                                Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.homeBG,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: controller.isEmpLoading.value
                                      ? const MyLoader()
                                      : ListView.builder(
                                          itemCount: controller.getEmpModels
                                              .value.result!.items!.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                controller.isShowEmployee
                                                    .value = false;
                                                controller.selectedEmp.value =
                                                    controller
                                                        .getEmpModels
                                                        .value
                                                        .result!
                                                        .items![index];
                                                controller
                                                        .selectSubstituteEmployeeField
                                                        .text =
                                                    controller.selectedEmp.value
                                                        .fullName!;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                        color: AppColors.primary
                                                            .withOpacity(0.3)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ]),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Row(
                                                  children: [
                                                    subText4(
                                                        "${controller.getEmpModels.value.result!.items![index].fullName}",
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.isShowDesignation.value =
                                      !controller.isShowDesignation.value;
                                  if (controller.isShowDesignation.value) {
                                    controller.getDesignation(context);
                                  }
                                },
                                child: CustomTxtField(
                                  hintTxt: Lang.substituteEmployeeDesignation,
                                  enabled: false,
                                  isRequired: true,
                                  textEditingController: controller
                                      .selectSubstituteDesignationField,
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.caretDown,
                                    color: AppColors.textColor,
                                    size: context.screenHeight * 0.015,
                                  ),
                                  hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blackColor),
                                  validator: (String? val) {
                                    if (val!.isEmpty) {
                                      return 'Please select ${Lang.substituteEmployeeDesignation}';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (controller.isShowDesignation.value)
                                Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.homeBG,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: controller.isDesignationLoading.value
                                      ? const MyLoader()
                                      : ListView.builder(
                                          itemCount: controller
                                              .getDesignationModels
                                              .value
                                              .result!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                controller.isShowDesignation
                                                    .value = false;
                                                controller.selectedDesignation
                                                        .value =
                                                    controller
                                                        .getDesignationModels
                                                        .value
                                                        .result![index];
                                                controller
                                                        .selectSubstituteDesignationField
                                                        .text =
                                                    controller
                                                        .selectedDesignation
                                                        .value
                                                        .displayName!;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                        color: AppColors.primary
                                                            .withOpacity(0.3)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ]),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Row(
                                                  children: [
                                                    subText4(
                                                        "${controller.getDesignationModels.value.result![index].displayName}",
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              days(),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.isShowDatePicker.value = true;
                                },
                                child: CustomTxtField(
                                  hintTxt: Lang.dateRange,
                                  isRequired: true,
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.blackColor,
                                  ),
                                  enabled: false,
                                  textEditingController:
                                      controller.dateTxtField,
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.calendarDays,
                                    color: AppColors.borderColor,
                                    size: context.screenHeight * 0.015,
                                  ),
                                  validator: (String? val) {
                                    if (val!.isEmpty) {
                                      return 'Empty ${Lang.dateRange} ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (controller.isShowDatePicker.value)
                                Container(
                                  child: SfDateRangePicker(
                                    onSelectionChanged: _onSelectionChanged,
                                    selectionMode:
                                        DateRangePickerSelectionMode.multiRange,
                                    selectionColor: AppColors.primary,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now(), DateTime.now()),
                                    minDate: DateTime.now(),
                                    confirmText: "OK",
                                    showActionButtons: true,

                                    onSubmit: (value) {
                                      if (value is List<PickerDateRange>) {
                                        for (var range in value) {
                                          DateTime? startDate = range.startDate;
                                          DateTime? endDate = range.endDate;

                                          controller.formattedStartDate =
                                              '${startDate?.toLocal().toIso8601String().split('T').first}';
                                          controller.formattedEndDate = endDate
                                                      ?.toLocal()
                                                      .toIso8601String()
                                                      .split('T')
                                                      .first ==
                                                  null
                                              ? '${startDate?.toLocal().toIso8601String().split('T').first}'
                                              : '${endDate?.toLocal().toIso8601String().split('T').first}';

                                          debugPrint(
                                              "Start Date: ${controller.formattedStartDate}");
                                          debugPrint(
                                              "End Date: ${controller.formattedEndDate}");

                                          controller.dateTxtField.text =
                                              '${formatDate(controller.formattedStartDate)} to ${formatDate(controller.formattedEndDate)}';
                                          controller.isShowDatePicker.value =
                                              false;

                                          controller.getJobHours(context,
                                              fromDate: controller
                                                  .formattedStartDate,
                                              toDate:
                                                  controller.formattedEndDate ??
                                                      controller
                                                          .formattedStartDate);
                                        }
                                      }
                                      // Navigator.pop(context);
                                    },
                                    onCancel: () {
                                      controller.isShowDatePicker.value = false;
                                    },

                                    // Try DateRangePickerSelectionMode.range for range selection
                                  ),
                                ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.isShowLocation.value =
                                      !controller.isShowLocation.value;
                                  if (controller.isShowLocation.value) {
                                    controller.getLocation(context);
                                  }
                                },
                                child: CustomTxtField(
                                  hintTxt: Lang.location,
                                  enabled: false,
                                  isRequired: true,
                                  textEditingController:
                                      controller.locationField,
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.caretDown,
                                    color: AppColors.textColor,
                                    size: context.screenHeight * 0.015,
                                  ),
                                  validator: (String? val) {
                                    if (val!.isEmpty) {
                                      return 'Empty ${Lang.location} ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (controller.isShowLocation.value)
                                Container(
                                  height: 200,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.homeBG,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: controller.isLocationLoading.value
                                      ? const MyLoader()
                                      : ListView.builder(
                                          itemCount: controller
                                              .getLocationModels
                                              .value
                                              .result!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                controller.isShowLocation
                                                    .value = false;
                                                controller.selectedLocation
                                                        .value =
                                                    controller.getLocationModels
                                                        .value.result![index];
                                                controller.locationField.text =
                                                    controller.selectedLocation
                                                        .value.value!;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                        color: AppColors.primary
                                                            .withOpacity(0.3)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ]),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: subText4(
                                                          "${controller.getLocationModels.value.result![index].value}",
                                                          color: AppColors
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              controller.isJobHourLoading.value
                                  ? const SpinKitWave(
                                      color: AppColors.primary,
                                      size: 20.0,
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: context.screenHeight * 0.01,
                                        ),
                                        CustomTxtField(
                                          hintTxt: Lang.jobHours,
                                          textEditingController:
                                              controller.jobHoursTxtField,
                                          validator: (String? val) {
                                            // if (val!.isEmpty) {
                                            //   return 'Empty';
                                            // }

                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: context.screenHeight * 0.01,
                                        ),
                                        CustomTxtField(
                                          hintTxt: Lang.substituteHours,
                                          textEditingController: controller
                                              .substituteHoursTxtField,
                                          validator: (String? val) {
                                            // if (val!.isEmpty) {
                                            //   return 'Empty';
                                            // }

                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: context.screenHeight * 0.01,
                              ),
                              CustomTxtFieldDes(
                                keyboardType: TextInputType.multiline,
                                hintTxt: Lang.reason,
                                // isRequired: true,
                                textEditingController:
                                    controller.reasonTxtField,
                                // validator: (String? val) {
                                //   if (val!.isEmpty) {
                                //     return 'Empty ${Lang.reason}';
                                //   }
                                // },
                              ),
                              SizedBox(
                                height: context.percentHeight * 2.0,
                              ),
                              Obx(() => mainLoading.value
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const MyLoader())
                                  : Column(
                                      children: [
                                        AppElevatedButton(
                                            backgroundColor: AppColors.blueV1,
                                            onPressed: () {
                                              widget.onPressedSubmit!;
                                              controller.submit(context);
                                            },
                                            title: Lang.submit),
                                        SizedBox(
                                          height: context.percentHeight * 1.0,
                                        ),
                                        AppElevatedButton(
                                            backgroundColor: AppColors.redColor,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            title: Lang.cancel),
                                        SizedBox(
                                          height: context.percentHeight * 2.0,
                                        ),
                                      ],
                                    ))
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
        ));
  }

  leaveCount() {
    if (controller.isLeaveCountLoading.value) {
      return const SpinKitWave(
        color: AppColors.primary,
        size: 20.0,
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            leaveCard(context,
                title: Lang.total,
                cont:
                    '${controller.getLeaveContModel.value.result!.totalLeaves}'),
            SizedBox(
              width: context.percentWidth * 1.5,
            ),
            leaveCard(context,
                title: Lang.used,
                cont:
                    '${controller.getLeaveContModel.value.result!.usedLeaves}'),
            SizedBox(
              width: context.percentWidth * 1.5,
            ),
            leaveCard(context,
                title: Lang.remaining,
                cont:
                    '${controller.getLeaveContModel.value.result!.remainingLeaves}'),
          ],
        ),
      );
    }
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

  Widget leaveType() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Text(
                'Leave type',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                ' *',
                style: TextStyle(color: AppColors.redColor),
              ),
            ],
          ),
          value: controller.selectedLeaveType,
          items: controller.leaveTypeList.map((String leaveType) {
            return DropdownMenuItem<String>(
              value: leaveType,
              child: Text(
                leaveType,
                style:
                    const TextStyle(fontSize: 17, color: AppColors.blackColor),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              controller.selectedLeaveType = newValue;
              // _items.indexOf('${newValue}');
            });
            String leaveType =
                controller.selectedLeaveType!.replaceAll(' ', '');
            controller.getLeaveCount(context, leaveType: leaveType);
            debugPrint(
                "=====_selectedValue: ${controller.selectedLeaveType}=======");
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }

  Widget days() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Text(
                'Days',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                '*',
                style: TextStyle(color: AppColors.redColor),
              ),
            ],
          ),
          value: controller.selectedDayType,
          items: controller.daysTypeList.map((String leaveType) {
            return DropdownMenuItem<String>(
              value: leaveType,
              child: Text(
                leaveType,
                style:
                    const TextStyle(fontSize: 17, color: AppColors.blackColor),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              String leaveType = newValue!;
              controller.selectedDayType = leaveType.replaceAll(' ', '');
              debugPrint(
                  "=====_selectedValue11: ${controller.selectedDayType}=======");

              // _items.indexOf('${newValue}');
            });

            // // leaveController.getLeaveCount(context, leaveType: leaveType);
            // debugPrint("=====_selectedValue: ${leaveType}=======");
            // debugPrint("=====_selectedValue: ${controller..selectedDayType},${controller.daysTypeList.indexOf('${newValue}')}=======");
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      // If a single date is selected
      if (args.value is DateTime) {
        controller.selectedDate = args.value.toString();
      }
      // If a range of dates is selected
      else if (args.value is PickerDateRange) {
        controller.dateRange =
            '${args.value.startDate} - ${args.value.endDate ?? 'No end date'}';
        debugPrint("======_dateRange: ${controller.dateRange}======");
      }
    });
  }
}
