import 'package:employee/networking/api_provider.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/widget/text_fields_des.dart';
import 'package:employee/views/widget/text_fields_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../consts/colors.dart';
import '../../consts/lang.dart';
import '../../utils/DateForm.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';
import '../widget/text_fields.dart';
import '../auth/login/login_view.dart';
import '../auth/Otp/otp_view.dart';
import 'controller/leave_controller.dart';

class LeaveARequestView extends StatefulWidget {
  LeaveARequestView({super.key});
  static const String routeName = '/LeaveARequestView';

  @override
  State<LeaveARequestView> createState() => _LeaveARequestViewState();
}

class _LeaveARequestViewState extends State<LeaveARequestView> {
  LeaveController leaveController = Get.put(LeaveController());
  final _formKey = GlobalKey<FormState>();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      // If a single date is selected
      if (args.value is DateTime) {
        leaveController.selectedDate = args.value.toString();
      }
      // If a range of dates is selected
      else if (args.value is PickerDateRange) {
        leaveController.dateRange =
            '${args.value.startDate} - ${args.value.endDate ?? 'No end date'}';
        debugPrint("======_dateRange: ${leaveController.dateRange}======");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        body: Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
            width: double.infinity,
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
                        headline3(Lang.requestALeave.toUpperCase(),
                            color: AppColors.blue),
                        SizedBox(
                          height: context.screenHeight * 0.015,
                        ),

                        leaveCount(),
                        SizedBox(
                          height: context.percentHeight * 1,
                        ),

                        leaveType(),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            leaveController.isShowDatePicker.value = true;
                          },
                          child: CustomTxtField(
                            hintTxt: Lang.dateRange,
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: AppColors.blackColor),
                            isRequired: true,
                            enabled: false,
                            textEditingController: leaveController.dateTxtField,
                            suffixIcon: InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Icon(
                                FontAwesomeIcons.calendarDays,
                                color: AppColors.borderColor,
                                size: context.screenHeight * 0.02,
                              ),
                            ),
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'Please enter Email';
                              }

                              return null;
                            },
                          ),
                        ),
                        if (leaveController.isShowDatePicker.value)
                          SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode:
                                DateRangePickerSelectionMode.multiRange,
                            selectionColor: AppColors.primary,
                            initialSelectedRange:
                                PickerDateRange(DateTime.now(), DateTime.now()),
                            minDate: DateTime.now(),
                            confirmText: "OK",
                            showActionButtons: true,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              dayFormat: 'd',
                              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                textStyle: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            onSubmit: (value) {
                              if (value is List<PickerDateRange>) {
                                for (var range in value) {
                                  DateTime? startDate = range.startDate;
                                  DateTime? endDate = range.endDate;

                                  leaveController.formattedStartDate =
                                      '${startDate?.toLocal().toIso8601String().split('T').first}';
                                  leaveController.formattedStartDate =
                                      '${startDate?.toLocal().toIso8601String().split('T').first}';
                                  leaveController.formattedEndDate = endDate
                                              ?.toLocal()
                                              .toIso8601String()
                                              .split('T')
                                              .first ==
                                          null
                                      ? '${startDate?.toLocal().toIso8601String().split('T').first}'
                                      : '${endDate?.toLocal().toIso8601String().split('T').first}';

                                  debugPrint(
                                      "Start Date: ${leaveController.formattedStartDate}");
                                  debugPrint(
                                      "End Date: ${leaveController.formattedEndDate}");

                                  leaveController.dateTxtField.text =
                                      '${formatDate(leaveController.formattedStartDate)} to ${formatDate(leaveController.formattedEndDate)}';
                                  leaveController.isShowDatePicker.value =
                                      false;

                                  leaveController.getJobHours(context,
                                      fromDate:
                                          leaveController.formattedStartDate,
                                      toDate: leaveController
                                              .formattedEndDate ??
                                          leaveController.formattedStartDate);
                                }
                              }
                              // Navigator.pop(context);
                            },
                            onCancel: () {
                              leaveController.isShowDatePicker.value = false;
                            },

                            // Try DateRangePickerSelectionMode.range for range selection
                          ),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        jobHour(),
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        days(),
                        // CustomTxtField(
                        //   hintTxt: Lang.day,
                        //   isRequired: true,
                        //   textEditingController: leaveController.daysTxtField,
                        //   suffixIcon: Icon(
                        //     FontAwesomeIcons.caretDown,
                        //     color: AppColors.borderColor,
                        //     size: context.screenHeight * 0.02,
                        //   ),
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
                        SizedBox(
                          height: context.screenHeight * 0.01,
                        ),
                        CustomTxtFieldDes(
                          keyboardType: TextInputType.multiline,
                          hintTxt: Lang.reason,
                          textEditingController: leaveController.reasonTxtField,
                          validator: (String? val) {
                            if (val!.isEmpty) {
                              return 'Please enter Email';
                            }
                          },
                        ),
                        Obx(() => mainLoading.value
                            ? Container(
                                margin: EdgeInsets.only(top: 30),
                                child: MyLoader())
                            : Column(
                                children: [
                                  SizedBox(
                                    height: context.percentHeight * 4.0,
                                  ),
                                  AppElevatedButton(
                                      backgroundColor: AppColors.blueV1,
                                      onPressed: () {
                                        leaveController.leaveRequest(context);
                                      },
                                      title: Lang.submit),
                                  SizedBox(
                                    height: context.percentHeight * 1.0,
                                  ),
                                  AppElevatedButton(
                                      backgroundColor: AppColors.redColor,
                                      onPressed: () {
                                        Get.back();
                                      },
                                      title: Lang.cancel),
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
            ))));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    // Show date picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: leaveController.selectedDateTime ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Update the selected date if the user picks one
    if (picked != null && picked != leaveController.selectedDateTime) {
      setState(() {
        leaveController.selectedDateTime = picked;
        leaveController.dateTxtField.text =
            '${leaveController.selectedDateTime!.toLocal()}'.split(' ')[0];
      });
    }
  }

  Widget leaveCard(BuildContext context,
      {required String title, required String cont}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 1,
            vertical: context.percentHeight * 1),
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
        child: subText4(
          '${title}: $cont',
          color: AppColors.white,
        ),
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
                '*',
                style: TextStyle(color: AppColors.redColor),
              ),
            ],
          ),
          value: leaveController.selectedLeaveType,
          items: leaveController.leaveTypeList.map((String leaveType) {
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
              leaveController.selectedLeaveType = newValue;
              // _items.indexOf('${newValue}');
            });
            String leaveType =
                leaveController.selectedLeaveType!.replaceAll(' ', '');
            leaveController.getLeaveCount(context, leaveType: leaveType);
            debugPrint(
                "=====_selectedValue: ${leaveController.selectedLeaveType}=======");
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
          value: leaveController.selectedDayType,
          items: leaveController.daysTypeList.map((String leaveType) {
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
              leaveController.selectedDayType = newValue;
              // _items.indexOf('${newValue}');
            });
            String leaveType =
                leaveController.selectedDayType!.replaceAll(' ', '');
            // leaveController.getLeaveCount(context, leaveType: leaveType);
            debugPrint("=====_selectedValue: ${leaveType}=======");
            debugPrint(
                "=====_selectedValue: ${leaveController.selectedDayType},${leaveController.daysTypeList.indexOf('${newValue}')}=======");
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }

  leaveCount() {
    if (leaveController.isLeaveCountLoading.value) {
      return const SpinKitWave(
        color: AppColors.primary,
        size: 20.0,
      );
    } else {
      return Row(
        children: [
          leaveCard(context,
              title: Lang.total,
              cont:
                  '${leaveController.getLeaveContModel.value.result!.totalLeaves}'),
          SizedBox(
            width: context.percentWidth * 1.5,
          ),
          leaveCard(context,
              title: Lang.used,
              cont:
                  '${leaveController.getLeaveContModel.value.result!.usedLeaves}'),
          SizedBox(
            width: context.percentWidth * 1.5,
          ),
          leaveCard(context,
              title: Lang.remaining,
              cont:
                  '${leaveController.getLeaveContModel.value.result!.remainingLeaves}'),
        ],
      );
    }
  }

  jobHour() {
    if (leaveController.isJobHourLoading.value) {
      return const SpinKitWave(
        color: AppColors.primary,
        size: 20.0,
      );
    } else {
      return CustomTxtField(
        hintTxt: Lang.jobHours,
        hintStyle: const TextStyle(
            color: AppColors.blackColor, fontWeight: FontWeight.normal),
        textEditingController: leaveController.jobHoursTxtField,
        enabled: false,
        // suffixIcon: Icon(
        //   FontAwesomeIcons.caretDown,
        //   color: AppColors.borderColor,
        //   size: context.screenHeight * 0.02,
        // ),
        validator: (String? val) {
          if (val!.isEmpty) {
            return 'Please enter Email';
          }
          if (!emailExp.hasMatch(val)) {
            return 'Please enter valid Email';
          }
          return null;
        },
      );
    }
  }
}
