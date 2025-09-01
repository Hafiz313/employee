import 'package:employee/utils/percentage_size_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../consts/assets.dart';
import '../../consts/colors.dart';
import '../../consts/lang.dart';
import '../../core/models/response/DashBoardModel.dart';
import '../attendance/attendance_details_view.dart';
import '../leave/leave_a_request_view.dart';
import '../leave/leave_balance_view.dart';
import '../paytub/paystub_generator_view.dart';
import '../quiz_results/results_view.dart';
import '../subsititude/substitute_request_view.dart';
import '../trainingAndCourses/training_view.dart';
import '../widget/buttonsV1.dart';
import '../widget/text.dart';

Widget profile(
  BuildContext context, {
  required DashBoardModel data,
  required Function() onPressPunchIn,
  required bool isPunchIn,
  required hour,
  required mint,
  required sec,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: context.percentHeight * 2),
    decoration: BoxDecoration(
        color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: context.percentWidth * 1.0),
              padding: EdgeInsets.only(
                  left: context.percentWidth * 4.0,
                  right: context.percentWidth * 4.0),
              child: Row(
                children: [
                  Container(
                    height: context.percentHeight * 10,
                    width: context.percentWidth * 10,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(AppAssets.profile)),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1)),
                  ),
                  SizedBox(
                    width: context.percentWidth * 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subText5(Lang.welcome,
                          color: AppColors.white,
                          fontWeight: FontWeight.normal),
                      Row(
                        children: [
                          subText1(data.result?.name ?? "---",
                              color: AppColors.white,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      subText5(data.result?.designation ?? '--',
                          color: AppColors.white,
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: context.percentWidth * 2,
                  right: context.percentHeight * 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        FontAwesomeIcons.calendarDays,
                        color: AppColors.white,
                        size: context.percentWidth * 4.0,
                      ),
                      SizedBox(
                        width: context.percentWidth * 1,
                      ),
                      subText4(
                          '${DateFormat('MM/dd/yyyy').format(DateTime.now())}',
                          color: AppColors.white)
                    ],
                  ),
                  AppElevatedButtonV1(
                      backgroundColor: AppColors.green,
                      onPressed: onPressPunchIn,
                      title: isPunchIn ? Lang.punchIn : Lang.punchOut),
                ],
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 1.0),
          height: 0.8,
          color: AppColors.borderColor,
        ),
        SizedBox(
          height: context.percentHeight * 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: context.percentWidth * 1.5),
              padding: EdgeInsets.symmetric(
                  horizontal: context.percentWidth * 2.0,
                  vertical: context.percentHeight * 1.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: AppColors.white,
                    size: context.percentWidth * 6.0,
                  ),
                  SizedBox(
                    width: context.percentWidth * 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subText4(Lang.punchInAt,
                          color: AppColors.white, fontWeight: FontWeight.w600),
                      subText5(
                          (data.result!.punchInTime == null)
                              ? ""
                              : '${DateFormat('hh:mm a').format(DateTime.parse(data.result!.punchInTime.toString()))} ${DateFormat('EEEE').format(DateTime.parse(data.result!.punchInTime.toString()))} ${DateFormat('MM/dd/yyyy').format(DateTime.parse(data.result!.punchInTime.toString()))}',
                          // subText5('HH:MM PM Day, mm/dd/yyyy',
                          color: AppColors.white,
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  timeCard(context,
                      time: hour.toString().length < 2 ? '0${hour}' : '${hour}',
                      title: Lang.hours),
                  SizedBox(
                    width: context.percentWidth * 2,
                  ),
                  timeCard(context,
                      time: mint.toString().length < 2 ? '0${mint}' : '${mint}',
                      title: Lang.minutes),
                  SizedBox(
                    width: context.percentWidth * 2,
                  ),
                  timeCard(context,
                      time: sec.toString().length < 2 ? '0${sec}' : '${sec}',
                      title: Lang.seconds),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 1,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
          height: 0.8,
          color: AppColors.borderColor,
        ),
        SizedBox(
          height: context.percentHeight * 1,
        ),
        hoursWidget(context, data: data),
      ],
    ),
  );
}

Widget timeCard(BuildContext context,
    {required String time, required String title}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 2.5,
            vertical: context.percentHeight * 0.5),
        decoration: BoxDecoration(
            color: const Color(0xFFd2d4ff),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          time,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      SizedBox(
        height: context.percentHeight * 0.5,
      ),
      Text(
        title,
        style: TextStyle(
            color: AppColors.white, fontSize: 8.0, fontWeight: FontWeight.w300),
      ),
    ],
  );
}

Widget hoursCard(BuildContext context,
    {required String time, required String title}) {
  return Column(
    children: [
      subText5(title, color: AppColors.white),
      SizedBox(
        height: context.percentHeight * 0.5,
      ),
      subText5('$time ${Lang.hrs}',
          color: AppColors.white, fontWeight: FontWeight.bold),
    ],
  );
}

Widget hoursWidget(
  BuildContext context, {
  required DashBoardModel data,
}) {
  // Safety check for null data
  if (data.result?.workHoursDetails == null) {
    return Container(
      height: context.percentHeight * 8,
      child: Center(
        child: subText4('No work hours data available', color: AppColors.white),
      ),
    );
  }

  final workHours = data.result!.workHoursDetails!;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      hoursCard(context,
          time: workHours.totalHours?.toStringAsFixed(2) ?? '0.00',
          title: Lang.workHours),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        color: AppColors.white,
        width: 1,
        height: context.percentWidth * 10,
      ),
      hoursCard(context,
          time: workHours.remaining?.toStringAsFixed(2) ?? '0.00',
          title: Lang.remaining),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        color: AppColors.white,
        width: 1,
        height: context.percentWidth * 10,
      ),
      hoursCard(context,
          time: workHours.overtime?.toStringAsFixed(2) ?? '0.00',
          title: Lang.overtime),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        color: AppColors.white,
        width: 1,
        height: context.percentWidth * 10,
      ),
      hoursCard(context,
          time: workHours.breakTime?.toStringAsFixed(2) ?? '0.00',
          title: Lang.brk),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        color: AppColors.white,
        width: 1,
        height: context.percentWidth * 10,
      ),
      hoursCard(context,
          time: workHours.late?.toStringAsFixed(2) ?? '0.00', title: Lang.late),
    ],
  );
}

Widget leaveBalance(BuildContext context, {required DashBoardModel data}) {
  return Container(
    child: Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0), // Set the radius here
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.percentHeight * 1,
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                subText1(Lang.leaveBalance,
                    color: AppColors.blackColor, fontWeight: FontWeight.bold),
                InkWell(
                  onTap: () {
                    // homeController.getDashboard(context);
                    Navigator.pushNamed(context, LeaveARequestView.routeName);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: context.percentHeight * 0.5,
                        horizontal: context.percentWidth * 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE30461),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: subText4(Lang.leaveRequest,
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: context.percentHeight * 2,
          ),
          leaveWidget(context, data: data),
          SizedBox(
            height: context.percentHeight * 3,
          ),
        ],
      ),
    ),
  );
}

Widget leaveCard(BuildContext context,
    {required String time, required String title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      subText5(title, color: AppColors.blackColor, align: TextAlign.start),
      SizedBox(
        height: context.percentHeight * 0.5,
      ),
      Row(
        children: [
          subText2(time,
              color: AppColors.blackColor, fontWeight: FontWeight.bold),
        ],
      ),
    ],
  );
}

Widget leaveWidget(BuildContext context, {required DashBoardModel data}) {
  // Safety check for null data
  if (data.result?.leaves == null) {
    return Container(
      height: context.percentHeight * 8,
      child: Center(
        child: subText4('No leave data available', color: AppColors.blackColor),
      ),
    );
  }

  final leaves = data.result!.leaves!;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leaveCard(context,
            time: leaves.totalLeaves?.toStringAsFixed(0) ?? '0',
            title: Lang.totalLeaves),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          color: AppColors.borderColor,
          width: 1,
          height: context.percentWidth * 10,
        ),
        leaveCard(context,
            time: leaves.usedLeaves?.toStringAsFixed(0) ?? '0',
            title: Lang.leavesTaken),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          color: AppColors.borderColor,
          width: 1,
          height: context.percentWidth * 10,
        ),
        leaveCard(context,
            time: leaves.remainingLeaves?.toStringAsFixed(0) ?? '0',
            title: Lang.remaining),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          color: AppColors.borderColor,
          width: 1,
          height: context.percentWidth * 10,
        ),
        leaveCard(context,
            time: leaves.leaveRequest?.toStringAsFixed(0) ?? '0',
            title: Lang.leaveRequest),
      ],
    ),
  );
}

Widget iconsWidget(BuildContext context) {
  return GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 5.0,
    childAspectRatio: 1.8,
    children: [
      iconsItems(context,
          svgRef: AppAssets.attendanceHistory,
          title: Lang.attendanceHistory, onTap: () {
        Navigator.pushNamed(context, AttendanceDetailsView.routeName);
      }),
      iconsItems(context,
          svgRef: AppAssets.leaveBalance, title: Lang.leaveBalance, onTap: () {
        Navigator.pushNamed(context, LeaveBalanceView.routeName);
      }),
      iconsItems(context, svgRef: AppAssets.paystub, title: Lang.paystub,
          onTap: () {
        Navigator.pushNamed(context, PaystubGeneratorView.routeName);
      }),
      iconsItems(context,
          svgRef: AppAssets.substituteRequests,
          title: Lang.substituteRequests, onTap: () {
        Navigator.pushNamed(context, SubstituteRequestView.routeName);
      }),
      iconsItems(context,
          svgRef: AppAssets.trainingCourses,
          title: Lang.trainingCourses, onTap: () {
        Navigator.pushNamed(context, TrainingView.routeName);
      }),
      iconsItems(context,
          svgRef: AppAssets.quizResults, title: Lang.quizResults, onTap: () {
        Navigator.pushNamed(context, ResultView.routeName);
      }),
    ],
  );
}

Widget iconsItems(BuildContext context,
    {required String svgRef,
    required String title,
    required GestureTapCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(
          bottom: BorderSide(
            color: AppColors.green, // Border color
            width: 3.0, // Border width
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: context.percentHeight * 1,
          ),
          SvgPicture.asset(
            svgRef,
            width: context.percentWidth * 7.5,
            color: AppColors.white,
          ),
          SizedBox(
            height: context.percentHeight * 1,
          ),
          subText5(title, color: AppColors.white),
        ],
      ),
    ),
  );
}

Widget announcementsNotifications(
  BuildContext context, {
  required DashBoardModel data,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
    decoration: BoxDecoration(
        color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            subText1(Lang.announcementsNotifications,
                color: AppColors.white, fontWeight: FontWeight.bold),
          ],
        ),
        SizedBox(
          height: context.percentWidth * 1,
        ),
        Row(
          children: [
            SizedBox(
              width: context.percentWidth * 1,
            ),
            const Icon(
              FontAwesomeIcons.angleLeft,
              color: AppColors.white,
              size: 15,
            ),
            SizedBox(
              width: context.percentWidth * 1,
            ),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: context.percentWidth * 3),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)),
                constraints: BoxConstraints(
                  minHeight: context.percentHeight * 15,
                ),
                child: SizedBox(
                  height: context.percentHeight * 15,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data.result?.announcements?.length ?? 0,
                      itemBuilder: (context, index) {
                        // Safety check for data
                        if (data.result?.announcements == null ||
                            data.result!.announcements!.isEmpty ||
                            index >= data.result!.announcements!.length) {
                          return Container(
                            width: context.percentWidth * 80,
                            child: Column(
                              children: [
                                SizedBox(height: context.percentWidth * 1),
                                subText4('No announcements available',
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w500),
                              ],
                            ),
                          );
                        }

                        final announcement = data.result!.announcements![index];

                        return Container(
                            width: context.percentWidth * 80,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context.percentWidth * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: context.percentHeight * 5,
                                          width: context.percentWidth * 10,
                                          decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      AppAssets.profile)),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.white,
                                                  width: 1)),
                                        ),
                                        SizedBox(
                                          width: context.percentWidth * 1,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            subText4("${announcement.name}",
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w500),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subText5(announcement.date != null
                                        ? '${DateFormat('hh:mm a').format(DateTime.parse(announcement.date.toString()))}  | ${DateFormat('MMM dd, yyyy').format(DateTime.parse(announcement.date.toString()))}'
                                        : ''),
                                  ],
                                ),
                                SizedBox(
                                  height: context.percentWidth * 1,
                                ),
                                Row(
                                  children: [
                                    subText5(
                                        '${announcement.name ?? Lang.policyName} : ',
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold),
                                    subText5(
                                        '${announcement.subject ?? 'No subject'}',
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.normal),
                                  ],
                                ),
                                SizedBox(
                                  height: context.percentWidth * 1,
                                ),
                                subText4('${announcement.description ?? ''}',
                                    color: AppColors.textColor,
                                    align: TextAlign.start,
                                    fontWeight: FontWeight.normal),
                              ],
                            ));
                      }),
                ),
              ),
            ),
            SizedBox(
              width: context.percentWidth * 1,
            ),
            const Icon(
              FontAwesomeIcons.angleRight,
              color: AppColors.white,
              size: 15,
            ),
            SizedBox(
              width: context.percentWidth * 1,
            ),
          ],
        )
      ],
    ),
  );
}
