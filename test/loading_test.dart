// import 'package:flutter_learning_go_router/core/common/loading/loading_screen_controller.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   setUp(
//     () {},
//   );
//   group(
//     'Loading Screen test',
//     () {
//       test(
//         'first create instace of loading screen '
//         'print the update value '
//         'then update again and print the value',
//         () async {
//           LoadingScreenController? controller;

//           String text = 'testing text';

//           LoadingScreenController show() {
//             return LoadingScreenController(
//               close: () {
//                 return true;
//               },
//               update: (text) {
//                 print(text);
//                 return true;
//               },
//             );
//           }

//           controller = show();

//           controller?.update('i am updating the text');
//           controller?.close();
//         },
//       );
//     },
//   );
// }
