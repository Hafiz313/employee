import 'package:employee/consts/assets.dart';
import 'package:employee/views/bank/bank_info_view.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:employee/views/subsititude/substitute_request_view.dart';
import 'package:employee/views/widget/drawer/drawer_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import '../../attendance/attendance_details_view.dart';

import '../../auth/login/controller/login_controller.dart';
import '../../home/controller/switch_company_controller.dart';
import '../../overTime/overtime_request_view.dart';
import '../../paytub/paystub_generator_view.dart';
import 'drawer_menu_item_svg.dart';

class DrawerMenuItems extends StatelessWidget {
  const DrawerMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerMenuItem(
          icon: Image.asset(AppAssets.profileIcon),
          title: 'My Profile',
          onTap: () {
            debugPrint("=====My Profile=====");
          },
        ),
        DrawerMenuItemSvg(
          icon: AppAssets.attendanceIcon,
          title: 'Attendance',
          onTap: () {
            Navigator.pushNamed(context, AttendanceDetailsView.routeName);
          },
        ),
        DrawerMenuItemSvg(
          icon: AppAssets.paystubIcon,
          title: 'Paystub',
          onTap: () {
            Navigator.pushNamed(context, PaystubGeneratorView.routeName);
          },
        ),
        DrawerMenuItemSvg(
          icon: AppAssets.leaveIcon,
          title: 'Leave Request',
          onTap: () {
            Navigator.pushNamed(context, LeaveARequestView.routeName);
          },
        ),
        DrawerMenuItemSvg(
          icon: AppAssets.subsittuteIcon,
          title: 'Substitute Request',
          onTap: () {
            Navigator.pushNamed(context, SubstituteRequestView.routeName);
          },
        ),
        DrawerMenuItemSvg(
          icon: AppAssets.overTimeIcon,
          title: 'Overtime Request',
          onTap: () {
            Navigator.pushNamed(context, OvertimeRequestView.routeName);
          },
        ),
        // DrawerMenuItem(
        //   icon: Image.asset(AppAssets.calenderIcon),
        //   title: 'Calendar/Schedule',
        //   onTap: () {
        //     // Navigator.pushNamed(context, OvertimeRequestView.routeName);
        //   },
        // ),
        DrawerMenuItemSvg(
          icon: AppAssets.bankDetailIcon,
          title: 'Bank Details',
          onTap: () {
            Navigator.pushNamed(context, BankInfoView.routeName);
          },
        ),
        // DrawerMenuItem(
        //   icon: Image.asset(AppAssets.texIcon),
        //   title: 'Tax Documents',
        //   onTap: () {
        //     debugPrint("=====My Profile=====");
        //   },
        // ),
        // DrawerMenuItem(
        //   icon: Image.asset(AppAssets.texIcon),
        //   title: 'W4 Form',
        //   onTap: () {
        //     debugPrint("=====My Profile=====");
        //   },
        // ),
        GetBuilder<SwitchCompanyController>(
          init: SwitchCompanyController(),
          builder: (controller) {
            return Obx(() {
              if (controller.companyList.value!.result!.length < 2) {
                return const SizedBox.shrink();
              }
              return DrawerMenuItem(
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Image.asset(AppAssets.arrowSwitchIcon),
                title: 'Switch Company',
                enabled: !controller.isLoading.value,
                onTap: () {
                  controller.getCompanyList(context);
                },
              );
            });
          },
        ),
      ],
    );
  }
}
