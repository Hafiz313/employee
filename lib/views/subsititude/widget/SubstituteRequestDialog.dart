import 'package:employee/consts/colors.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/buttons.dart';
import '../../widget/text_fields.dart';
import '../../widget/text_fields_des.dart';

class SubstituteRequestDialog extends StatelessWidget {
  final Function()? onPressedAccept;
  final Function()? onPressedDecline;
  SubstituteRequestDialog(
      {super.key, this.onPressedAccept, this.onPressedDecline});

  final _formKey = GlobalKey<FormState>();
  final dateTxtField = TextEditingController();
  final selectSubstituteEmployeeField = TextEditingController();
  final selectSubstituteDesignationField = TextEditingController();
  final locationField = TextEditingController();
  final jobHoursTxtField = TextEditingController();
  final substituteHoursTxtField = TextEditingController();
  final reasonTxtField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            child: subText2(Lang.substituteRequest, color: AppColors.white),
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
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.percentWidth * 1.0),
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
                                  border: Border.all(
                                      color: AppColors.white, width: 1)),
                            ),
                            SizedBox(
                              width: context.percentWidth * 1,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headline5('John doe',
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                                subText5('Design Department',
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.normal),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.7,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        height: context.screenHeight * 0.01,
                      ),
                      headingText(context,
                          heading: Lang.location, title: 'Branch 1'),
                      SizedBox(
                        height: context.screenHeight * 0.01,
                      ),
                      headingText(context,
                          heading: Lang.time, title: 'HH:MM pm To HH:MM pm'),
                      SizedBox(
                        height: context.screenHeight * 0.01,
                      ),
                      headingText(context,
                          heading: Lang.substituteDate, title: 'mm/dd/yyyy'),
                      SizedBox(
                        height: context.screenHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          subText4(Lang.reasonForTheSubstituteRequest,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(
                        height: context.screenHeight * 0.01,
                      ),
                      CustomTxtFieldDes(
                        keyboardType: TextInputType.multiline,
                        hintTxt: Lang.urgentPieceOfWork,
                        maxLines: 3,
                        textEditingController: reasonTxtField,
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Please enter Email';
                          }
                        },
                      ),
                      SizedBox(
                        height: context.percentHeight * 2.0,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 8),
                          child: AppElevatedButton(
                              backgroundColor: AppColors.blueV1,
                              onPressed: onPressedDecline,
                              title: Lang.accept)),
                      SizedBox(
                        height: context.percentHeight * 1.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.percentWidth * 8),
                        child: AppElevatedButton(
                            backgroundColor: AppColors.redColor,
                            onPressed: onPressedDecline,
                            title: Lang.decline),
                      ),
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
    );
  }

  Widget headingText(BuildContext context,
      {required String heading, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        subText4(heading,
            color: AppColors.primary, fontWeight: FontWeight.bold),
        subText5(title, color: AppColors.textColor),
      ],
    );
  }
}
