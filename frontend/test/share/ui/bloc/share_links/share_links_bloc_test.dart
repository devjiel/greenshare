import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/share/repositories/models/share_link_entity_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:greenshare/share/repositories/share_links_repository.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';

class MockShareLinksRepository extends Mock implements ShareLinksRepository {}

void main() {
  group('ShareLinksBloc - Create', () {
  late ShareLinksRepository shareLinksRepository;
  late ShareLinksBloc shareLinksBloc;

  setUp(() {
    shareLinksRepository = MockShareLinksRepository();
    shareLinksBloc = ShareLinksBloc(shareLinksRepository);
  });

  test('initial state is ShareLinksInitial', () {
    expect(shareLinksBloc.state, const ShareLinksInitial());
  });

  blocTest<ShareLinksBloc, ShareLinksState>(
    'emits [ShareLinksLoading, ShareLinkCreated] when CreateShareLink is added',
    build: () {
      when(() => shareLinksRepository.createLink(any())).thenAnswer((_) async => 'linkUid');
      return shareLinksBloc;
    },
    act: (bloc) => bloc.add(const CreateShareLink(['file1', 'file2'])),
    expect: () => [
      const ShareLinksLoading(),
      const ShareLinkCreated('/share/linkUid'),
    ],
  );

  blocTest<ShareLinksBloc, ShareLinksState>(
    'emits [ShareLinksLoading, ShareLinksError] when CreateShareLink fails',
    build: () {
      when(() => shareLinksRepository.createLink(any())).thenThrow(Exception('error'));
      return shareLinksBloc;
    },
    act: (bloc) => bloc.add(const CreateShareLink(['file1', 'file2'])),
    expect: () => [
      const ShareLinksLoading(),
      const ShareLinksError('Exception: error'),
    ],
  );
});

group('ShareLinksBloc - Retrieve', () {
  late ShareLinksRepository shareLinksRepository;
  late ShareLinksBloc shareLinksBloc;

  setUp(() {
    shareLinksRepository = MockShareLinksRepository();
    shareLinksBloc = ShareLinksBloc(shareLinksRepository);
  });

  blocTest<ShareLinksBloc, ShareLinksState>(
    'emits [ShareLinksLoading, ShareLinkLoaded] when GetShareLinkFiles is added',
    build: () {
      when(() => shareLinksRepository.getLink(any())).thenAnswer((_) async => const ShareLinkEntityModel(uid: '1', fileUidList: ['file1', 'file2']));
      return shareLinksBloc;
    },
    act: (bloc) => bloc.add(const GetShareLinkFiles('linkUid')),
    expect: () => [
      const ShareLinksLoading(),
      const ShareLinkLoaded(['file1', 'file2']),
    ],
  );

  blocTest<ShareLinksBloc, ShareLinksState>(
    'emits [ShareLinksLoading, ShareLinksError] when GetShareLinkFiles fails',
    build: () {
      when(() => shareLinksRepository.getLink(any())).thenThrow(Exception('error'));
      return shareLinksBloc;
    },
    act: (bloc) => bloc.add(const GetShareLinkFiles('linkUid')),
    expect: () => [
      const ShareLinksLoading(),
      const ShareLinksError('Exception: error'),
    ],
  );
});
}