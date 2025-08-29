import 'package:employee/consts/lang.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../consts/colors.dart';
import '../../core/models/response/LeaveBalanceListModel.dart';
import '../../utils/DateForm.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';
import 'controller/leave_balance_controller.dart';

class LeaveBalanceView extends StatelessWidget {
  LeaveBalanceView({super.key});
  static const String routeName = '/LeaveHistoryView';

  LeaveBalanceController leaveBalanceController =
      Get.put(LeaveBalanceController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        body: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.percentHeight * 1, vertical: 10),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              7.0), // Adjust the radius as needed
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.all(context.percentHeight * 2),
                              child: CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 15.0,
                                animation: true,
                                percent: leaveBalanceController
                                    .usedTotalLeavePercentage,
                                center: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${leaveBalanceController.usedLeave}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              color: AppColors.primary),
                                        ),
                                        subText5(Lang.leaveBalance,
                                            fontWeight: FontWeight.bold)
                                      ],
                                    ),
                                  ],
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: AppColors.primary,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          context.percentHeight * 1),
                                      decoration: const BoxDecoration(
                                        color: AppColors.textColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.percentWidth * 1,
                                    ),
                                    subText4(Lang.totalLeaves,
                                        color: AppColors.blackColor)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          context.percentHeight * 1),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.percentWidth * 1,
                                    ),
                                    subText4(Lang.usedLeaves,
                                        color: AppColors.blackColor)
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: context.percentHeight * 2,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.percentWidth * 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dynamicCircularPercentIndicator(
                                    context,
                                    percent: leaveBalanceController
                                        .usedCasualLeavePercentage,
                                    progressColor: AppColors.primary,
                                    centerText:
                                        '${leaveBalanceController.usedCasualLeave}',
                                    title: Lang.casualLeaves,
                                  ),
                                  dynamicCircularPercentIndicator(
                                    context,
                                    percent: leaveBalanceController
                                        .usedAnnulLeavePercentage,
                                    progressColor: AppColors.redColor,
                                    centerText:
                                        '${leaveBalanceController.usedAnnulLeave}',
                                    title: Lang.annulLeaves,
                                  ),
                                  dynamicCircularPercentIndicator(
                                    context,
                                    percent: leaveBalanceController
                                        .usedSickLeavePercentage,
                                    progressColor: AppColors.green,
                                    centerText:
                                        '${leaveBalanceController.usedSickLeave}',
                                    title: Lang.sickLeaves,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: context.percentHeight * 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: context.percentHeight * 2,
                      ),
                      leaveHistory(context),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: context.percentHeight * 1),
                    child: AppElevatedButton(
                        width: double.infinity,
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, LeaveARequestView.routeName);
                        },
                        title: Lang.requestALeave),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget tabViewItem(BuildContext context,
      {required String time,
      required String title,
      Color titleColor = AppColors.blackColor,
      Color subColor = AppColors.textColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText5(title, color: titleColor, fontWeight: FontWeight.bold),
        SizedBox(
          height: context.percentHeight * 0.5,
        ),
        subText5('$time', color: subColor, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget tabViewItemV1(BuildContext context,
      {required String time,
      required String time2,
      required String title,
      Color titleColor = AppColors.blackColor,
      Color subColor = AppColors.textColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText5(title, color: titleColor, fontWeight: FontWeight.bold),
        SizedBox(
          height: context.percentHeight * 0.5,
        ),
        subText5('$time', color: subColor, fontWeight: FontWeight.bold),
        subText5('$time2', color: subColor, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget verticalLine(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 6.0),
      color: AppColors.textColor, width: 1, height: context.percentWidth * 10,
    );
  }

  Widget tabWidget(BuildContext context, LeaveBalanceResult leave) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 1.0,
          vertical: context.percentHeight * 1),
      margin: EdgeInsets.only(bottom: context.percentHeight * 1),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tabViewItemV1(context,
              time: leave.fromDate == null ? "" : formatDate(leave.fromDate!),
              time2: leave.toDate == null ? "" : '${formatDate(leave.toDate!)}',
              title: 'Date'),
          verticalLine(context),
          tabViewItem(context,
              time: leave.countForLeaves == null
                  ? ""
                  : '${leave.countForLeaves!}',
              title: '# of Day'),
          verticalLine(context),
          tabViewItem(
            context,
            time: leave.attendenceLeaveType == null
                ? ""
                : '${leave.attendenceLeaveType!}',
            title: 'Type',
          ),
          verticalLine(context),
          tabViewItem(context,
              time: leave.reason == null ? "" : '${leave.reason!}',
              title: 'Reason'),
          verticalLine(context),
          tabViewItem(context,
              time: leave.approvedBy == null ? "" : '${leave.approvedBy!}',
              title: 'Approved by'),
          verticalLine(context),
          tabViewItem(context,
              time: leave.status == null ? "" : '${leave.status!}',
              title: 'Status',
              subColor: AppColors.green),
        ],
      ),
    );
  }

  Widget dynamicCircularPercentIndicator(
    BuildContext context, {
    required double percent,
    required Color progressColor,
    required String centerText,
    required String title,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 22,
          lineWidth: 5,
          animation: true,
          percent: percent,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: progressColor,
          center: Text(centerText),
        ),
        SizedBox(
          height: context.percentHeight * 0.7,
        ),
        subText4(title, fontWeight: FontWeight.bold)
      ],
    );
  }

  Widget leaveHistory(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText1(Lang.leaveHistory,
            color: AppColors.headingTextColor, fontWeight: FontWeight.bold),
        SizedBox(
          height: context.percentHeight * 1,
        ),
        SizedBox(
          child: leaveBalanceController.isLoading.value
              ? const MyLoader()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leaveBalanceController
                      .leaveBalanceList.value.result!.length,
                  itemBuilder: (context, index) {
                    var leave = leaveBalanceController
                        .leaveBalanceList.value.result![index];

                    return tabWidget(context, leave);
                  }),
        ),
        SizedBox(
          height: context.percentHeight * 8,
        ),
      ],
    );
  }
}
