import 'package:employee/consts/lang.dart';
import 'package:employee/networking/api_provider.dart';
import 'package:employee/utils/my_loader.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/auth/login/login_widgets.dart';
import 'package:employee/views/auth/sing_up/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../base_view/base_scaffold_auth.dart';
import '../../widget/buttons.dart';
import '../../widget/text.dart';
import '../../widget/text_fields.dart';
import '../login/controller/login_controller.dart';
import 'controller/forget_controller.dart';

class ForgetView extends StatelessWidget {
  ForgetView({super.key});
  static const String routeName = '/ForgetView';
  ForgetController controller = Get.put(ForgetController());
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldAuth(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 5.0,
            vertical: context.percentHeight * 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginWidgets.buildLogo(context),
              SizedBox(height: context.percentHeight * 3.0),
              _buildFormContainer(context),
              SizedBox(
                height: context.percentHeight * 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.percentHeight * 2.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.percentHeight * 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Text(
              Lang.forgetPassword.toUpperCase(),
              style: TextStyle(
                fontSize: context.percentHeight * 2.5,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
            SizedBox(height: context.percentHeight * 2.0),
            buildEmailField(context, controller.emailTxtField),
            SizedBox(height: context.percentHeight * 3.0),
            Obx(
              () => mainLoading.value
                  ? const MyLoader()
                  : btn(context, onPress: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.forget(context);
                      }
                    }),
            ),
            SizedBox(height: context.percentHeight * 1),
          ],
        ),
      ),
    );
  }

  static Widget buildEmailField(
      BuildContext context, TextEditingController textEditingController) {
    return CustomTxtField(
      hintTxt: Lang.email,
      textEditingController: textEditingController,
      suffixIcon: Icon(
        FontAwesomeIcons.solidEnvelope,
        color: AppColors.borderColor,
        size: context.percentHeight * 2.0,
      ),
      validator: (String? val) {
        if (val!.isEmpty) return Lang.empty;
        if (!emailExp.hasMatch(val)) return Lang.empty;
        return null;
      },
    );
  }

  static Widget btn(BuildContext context, {required Function() onPress}) {
    return AppElevatedButton(
      backgroundColor: AppColors.blue,
      onPressed: onPress,
      title: Lang.getCode,
    );
  }
}
