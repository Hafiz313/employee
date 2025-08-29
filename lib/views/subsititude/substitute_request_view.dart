import 'package:employee/consts/lang.dart';
import 'package:employee/utils/DateForm.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:employee/views/subsititude/widget/RequestSubstituteDialog.dart';
import 'package:employee/views/subsititude/widget/SubstituteRequestDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../consts/colors.dart';
import '../../core/models/response/SubFormDetailsModel.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';
import 'controller/substitute_controller.dart';

class SubstituteRequestView extends StatelessWidget {
  SubstituteRequestView({super.key});
  static const String routeName = '/SubstituteRequestView';

  SubstituteController substituteController = Get.put(SubstituteController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: AppColors.homeBG,
        body: Obx(
          () => Container(
            padding:
                EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
            child: Column(
              children: [
                SizedBox(
                  height: context.percentHeight * 2,
                ),
                substituteRequestFrom(context),
                SizedBox(
                  height: context.percentHeight * 2,
                ),
                substituteRequestTo(context),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: context.percentHeight * 1),
                  child: AppElevatedButton(
                      width: double.infinity,
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        substituteController.selectSubstituteEmployeeField
                            .clear();
                        substituteController.selectSubstituteDesignationField
                            .clear();
                        substituteController.dateTxtField.clear();
                        substituteController.locationField.clear();
                        substituteController.jobHoursTxtField.clear();
                        substituteController.reasonTxtField.clear();
                        substituteController.substituteHoursTxtField.clear();
                        showDialog(
                          context: context,
                          builder: (context) => RequestSubstituteDialog(
                            onPressedSubmit: () {
                              debugPrint("========onPressedSubmit========");
                              // Navigator.pop(context);
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => SubstituteRequestDialog(
                              //     onPressedAccept: () => Navigator.pop(context),
                              //     onPressedDecline: () {
                              //       debugPrint(
                              //           "========onPressedSubmit========");
                              //       Navigator.pop(context);
                              //     },
                              //   ),
                              // );
                            },
                          ),
                        );
                        // Navigator.pushNamed(context,  LeaveARequestView.routeName);
                      },
                      title: Lang.substituteRequest),
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

  Widget tabWidget(BuildContext context, SubFormResult sub) {
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
              time: sub.fromDate == null ? "" : '${formatDate(sub.fromDate!)}',
              time2: sub.toDate == null ? "" : '${formatDate(sub.toDate!)}',
              title: 'Date'),
          verticalLine(context),
          tabViewItem(context, time: '${sub.name!}', title: 'Name'),
          verticalLine(context),
          tabViewItem(
            context,
            time: sub.departmentName == null ? "" : '${sub.departmentName!}',
            title: 'Depart.',
          ),
          verticalLine(context),
          tabViewItem(context,
              time: sub.fromTime == null ? "" : '${getTime(sub.fromTime!)}',
              title: 'Subs. Time'),
          verticalLine(context),
          tabViewItem(context,
              time: sub.substituteHours != null
                  ? '${removeMinus(sub.substituteHours.toString())}'
                  : '',
              title: 'Subs. Hours'),
          verticalLine(context),
          tabViewItem(context,
              time:
                  sub.substituteStatus != null ? '${sub.substituteStatus}' : "",
              title: 'Status',
              subColor: AppColors.green),
        ],
      ),
    );
  }

  Widget tabWidgetV1(BuildContext context) {
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
              time: 'dd/mm/yy', time2: 'dd/mm/yy', title: 'Date'),
          verticalLine(context),
          tabViewItem(context, time: 'John Doe', title: 'Name'),
          verticalLine(context),
          tabViewItem(
            context,
            time: 'IT',
            title: 'Depart.',
          ),
          verticalLine(context),
          tabViewItem(context, time: '10:00', title: 'Subs. Time'),
          verticalLine(context),
          tabViewItem(context, time: 'HH:MM', title: 'Subs. Hours'),
          verticalLine(context),
          tabViewItem(context,
              time: 'Accepted', title: 'Status', subColor: AppColors.green),
        ],
      ),
    );
  }

  Widget substituteRequestFrom(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText1(Lang.substituteRequestFrom,
              color: AppColors.headingTextColor, fontWeight: FontWeight.bold),
          SizedBox(
            height: context.percentHeight * 1,
          ),
          Expanded(
            child: substituteController.isFromLoading.value
                ? const MyLoader()
                : substituteController
                        .getSubstituteFormModel.value.result!.isEmpty
                    ? Container(
                        child: Center(
                            child: subText4(Lang.recordNotFound,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      )
                    : ListView.builder(
                        itemCount: substituteController
                            .getSubstituteFormModel.value.result!.length,
                        itemBuilder: (context, index) {
                          var a = substituteController
                              .getSubstituteFormModel.value.result![index];
                          return tabWidget(context, a);
                        }),
          ),
        ],
      ),
    );
  }

  Widget substituteRequestTo(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subText1(Lang.substituteRequestTo,
              color: AppColors.headingTextColor, fontWeight: FontWeight.bold),
          SizedBox(
            height: context.percentHeight * 1,
          ),
          Expanded(
            child: substituteController.isToLoading.value
                ? const MyLoader()
                : substituteController
                        .getSubstituteToModel.value.result!.isEmpty
                    ? Container(
                        child: Center(
                            child: subText4(Lang.recordNotFound,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      )
                    : ListView.builder(
                        itemCount: substituteController
                            .getSubstituteToModel.value.result!.length,
                        itemBuilder: (context, index) {
                          var a = substituteController
                              .getSubstituteToModel.value.result![index];
                          return tabWidget(context, a);
                        }),
          ),
        ],
      ),
    );
  }
}
