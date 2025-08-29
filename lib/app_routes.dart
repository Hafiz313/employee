import 'package:employee/views/attendance/attendance_details_view.dart';
import 'package:employee/views/auth/Otp/otp_forget_view.dart';
import 'package:employee/views/auth/Otp/otp_signup_view.dart';
import 'package:employee/views/auth/forget/froget_view.dart';
import 'package:employee/views/auth/forget/rest_password_view.dart';
import 'package:employee/views/auth/login/login_view.dart';
import 'package:employee/views/auth/Otp/otp_view.dart';
import 'package:employee/views/auth/sing_up/signup_view.dart';
import 'package:employee/views/auth/splash_view.dart';
import 'package:employee/views/auth/term_conditions_view.dart';
import 'package:employee/views/bank/bank_info_view.dart';
import 'package:employee/views/home/home_view.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:employee/views/leave/leave_balance_view.dart';
import 'package:employee/views/notification_view.dart';
import 'package:employee/views/overTime/overtime_request_view.dart';
import 'package:employee/views/paytub/paystub_generator_view.dart';
import 'package:employee/views/quiz_results/quiz_view.dart';
import 'package:employee/views/quiz_results/results_view.dart';
import 'package:employee/views/subsititude/substitute_request_view.dart';
import 'package:employee/views/trainingAndCourses/course_details_view.dart';
import 'package:employee/views/trainingAndCourses/course_video_view.dart';
import 'package:employee/views/trainingAndCourses/training_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const splash = SplashView.routeName;
  static const login = LoginView.routeName;
  static const signUp = SignUpView.routeName;
  static const otp = OtpView.routeName;
  static const home = HomeView.routeName;
  static const notification = NotificationView.routeName;
  static const overtimeRequest = OvertimeRequestView.routeName;
  static const attendanceDetails = AttendanceDetailsView.routeName;
  static const leaveBalance = LeaveBalanceView.routeName;
  static const leaveRequest = LeaveARequestView.routeName;
  static const substituteRequest = SubstituteRequestView.routeName;
  static const training = TrainingView.routeName;
  static const courseVideo = CourseVideoView.routeName;
  static const courseDetails = CourseDetailsView.routeName;
  static const result = ResultView.routeName;
  static const quiz = QuizView.routeName;
  static const paystub = PaystubGeneratorView.routeName;
  static const bank = BankInfoView.routeName;
  static const over = BankInfoView.routeName;
  static const forget = ForgetView.routeName;
  static const otpSign = OtpSignUpView.routeName;
  static const otpForget = OtpForgetView.routeName;
  static const restPas = RestPasswordView.routeName;

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signUp, page: () => SignUpView()),
    GetPage(name: otp, page: () => OtpView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: notification, page: () => const NotificationView()),
    GetPage(name: overtimeRequest, page: () => OvertimeRequestView()),
    GetPage(name: attendanceDetails, page: () => const AttendanceDetailsView()),
    GetPage(name: leaveBalance, page: () => LeaveBalanceView()),
    GetPage(name: leaveRequest, page: () => LeaveARequestView()),
    GetPage(name: substituteRequest, page: () => SubstituteRequestView()),
    GetPage(name: training, page: () => TrainingView()),
    GetPage(name: courseVideo, page: () => CourseVideoView()),
    GetPage(name: courseDetails, page: () => CourseDetailsView()),
    GetPage(name: result, page: () => ResultView()),
    GetPage(name: quiz, page: () => QuizView()),
    GetPage(name: paystub, page: () => PaystubGeneratorView()),
    GetPage(name: bank, page: () => BankInfoView()),
    GetPage(name: forget, page: () => ForgetView()),
    GetPage(name: otpSign, page: () => OtpSignUpView()),
    GetPage(name: otpForget, page: () => OtpForgetView()),
    GetPage(name: restPas, page: () => RestPasswordView()),
  ];
}
