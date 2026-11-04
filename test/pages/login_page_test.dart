// Copyright (C) 2026 Daily You TH3 Learning English
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/custom_locale_delegates.dart';
import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/pages/login_page.dart';
import 'package:daily_you/providers/learning_progress_provider.dart';
import 'package:daily_you/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  late Database database;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    AppDatabase.instance.database = database;
    await AppDatabase.instance.createSchema(database);
    await UserSessionProvider.instance.reloadUsers();
    await LearningProgressProvider.instance.loadProgress();
  });

  tearDown(() async {
    AppDatabase.instance.database = null;
    await database.close();
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSessionProvider>.value(
          value: UserSessionProvider.instance,
        ),
        ChangeNotifierProvider<LearningProgressProvider>.value(
          value: LearningProgressProvider.instance,
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        home: LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage renders title, form fields and quick user chips',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('learningEnglish'), findsWidgets);
    expect(find.text('Luyện phát âm & Theo dõi tiến độ học tập'), findsOneWidget);
    expect(find.text('TÀI KHOẢN / EMAIL'), findsOneWidget);
    expect(find.text('MẬT KHẨU'), findsOneWidget);
    expect(find.text('Đăng nhập vào learningEnglish'), findsOneWidget);
  });

  testWidgets('LoginPage switches between Login and Register modes',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final toggleButton = find.text('Chưa có tài khoản? Đăng ký học viên mới');
    expect(toggleButton, findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    expect(find.text('HỌ VÀ TÊN HỌC VIÊN'), findsOneWidget);
    expect(find.text('Đăng ký học viên & Vào học'), findsOneWidget);
  });
}
