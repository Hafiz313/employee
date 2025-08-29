import 'package:carousel_slider/carousel_slider.dart';
import 'package:employee/consts/lang.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../consts/assets.dart';
import '../../consts/colors.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/search_text_fields.dart';
import '../widget/text.dart';
import 'course_details_view.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});
  static const String routeName = '/TrainingView';

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  final searchTxtField = TextEditingController();

  final List<String> imageUrls = [
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/450',
    'https://via.placeholder.com/500',
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              courses(context),
              SizedBox(
                height: context.percentHeight * 1,
              ),
              slider(context),
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

  Widget courses(BuildContext context) {
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
                  headline5(Lang.courses, color: AppColors.white)
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
          coursesItem(context, time: '10', title: Lang.enrolled),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '3', title: Lang.completed),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '7', title: Lang.inProgress),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '4', title: Lang.failed),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '1', title: Lang.passed),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            color: AppColors.white,
            width: 1,
            height: context.percentWidth * 10,
          ),
          coursesItem(context, time: '145:30', title: Lang.hoursSpent),
        ],
      ),
    );
  }

  Widget cardSlider(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, CourseDetailsView.routeName),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth * 0.8,
                    vertical: context.percentHeight * 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: context.percentWidth * 1,
                      height: context.percentHeight * 1,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.percentWidth * 0.4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.borderColor,
                      ),
                    ),
                    Container(
                      width: context.percentWidth * 1,
                      height: context.percentHeight * 1,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.percentWidth * 0.4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.borderColor,
                      ),
                    ),
                    Container(
                      width: context.percentWidth * 1,
                      height: context.percentHeight * 1,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.percentWidth * 0.4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.borderColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: context.percentHeight * 7,
                width: context.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                      image: AssetImage(AppAssets.demoImage)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth * 0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.percentHeight * 0.5,
                    ),
                    subText6('HTML & CSS',
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                    SizedBox(
                      height: context.percentHeight * 0.5,
                    ),
                    subText6(
                        'it is a long established fact thata reader will be distracted by the .',
                        color: AppColors.textColor,
                        align: TextAlign.left),
                    SizedBox(
                      height: context.percentHeight * 0.5,
                    ),
                    subText6('100% Completed ',
                        color: AppColors.textColor, align: TextAlign.left),
                    SizedBox(
                      height: context.percentHeight * 0.5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: context.percentWidth * 1),
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(5),
                        value: .5,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: context.percentHeight * 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              subText6('10 Lessons | 2:30 Hrs',
                                  color: AppColors.textColor,
                                  align: TextAlign.left),
                              SizedBox(
                                height: context.percentHeight * 0.5,
                              ),
                              subText6('Status: Completed',
                                  color: AppColors.textColor,
                                  align: TextAlign.left),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: context.percentHeight * 0.4),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: subText6('Start', color: AppColors.white),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: context.percentHeight * 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget slider(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            autoPlay: true,
            aspectRatio: 10.0,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              width: context.screenWidth - 20,
                              child: Row(
                                children: [
                                  cardSlider(context),
                                  cardSlider(context),
                                  cardSlider(context),
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = entry.key;
                });
              },
              child: Container(
                width: context.percentWidth * 2,
                height: context.percentHeight * 2,
                margin:
                    EdgeInsets.symmetric(horizontal: context.percentWidth * 1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? AppColors.primary
                      : AppColors.borderColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget btn(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
      child: AppElevatedButton(
          width: double.infinity,
          backgroundColor: AppColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, CourseDetailsView.routeName);
          },
          title: Lang.enrollCourse),
    );
  }

  Widget list(BuildContext context) {
    return Column(
      children: [
        itemHeading(context),
        SizedBox(
          height: 200,
          child: ListView.builder(
              itemCount: 10,
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
          Expanded(child: subText6(Lang.courseName, color: AppColors.white)),
          Expanded(child: subText6(Lang.lessons, color: AppColors.white)),
          Expanded(child: subText6(Lang.completed, color: AppColors.white)),
          Expanded(child: subText6(Lang.startDate, color: AppColors.white)),
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
}
