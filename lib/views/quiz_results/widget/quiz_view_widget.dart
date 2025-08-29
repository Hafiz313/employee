import 'package:employee/consts/lang.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../consts/assets.dart';
import '../../../consts/colors.dart';
import '../../../core/models/quiz_result_model.dart';
import '../../widget/text.dart';

class QuizViewWidget extends StatelessWidget {
  final QuizResultModel quizResultModel;

  const QuizViewWidget({
    super.key, required this.quizResultModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [card(context), questionTitles(context),questionList(context)],
    );
  }

  Widget card(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0), // Adjust the radius as needed
      ),
      child: Column(
        children: [
          SizedBox(height: context.percentHeight * 2),
          subText3(quizResultModel.courseName,
              color: AppColors.headingTextColor, fontWeight: FontWeight.bold),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.percentHeight * 2),
            child: CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 17.0,
              animation: true,
              percent: quizResultModel.progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
              '${(quizResultModel.progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: AppColors.primary),
                  ),
                  subText5(Lang.completed, fontWeight: FontWeight.bold),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: AppColors.primary,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: context.percentWidth * 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText4(Lang.questions, color: AppColors.headingTextColor),
                    RichText(
                      text: TextSpan(
                        text: '${quizResultModel.completedQuestions}/${quizResultModel.totalQuestions}',
                        style: const TextStyle(
                          fontSize: 25,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText4(Lang.time, color: AppColors.headingTextColor),
                    RichText(
                      text: TextSpan(
                        text: quizResultModel.timeInfo,
                        style: const TextStyle(
                          fontSize: 25,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(
                            text: Lang.hrs,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.percentHeight * 2),
        ],
      ),
    );
  }

  Widget questionTitles(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: context.percentHeight * 5,
              width: context.percentWidth * 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: const DecorationImage(
                    image: AssetImage(AppAssets.questionMark)),
              ),
            ),
            subText4(quizResultModel.questionsNo)
          ],
        ),
        subText4(quizResultModel.questionsTime)
      ],
    );
  }


  Widget questionList(BuildContext context){
    int _groupValue = -1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
            margin: EdgeInsets.only(left: context.percentWidth * 6),
            child: subText4(quizResultModel.question,color: AppColors.blackColor,fontWeight: FontWeight.bold)),
        ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              return RadioListTile(
                value: 1,
                groupValue: _groupValue,
                onChanged: (v){},
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: context.percentHeight * 1,horizontal: context.percentWidth * 4),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: subText4('Lorem Ipsum'),
                ),
              );

        })
      ],
    );
  }


}
