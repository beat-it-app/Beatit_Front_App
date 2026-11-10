import 'dart:async';

import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/foreground_alarm_banner_host.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_response.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _LoggedInAuth extends AuthNotifier {
  @override
  AsyncValue<AuthSession?> build() => const AsyncData(
    AuthSession(
      userId: 1,
      role: Role.user,
      createdProfile: true,
      accessToken: 't',
    ),
  );
}

void main() {
  late StreamController<RemoteMessage> controller;
  final key = GlobalKey<NavigatorState>();

  Future<void> pumpHost(WidgetTester tester) async {
    controller = StreamController<RemoteMessage>.broadcast();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authProvider.overrideWith(_LoggedInAuth.new)],
        child: MaterialApp(
          navigatorKey: key,
          theme: AppTheme.light,
          builder: (context, child) => ForegroundAlarmBannerHost(
            navigatorKey: key,
            messages: controller.stream,
            child: child!,
          ),
          home: const Scaffold(body: Text('home')),
        ),
      ),
    );
  }

  RemoteMessage msg() => const RemoteMessage(
    notification: RemoteNotification(title: '제목', body: '내용'),
  );

  testWidgets('포그라운드 메시지가 오면 배너가 보인다', (tester) async {
    await pumpHost(tester);
    controller.add(msg());
    await tester.pump();
    await tester.pump();
    expect(find.text('제목'), findsOneWidget);
    expect(find.text('내용'), findsOneWidget);
    await tester.pump(const Duration(seconds: 21)); // 타이머 정리
  });

  testWidgets('좌로 스와이프하면 사라지고, 다음 알림은 다시 뜬다', (tester) async {
    await pumpHost(tester);
    controller.add(msg());
    await tester.pump();
    await tester.pump();
    await tester.fling(find.text('제목'), const Offset(-300, 0), 1500);
    await tester.pumpAndSettle();
    expect(find.text('제목'), findsNothing);

    controller.add(msg());
    await tester.pump();
    await tester.pump();
    expect(find.text('제목'), findsOneWidget);
    await tester.pump(const Duration(seconds: 21));
  });

  testWidgets('짧은 스와이프는 원위치로 돌아온다', (tester) async {
    await pumpHost(tester);
    controller.add(msg());
    await tester.pump();
    await tester.pump();
    await tester.drag(find.text('제목'), const Offset(-20, 0));
    await tester.pumpAndSettle();
    expect(find.text('제목'), findsOneWidget);
    await tester.pump(const Duration(seconds: 21));
  });
}
