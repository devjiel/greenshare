import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/share/repositories/models/share_link_entity_model.dart';
import 'package:greenshare/share/repositories/models/share_links_repository_error.dart';
import 'package:greenshare/share/repositories/share_links_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  FirebaseDatabase firebaseDatabase = MockFirebaseDatabase.instance;
  const fakeData = {
    'shares': {
      '1': {
        'uid': '1',
        'file_uid_list': ['file1', 'file2'],
      },
    }
  };

  late ShareLinksRepository repository;

  setUp(() {
    repository = FirebaseShareLinksRepository(firebaseDatabase);
  });

  group('ShareLinksRepository', () {
    group('getLink', () {
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should return share when exists', () async {
        final link = await repository.getLink('1');
        expect(link, isA<ShareLinkEntityModel>().having((link) => link.fileUidList, 'fileUidList', ['file1', 'file2']));
      });

      test('should return empty list when share does not exists', () async {
        try {
          await repository.getLink('2');
          fail('Should throw an exception');
        } catch (e) {
          expect(e, isA<ShareLinksRepositoryError>().having((error) => error.errorType, 'error type should be not found', ShareLinksRepositoryErrorType.linkNotFound));
        }
      });
    });

    group('createLink', () {
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should create link successfully', () async {
        final link = await repository.createLink(['file1']);
        expect(Uuid.isValidUUID(fromString: link), isTrue);
      });
    });
  });
}
