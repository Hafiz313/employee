import 'package:employee/consts/lang.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/attendance/widget/MonthlyAttendance.dart';
import 'package:employee/views/attendance/widget/WeeklyList.dart';
import 'package:employee/views/auth/sing_up/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../core/models/response/attendance_list_models.dart';
import '../../utils/DateForm.dart';
import '../base_view/base_scaffold.dart';
import '../base_view/base_scaffold_auth.dart';
import '../home/controller/home_controller.dart';
import '../leave/leave_balance_view.dart';
import '../widget/buttons.dart';
import '../widget/buttonsV1.dart';
import '../widget/cutom_tabbar_view.dart';
import '../widget/text.dart';
import '../widget/text_fields.dart';
import 'CustomCalendar.dart';
import 'controller/attendancae_controller.dart';

class AttendanceDetailsView extends StatefulWidget {
  const AttendanceDetailsView({super.key});
  static const String routeName = '/AttendanceDetailsView';

  @override
  State<AttendanceDetailsView> createState() => _AttendanceDetailsViewState();
}

class _AttendanceDetailsViewState extends State<AttendanceDetailsView>
    with TickerProviderStateMixin {
  late TabController _monthlyTabController;
  late TabController _calanderTabController;
  AttendanceController attendanceController = Get.put(AttendanceController());
  @override
  void initState() {
    super.initState();
    _monthlyTabController = TabController(length: 2, vsync: this);
    _calanderTabController = TabController(length: 2, vsync: this);
    attendanceController.getAttendanceList(context,
        startDate:
            '${formatDateWithDash(attendanceController.lastWeek.toString())}T14:45:46.603Z',
        endDate:
            '${formatDateWithDash(attendanceController.today.toString())}T14:45:46.603Z');
    attendanceController.getAttendanceDetails(context,
        startDate:
            '${formatDateWithDash(attendanceController.lastMonth.toString())}T14:45:46.603Z',
        endDate:
            '${formatDateWithDash(attendanceController.today.toString())}T14:45:46.603Z');
  }

  var homeController = Get.find<HomeController>();
  @override
  void dispose() {
    _monthlyTabController.dispose();
    _calanderTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        isBackArrow: true,
        body: Obx(
          () => Container(
            padding:
                EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
            child: Column(
              children: [
                attendanceDetails(context),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 3, child: circularProgressView(context)),
                      Expanded(flex: 4, child: calenderAndListView(context)),
                    ],
                  ),
                ),
                _buildPunchInButton(context, homeController)
              ],
            ),
          ),
        ));
  }

  Widget attendanceDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.percentHeight * 2),
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.percentHeight * 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: context.percentWidth * 1.0),
                padding: EdgeInsets.only(
                    left: context.percentWidth * 2.0,
                    right: context.percentWidth * 2.0),
                child: Row(
                  children: [
                    subText1(Lang.attendanceDetail.toUpperCase(),
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: context.percentWidth * 2,
                    right: context.percentHeight * 1),
                child: InkWell(
                  onTap: () {
                    _showDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(
                        FontAwesomeIcons.angleLeft,
                        color: AppColors.white,
                        size: 16,
                      ),
                      Icon(
                        FontAwesomeIcons.calendarDays,
                        color: AppColors.white,
                        size: context.percentWidth * 4.0,
                      ),
                      SizedBox(
                        width: context.percentWidth * 1,
                      ),
                      subText5(
                          '${attendanceController.endDate} - ${attendanceController.startDate}',
                          color: AppColors.white),
                      const Icon(
                        FontAwesomeIcons.angleRight,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: context.percentHeight * 1,
          ),
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
            height: 0.8,
            color: AppColors.white,
          ),
          SizedBox(
            height: context.percentHeight * 1,
          ),
          hoursWidget(context),
          SizedBox(
            height: context.percentHeight * 1,
          ),
        ],
      ),
    );
  }

  Widget hoursCard(BuildContext context,
      {required String time, required String title}) {
    return Column(
      children: [
        subText5(title, color: AppColors.white, fontWeight: FontWeight.bold),
        SizedBox(
          height: context.percentHeight * 0.5,
        ),
        subText5('$time', color: AppColors.white, fontWeight: FontWeight.bold),
      ],
    );
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

  Widget hoursWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          hoursCard(context,
              time: attendanceController.getAttendanceDetailModel.value.result!
                          .attendancePercentage ==
                      null
                  ? '-'
                  : '${double.parse(attendanceController.getAttendanceDetailModel.value.result!.attendancePercentage.toString()).toStringAsFixed(2)} %',
              title: Lang.attendance),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          hoursCard(context,
              time: attendanceController
                          .getAttendanceDetailModel.value.result!.workedHours ==
                      null
                  ? '-'
                  : '${attendanceController.getAttendanceDetailModel.value.result!.workedHours}',
              title: Lang.workedHours),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          hoursCard(context,
              time: attendanceController
                          .getAttendanceDetailModel.value.result!.leaveCount ==
                      null
                  ? '-'
                  : '${attendanceController.getAttendanceDetailModel.value.result!.leaveCount.toStringAsFixed(0)}',
              title: Lang.leaves),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          hoursCard(context,
              time: attendanceController
                          .getAttendanceDetailModel.value.result!.overTime ==
                      null
                  ? '0:00 Hrs'
                  : '${attendanceController.getAttendanceDetailModel.value.result!.overTime}',
              title: Lang.overtime),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          hoursCard(context,
              time: attendanceController
                          .getAttendanceDetailModel.value.result!.late ==
                      null
                  ? '0:00 Hrs'
                  : '${attendanceController.getAttendanceDetailModel.value.result!.late}',
              title: Lang.late),
        ],
      ),
    );
  }

  Widget verticalLine(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 6.0),
      color: AppColors.textColor, width: 1, height: context.percentWidth * 10,
    );
  }

  Widget tabWidget(BuildContext context, AttendanceListResult data) {
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
          tabViewItem(context,
              time: formatDate(data.date.toString()),
              title: '${getDayOfWeek(data.date.toString())}'),
          verticalLine(context),
          tabViewItem(context,
              time:
                  '${data.firstPunchIn != null ? getTime(data.firstPunchIn) : '--:--'}/${data.lastPunchOut != null ? getTime(data.lastPunchOut) : '--:--'}',
              title: 'Punch In/Out'),
          verticalLine(context),
          tabViewItem(context,
              time: '${data.late != null ? "${data.late}" : '0:00'}',
              title: Lang.late,
              titleColor: AppColors.redColor,
              subColor: AppColors.redColor),
          verticalLine(context),
          tabViewItem(context,
              time:
                  '${data.workedHour != null ? "${data.workedHour}" : '0'} Hrs',
              title: Lang.workedHrs),
          verticalLine(context),
          tabViewItem(context,
              time: '${data.late != null ? "${data.late}" : '0:00'} Hrs',
              title: Lang.overtime),
          verticalLine(context),
          tabViewItem(context,
              time:
                  '${data.empAttendenceStatus != null ? "${data.empAttendenceStatus}" : '-----'}',
              title: Lang.status),
        ],
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      // If a single date is selected
      if (args.value is DateTime) {
        // leaveController.selectedDate = args.value.toString();
      }
      // If a range of dates is selected
      else if (args.value is PickerDateRange) {
        // leaveController.dateRange = '${args.value.startDate} - ${args.value.endDate ?? 'No end date'}';

        attendanceController.startDate.value = '${args.value.startDate}';
        attendanceController.endDate.value = '${args.value.endDate}';

        debugPrint(
            "======_dateRange: ${args.value.startDate} - ${args.value.endDate ?? 'No end date'}======");
      }
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 300,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.multiRange,
              selectionColor: AppColors.primary,
              initialSelectedRange:
                  PickerDateRange(DateTime.now(), DateTime.now()),
              // minDate: DateTime.now(),
              maxDate: DateTime.now(),
              confirmText: "OK",
              showActionButtons: true,

              onSubmit: (value) {
                if (value is List<PickerDateRange>) {
                  for (var range in value) {
                    DateTime? startDate = range.startDate;
                    DateTime? endDate = range.endDate;

                    String formattedStartDate =
                        '${startDate?.toLocal().toIso8601String().split('T').first}';
                    String formattedEndDate = endDate
                                ?.toLocal()
                                .toIso8601String()
                                .split('T')
                                .first ==
                            null
                        ? '${startDate?.toLocal().toIso8601String().split('T').first}'
                        : '${endDate?.toLocal().toIso8601String().split('T').first}';

                    debugPrint("Start Date: $formattedStartDate");
                    debugPrint("End Date: $formattedEndDate");

                    attendanceController.startDate.value = formattedStartDate;
                    attendanceController.endDate.value = formattedEndDate;
                    attendanceController.getAttendanceDetails(context,
                        startDate:
                            '${formatDateWithDash(formattedStartDate.toString())}T14:45:46.603Z',
                        endDate:
                            '${formatDateWithDash(formattedEndDate.toString())}T14:45:46.603Z');
                  }
                }
                Navigator.pop(context);
              },
              onCancel: () {
                Navigator.pop(context);
              },

              // Try DateRangePickerSelectionMode.range for range selection
            ),
          ),
        );
      },
    );
  }

  Widget calenderAndListView(BuildContext context) {
    return SizedBox(
      child: CustomTabView(
        tabController: _monthlyTabController,
        onTap: (index) {
          if (index == 1) {
            attendanceController.getAttendanceList(context,
                startDate:
                    '${formatDateWithDash(attendanceController.lastMonth.toString())}T14:45:46.603Z',
                endDate:
                    '${formatDateWithDash(attendanceController.today.toString())}T14:45:46.603Z');
            _calanderTabController.index = 1;
          }
        },
        tabLabels: [
          Lang.tabView.toUpperCase(),
          Lang.calenderView.toUpperCase()
        ],
        tabViews: [
          if (attendanceController.isListLoading.value)
            const MyLoader()
          else
            Container(
              margin:
                  EdgeInsets.only(top: context.percentHeight * 1.5, bottom: 20),
              // height: 100.0 *
              //     attendanceController.getAttendanceListModel.value
              //         .attendanceResultList!.length,
              // height: 600,
              child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceController.getAttendanceListModel.value
                      .attendanceResultList!.length,
                  itemBuilder: (context, index) {
                    var att = attendanceController.getAttendanceListModel.value
                        .attendanceResultList![index];
                    return tabWidget(context, att);
                  }),
            ),
          const CustomCalendar()
        ],
      ),
    );
  }

  Widget circularProgressView(BuildContext context) {
    return SizedBox(
      height: 210,
      child: CustomTabView(
        tabController: _calanderTabController,
        onTap: (index) {
          if (index == 0) {
            _monthlyTabController.index = 0;
            attendanceController.getAttendanceList(context,
                startDate:
                    '${formatDateWithDash(attendanceController.lastWeek.toString())}T14:45:46.603Z',
                endDate:
                    '${formatDateWithDash(attendanceController.today.toString())}T14:45:46.603Z');
          } else if (index == 1) {
            attendanceController.getAttendanceList(context,
                startDate:
                    '${formatDateWithDash(attendanceController.lastMonth.toString())}T14:45:46.603Z',
                endDate:
                    '${formatDateWithDash(attendanceController.today.toString())}T14:45:46.603Z');
          }
        },
        tabLabels: [Lang.weekly.toUpperCase(), Lang.monthly.toUpperCase()],
        tabViews: const [WeeklyList(), MonthlyAttendance()],
      ),
    );
  }

  Widget _buildPunchInButton(BuildContext context, HomeController controller) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.percentWidth * 2,
        vertical: context.percentHeight * 2,
      ),
      child: AppElevatedButton(
        backgroundColor:
            controller.isPunchIn.value ? AppColors.green : AppColors.redColor,
        onPressed: () {
          // Use the new controller method for handling punch in/out
          controller.handlePunchInOut(context);
        },
        title: controller.isPunchIn.value ? Lang.punchIn : Lang.punchOut,
      ),
    );
  }
}
