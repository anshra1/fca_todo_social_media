// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_learning_go_router/core/common/styles/gap.dart';
// import 'package:flutter_learning_go_router/core/common/widgets/rich_link_text.dart';
// import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
// import 'package:flutter_learning_go_router/core/extension/int_extension.dart';
// import 'package:flutter_learning_go_router/core/extension/text_style.dart';
// import 'package:flutter_learning_go_router/src/auth/presentation/views/phone_number_view.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:go_router/go_router.dart';

// class OtpVerifyView extends HookWidget {
//   const OtpVerifyView({super.key});

//   static const routeName = '/otp-verify-view';

//   @override
//   Widget build(BuildContext context) {
//     final rebuild = useState(1);
//     final secondsRemaining = useValueNotifier<int>(30);
//     // difference between useValueNotifier and useState
//     // read useValueListenable(valueListenable)
//     Timer? timer;

//     void startTimer() {
//       timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (secondsRemaining.value > 0) {
//           secondsRemaining.value--;
//         } else {
//           rebuild.value++;
//           timer.cancel();
//         }
//       });
//     }

//     void resendOtp() {
//       secondsRemaining.value = 30;
//       rebuild.value++;
//       startTimer();
//     }

//     useEffect(
//       () {
//         startTimer();
//         return () {
//           timer?.cancel();
//         };
//       },
//       [],
//     );
// // 1 read command Dash useustate vs useValueNotifier
// // 2 write about useValueNotifier
// // 3 useValueListenable(valueListenable)
// // 4 write about useState

//     if (kDebugMode) {
//       //  print('rebuild ${Random().nextInt(1000)}');
//     }

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: false,
//           leading: GestureDetector(
//             onTap: () => context.go(PhoneNumberView.routeName),
//             child: const Icon(Icons.arrow_back),
//           ),
//           title: Text(
//             'Verify',
//             style: p18.bold,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Enter the otp we've sent to",
//                     style: p16.medium,
//                   ),
//                   kGap10,
//                   Row(
//                     children: [
//                       Text(
//                         '7277989796',
//                         style: p18.bold,
//                       ),
//                       kGap10,
//                       const SizedBox(
//                         height: 20,
//                         child: VerticalDivider(
//                           width: 1,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       kGap10,
//                       GestureDetector(
//                         onTap: () {},
//                         child: RichLinkText(
//                           label: 'Edit',
//                           onPressed: () =>
//                               context.go(PhoneNumberView.routeName),
//                         ),
//                       ),
//                     ],
//                   ),
//                   kGap30,
//                   OtpTextField(
//                     numberOfFields: 6,

//                     borderColor: context.theme.primaryColor,
//                     //set to true to show as box or false to show as dash
//                     //showFieldAsBox: true,
//                     //runs when a code is typed in
//                     onCodeChanged: (String code) {},
//                     //runs when every textfield is filled
//                     onSubmit: (String verificationCode) {}, // end onSubmit
//                   ),
//                   kGap35,
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Didn't receive the code?",
//                         style: p16.copyWith(color: Colors.black87),
//                       ),
//                       kGap10,
//                       if (secondsRemaining.value == 0)
//                         RichLinkText(
//                           label: 'Resend Otp',
//                           onPressed: resendOtp,
//                         )
//                       else
//                         ListenableBuilder(
//                           listenable: secondsRemaining,
//                           builder: (context, widget) {
//                             return Text(
//                               '00:${secondsRemaining.value.timer}',
//                               style: p16.copyWith(color: Colors.black87),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//               // ListenableBuilder(
//               //   listenable: text,
//               //   builder: (context, widget) {
//               //     print('onCode ${text.value.length}');
//               //     return RoundedButton(
//               //       label: 'Continue',
//               //       onPressed: controller.text.length == 6
//               //           ? () {
//               //               if (controller.text.length == 6) {
//               //                 context.push(OtpVerifyView.routeName);
//               //               }
//               //             }
//               //           : null,
//               //     );
//               //   },
//               // )
//               // Padding(
//               //   padding: const EdgeInsets.only(bottom: 4),
//               //   child: ValueListenableBuilder(
//               //     valueListenable: controller,
//               //     builder: (
//               //       BuildContext context,
//               //       TextEditingValue value,
//               //       Widget? child,
//               //     ) {
//               //       return RoundedButton(
//               //         label: 'Continue',
//               //         onPressed: controller.text.length == 6
//               //             ? () {
//               //                 if (controller.text.length == 6) {
//               //                   context.push(OtpVerifyView.routeName);
//               //                 }
//               //               }
//               //             : null,
//               //       );
//               //     },
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
