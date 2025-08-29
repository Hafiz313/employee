import 'package:carousel_slider/carousel_slider.dart';
import 'package:employee/consts/lang.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:employee/views/quiz_results/quiz_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../consts/assets.dart';
import '../../consts/colors.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/search_text_fields.dart';
import '../widget/text.dart';
import '../trainingAndCourses/course_details_view.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});
  static const String routeName = '/ResultView';

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final searchTxtField = TextEditingController();
  String? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              quiz(context),
              SizedBox(
                height: context.percentHeight * 1,
              ),
              list(
                context,
              ),
              btn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget coursesItem(BuildContext context,
      {required String time, required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText6(title, color: AppColors.white, fontWeight: FontWeight.bold),
        SizedBox(
          height: context.percentHeight * 0.5,
        ),
        subText4('$time', color: AppColors.white, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget quiz(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
            child: Row(
              children: [
                Expanded(
                    child: Row(children: [
                  headline5(Lang.quiz, color: AppColors.white),
                  SizedBox(
                    width: context.percentWidth * 2,
                  ),
                  const Icon(
                    FontAwesomeIcons.caretDown,
                    color: AppColors.white,
                    size: 13,
                  )
                ])),
                Expanded(
                  child: SearchTxtField(
                    hintTxt: Lang.search,
                    textEditingController: searchTxtField,
                    suffixIcon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: AppColors.white,
                      size: context.screenHeight * 0.02,
                    ),
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Please enter Email';
                      }
                      if (!emailExp.hasMatch(val)) {
                        return 'Please enter valid Email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: context.percentHeight * 2,
          ),
          coursesTextWidget(context),
          SizedBox(
            height: context.percentHeight * 2,
          ),
        ],
      ),
    );
  }

  Widget coursesTextWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          coursesItem(context, time: '10', title: Lang.quizAttempted),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '3', title: Lang.quizFailed),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '7', title: Lang.quizPassed),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '4', title: Lang.hoursSpent),
        ],
      ),
    );
  }

  Widget btn(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
      child: AppElevatedButton(
          width: double.infinity,
          backgroundColor: AppColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, QuizView.routeName);
          },
          title: Lang.takeAQuiz),
    );
  }

  Widget list(BuildContext context) {
    return Column(
      children: [
        itemHeading(context),
        Container(
          height: 450,
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return itemList(context, selected: (index == 2));
              }),
        ),
      ],
    );
  }

  Widget itemHeading(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.percentHeight * 1,
          vertical: context.percentWidth * 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: subText6(Lang.tCode, color: AppColors.white)),
          Expanded(child: subText6(Lang.quizTitle, color: AppColors.white)),
          Expanded(
              child: subText6(Lang.totalQuestions,
                  color: AppColors.white, align: TextAlign.start)),
          Expanded(
              child: subText6(Lang.correctAnswers,
                  color: AppColors.white, align: TextAlign.start)),
          Expanded(child: subText6(Lang.duration, color: AppColors.white)),
          Expanded(child: subText6(Lang.dueDate, color: AppColors.white)),
          Expanded(child: subText6(Lang.status, color: AppColors.white)),
        ],
      ),
    );
  }

  Widget itemList(BuildContext context, {required bool selected}) {
    return Card(
      elevation: selected ? 7 : 0,
      color: AppColors.white,
      shadowColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Border radius
        side: BorderSide(
          color: AppColors.borderColor, // Border color
          width: 0.7, // Border width
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.percentHeight * 1,
            vertical: context.percentWidth * 2),
        margin: EdgeInsets.symmetric(vertical: context.percentWidth * 2),
        child: Row(
          children: [
            Expanded(child: subText6("001", color: AppColors.blackColor)),
            Expanded(child: subText6("Python", color: AppColors.blackColor)),
            Expanded(child: subText6("10", color: AppColors.blackColor)),
            Expanded(child: subText6("10", color: AppColors.blackColor)),
            Expanded(child: subText6("12/30/24", color: AppColors.blackColor)),
            Expanded(child: subText6("12/30/24", color: AppColors.blackColor)),
            Expanded(
                child: subText6(selected ? "Completed" : 'In Progress',
                    color: selected ? AppColors.green : AppColors.blackColor)),
          ],
        ),
      ),
    );
  }

  void _showCourseSelectionDialog(BuildContext context) {
    // List of courses
    final List<String> courses = [
      "Web Development",
      "Content Management",
      "Fundamental To Finance",
      "JavaScript",
    ];

    // Selected value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subText1(Lang.selectACourseForAQuiz,
                            color: AppColors.blackColor),
                        const Icon(
                          FontAwesomeIcons.caretDown,
                          color: AppColors.blackColor,
                          size: 15,
                        )
                      ],
                    )),
                    Container(
                      height: 1,
                      color: AppColors.borderColor,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      // children: courses.map((course) {
                      //   return RadioListTile<String>(
                      //     title: Text(course),
                      //     value: course,
                      //     groupValue: selectedCourse,
                      //     onChanged: (String? value) {
                      //       setState(() {
                      //         selectedCourse = value!;
                      //       });
                      //     },
                      //   );
                      // }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget customRadioTile({required String title, required int value ,required }) {
  //   return ListTile(
  //     title: Text(title),
  //     trailing: Radio<int>(
  //       value: value,
  //       groupValue: _selectedValue,
  //       onChanged: (int? newValue) {
  //         setState(() {
  //           _selectedValue = newValue!;
  //         });
  //       },
  //     ),
  //   );
  // }
}
