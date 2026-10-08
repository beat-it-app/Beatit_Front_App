import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_list_page.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_demo_data.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_main_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_mine_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_host_dialog.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    TeamDetailPage(),
    PostMainPage(),
    CalMainPage(),
    ListChatPage(),
    // TODO: 실제 마이페이지 연결 시 공연 테스트 메뉴 제거
    _TemporaryMainPage(title: '마이페이지'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(
      0,
      defaultAppNavigationItems.length - 1,
    );
  }

  void _onNavigationTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages),
    bottomNavigationBar: AppBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavigationTap,
    ),
  );
}

/// 개발 중 공연 화면을 확인하기 위한 임시 마이페이지.
class _TemporaryMainPage extends StatelessWidget {
  const _TemporaryMainPage({required this.title});

  final String title;

  Future<void> _open(
    BuildContext context,
    Widget Function(PerformanceDemoData) page,
  ) async {
    try {
      final data = await PerformanceDemoData.load();
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page(data)),
      );
    } catch (error, stackTrace) {
      debugPrint('Performance demo page error: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!context.mounted) return;
      _message(context, '테스트 화면 오류 (${error.runtimeType}). 콘솔 로그를 확인해주세요.');
    }
  }

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _previewCreated(BuildContext context, PerformanceCreateData created) {
    _message(context, '더미 미리보기입니다. 서버에 저장되지 않습니다.');
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PerformanceDetailPage(
          performance: PerformanceDetailData.fromCreate(created),
        ),
      ),
    );
  }

  Future<void> _hostPopup(BuildContext context, {required bool link}) async {
    try {
      final data = await PerformanceDemoData.load();
      if (!context.mounted) return;
      final detail = data.performances[link ? 1 : 0].detail!;
      await showPerformanceHostDialog(
        context: context,
        hostName: detail.hostName,
        contactType: detail.hostContactType!,
        contact: detail.hostContact,
      );
    } catch (error, stackTrace) {
      debugPrint('Performance host demo error: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) _message(context, '호스트 팝업 오류 (${error.runtimeType}).');
    }
  }

  Widget _testButton(String text, VoidCallback action) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x10),
        child: AppButton(
          text: text,
          variant: ButtonVariant.outlinedGray,
          onPressed: action,
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(AppSpacing.x20),
      children: [
        Text(title, style: FontStyles.semi24.copyWith(color: context.grays.black)),
        const SizedBox(height: AppSpacing.x16),
        Text('공연 UI 테스트 · 예시 데이터는 실제 등록되지 않습니다.',
          style: FontStyles.reg14.copyWith(color: context.grays.gray4)),
        const SizedBox(height: AppSpacing.x20),
        _testButton('공연 메인 (검색·필터)', () =>
          _open(context, (data) => PerformanceMainPage(
            performances: data.performances,
            previewDraft: data.draft,
            onSubmit: (created) => _previewCreated(context, created),
          ))),
        _testButton('공연 등록 1단계 · 공연 정보', () =>
          _open(context, (data) => PerformanceInformationPage(
            initialDraft: data.draft,
            onSubmit: (created) => _previewCreated(context, created),
          ))),
        _testButton('공연 등록 2단계 · 상세 정보', () =>
          _open(context, (data) => PerformanceDetailInformationPage(
            information: data.draft.information,
            initialData: data.draft,
            onSubmit: (created) => _previewCreated(context, created),
          ))),
        _testButton('공연 상세보기 (공연 정보·상세 정보)', () =>
          _open(context, (data) => PerformanceDetailPage(
            performance: data.performances.first.detail!,
          ))),
        _testButton('나의 공연 목록', () =>
          _open(context, (data) => PerformanceMinePage(
            performances: data.mine,
            onEdit: (item) => _open(context, (demo) => PerformanceInformationPage(
              initialDraft: demo.draftFor(item),
              onSubmit: (created) => _previewCreated(context, created),
            )),
            onDelete: (_) => _message(context, '더미 공연은 삭제되지 않습니다.'),
            onViewResponses: (_) => _message(context, '응답 조회 API는 아직 연결되지 않았습니다.'),
          ))),
        _testButton('나의 공연 상세보기 (더보기·응답)', () =>
          _open(context, (data) => PerformanceDetailPage(
            performance: data.mine.first.detail!,
            isMine: true,
            onEdit: () => _open(context, (demo) => PerformanceInformationPage(
              initialDraft: demo.draftFor(data.mine.first),
              onSubmit: (created) => _previewCreated(context, created),
            )),
            onDelete: () => _message(context, '더미 공연은 삭제되지 않습니다.'),
            onViewResponses: () => _message(context, '응답 조회 API는 아직 연결되지 않았습니다.'),
          ))),
        _testButton('호스트 정보 · 연락처 팝업', () =>
          _hostPopup(context, link: false)),
        _testButton('호스트 정보 · 링크 팝업', () =>
          _hostPopup(context, link: true)),
      ],
    ),
  );
}
