import 'dart:convert';
import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/data/model/folder_model.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';

import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMap = jsonDecode(fixture('folder.json')) as DataMap;
  const tFolder = FolderModel.empty();

  group(
    'Folder',
    () {
      test(
        'should be a subclass of Folder',
        () {
          expect(tFolder, isA<Folder>());
        },
      );
    },
  );

  group(
    'from Map',
    () {
      test(
        'should return a valid Model when the map is valid',
        () {
          final result = FolderModel.fromMap(tMap);
          expect(result, isA<FolderModel>());
          expect(result, tFolder);
        },
      );
    },
  );

  group(
    'toMap',
    () {
      test(
        'should return a json Map containing the proper data',
        () async {
          final result = tFolder.toMap()..remove(Strings.date);
          expect(result, tMap..remove(Strings.date));
        },
      );
    },
  );

  group(
    'copyWith',
    () {
      test(
        'should return a copy of the model with the given values',
        () async {
          final result = tFolder.copyWith(folderName: 'new_folder_name');
          expect(result, isA<FolderModel>());
          expect(result.folderName, 'new_folder_name');
        },
      );
    },
  );
}
