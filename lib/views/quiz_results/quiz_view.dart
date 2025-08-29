import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/quiz_results/widget/quiz_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../consts/colors.dart';
import '../../consts/fonts.dart';
import '../../consts/lang.dart';
import '../../core/viewmodels/controller/quiz_result_controller.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/buttons_small.dart';
import '../widget/text.dart';


class QuizView extends StatelessWidget {
  const QuizView({Key? key}) : super(key: key);
  static const String routeName = '/QuizView';

  @override
  Widget build(BuildContext context) {
    // Initialize the ResultController
    final ResultController controller = Get.put(ResultController());

    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => QuizViewWidget(
                quizResultModel: controller.quizResult.value,
              )),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButtonSmall(
            width: context.percentWidth * 5,
            backgroundColor: AppColors.primary,
            onPressed: () {
              // Navigator.pushNamed(context, QuizView.routeName);
            },
            title: Lang.skip,
          ),
          SizedBox(width: context.percentWidth * 2,),
          AppButtonSmall(
            width: context.percentWidth * 5,
            backgroundColor: AppColors.green,
            onPressed: () {
              // Navigator.pushNamed(context, QuizView.routeName);
            },
            title: Lang.next,
          ),

        ],
      ),
    );
  }

}
