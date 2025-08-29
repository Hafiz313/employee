import 'package:employee/consts/colors.dart';
import 'package:employee/utils/custom_dialog.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller/attendancae_controller.dart';
import '../../../core/models/response/attendance_list_models.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  late AttendanceController attendanceController;

  @override
  void initState() {
    super.initState();
    attendanceController = Get.find<AttendanceController>();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  // Process attendance data to create a map of dates with their statuses
  Map<DateTime, List<String>> _getAttendanceStatusMap() {
    final Map<DateTime, List<String>> attendanceMap = {};

    if (attendanceController
            .getAttendanceListModel.value.attendanceResultList !=
        null) {
      debugPrint(
          'Processing ${attendanceController.getAttendanceListModel.value.attendanceResultList!.length} attendance records');

      for (var attendance in attendanceController
          .getAttendanceListModel.value.attendanceResultList!) {
        if (attendance.date != null && attendance.empAttendenceStatus != null) {
          try {
            // Parse the date string to DateTime
            DateTime date = DateTime.parse(attendance.date!);
            // Create a key with just year, month, day to group by date
            DateTime dateKey = DateTime(date.year, date.month, date.day);

            if (attendanceMap.containsKey(dateKey)) {
              // If date already exists, add the status to the list
              attendanceMap[dateKey]!.add(attendance.empAttendenceStatus!);
            } else {
              // If date doesn't exist, create new list with this status
              attendanceMap[dateKey] = [attendance.empAttendenceStatus!];
            }

            debugPrint(
                'Added status: ${attendance.empAttendenceStatus} for date: ${dateKey.toString().split(' ')[0]}');
          } catch (e) {
            debugPrint('Error parsing date: ${attendance.date} - $e');
          }
        }
      }

      debugPrint('Total dates with attendance: ${attendanceMap.length}');
    }

    return attendanceMap;
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'leave':
        return AppColors.redColor;
      case 'holiday':
        return AppColors.green;
      case 'half_day':
        return AppColors.blackColor;
      case 'present':
        return AppColors.primary;
      default:
        return AppColors.yellow; // Default color for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_focusedMonth);
    final monthName = DateFormat.yMMMM().format(_focusedMonth);

    return Obx(() {
      final attendanceMap = _getAttendanceStatusMap();

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: context.percentHeight * 1,
            ),
            Card(
              color: AppColors.white,
              elevation: 5,
              child: Column(
                children: [
                  // Header
                  buildLegend(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.chevron_left),
                      //   onPressed: _goToPreviousMonth,
                      // ),
                      subText5(monthName,
                          color: AppColors.textColor, fontSize: 16),
                      // IconButton(
                      //   icon: const Icon(Icons.chevron_right),
                      //   onPressed: _goToNextMonth,
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Weekdays
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map((day) => Expanded(
                              child: Center(
                                child: subText4(day,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: context.percentHeight * 1,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: daysInMonth.length,
                    itemBuilder: (context, index) {
                      final date = daysInMonth[index];
                      final statuses = attendanceMap[date] ?? [];

                      return Column(
                        children: [
                          subText4('${date.day}',
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold),
                          const SizedBox(
                            height: 10,
                          ),
                          // Display multiple dots for multiple statuses
                          if (statuses.isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: statuses.take(3).map((status) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: _getColorForStatus(status),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                // Show indicator if there are more than 3 statuses
                                if (statuses.length > 3)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 2,
                                    height: 2,
                                    decoration: const BoxDecoration(
                                      color: AppColors.textColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            )
                          else
                            const SizedBox(
                                height: 6), // Empty space for no dots
                        ],
                      );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildLegend() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 3,
          vertical: context.percentHeight * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildLegendItem(AppColors.primary, 'Present'),
          const SizedBox(width: 16),
          _buildLegendItem(AppColors.redColor, 'Leave'),
          const SizedBox(width: 16),
          _buildLegendItem(AppColors.green, 'Holiday'),
          const SizedBox(width: 16),
          _buildLegendItem(AppColors.blackColor, 'Half Day'),
          const SizedBox(width: 16),
          _buildLegendItem(AppColors.yellow, 'Absent'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        subText5(label),
      ],
    );
  }
}
