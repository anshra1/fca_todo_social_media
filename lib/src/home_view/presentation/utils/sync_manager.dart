// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_learning_go_router/core/extension/object_extension.dart';
// import 'package:flutter_learning_go_router/core/hive/hive_box.dart';
// import 'package:flutter_learning_go_router/src/home_view/presentation/cubit/todo_cubit.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// class SyncManager {
//   SyncManager(this.context);

//   final BuildContext context;
//   bool _isUploading = false;
//   // ignore: unused_field
//   StreamSubscription<dynamic>? _internetSubscription;

//   // void startListening() {
//   //   'enter startListening'.printFirst();

//   //   HiveBox.pendingTaskBox
//   //       .listenable()
//   //       .addListener(_startUploadingPendingItems);
//   // }

//   // void stopUploading() {
//   //   _isUploading = false;
//   //   _internetSubscription?.cancel();
//   //   _internetSubscription = null;
//   // }

//   // void _startUploadingPendingItems() {
//   //   if (!_isUploading && _internetSubscription == null) {
//   //     _isUploading = true;
//   //     _internetSubscription = InternetConnection().onStatusChange.listen(
//   //       (InternetStatus status) {
//   //         switch (status) {
//   //           case InternetStatus.connected:
//   //             try {
//   //               if (context.mounted) {
//   //                 print('Context is mounted, calling sync');
//   //                 context.read<TodoCubit>().sync();
//   //               } else {
//   //                 print('Context is not mounted, cannot call sync');
//   //               }
//   //             } catch (e) {
//   //               print('Error calling sync: $e');
//   //             }
//   //           case InternetStatus.disconnected:
//   //             print('Internet disconnected');
//   //         }
//   //       },
//   //       onError: (error) {
//   //         _isUploading = false;
//   //         print('Error in internet status listener: $error');
//   //       },
//   //     );
//   //   } else {
//   //     print('Already uploading, skipping');
//   //   }
//   // }

//   void dispose() {
//     stopUploading();
//     context.read<TodoCubit>().stopListening();
//   }
// }
