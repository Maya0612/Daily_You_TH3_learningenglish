// Copyright (C) 2026 Daily You TH3 Learning English
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/models/course_roadmap.dart';
import 'package:daily_you/models/learning_progress.dart';
import 'package:daily_you/models/study_sentence.dart';
import 'package:daily_you/providers/learning_progress_provider.dart';
import 'package:daily_you/widgets/user_profile_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Màn hình Lộ trình Khóa học tiếng Anh chuẩn CEFR (Level A1 -> C2).
///
/// Thiết kế danh sách dọc khoa học:
/// - 6 Cấp độ (A1 -> C2) hiển thị theo danh sách thẻ dọc dễ quan sát.
/// - Mỗi Cấp độ gồm 11 bài học (10 Units giao tiếp + Bài 11: Thành ngữ & Tục ngữ thông dụng).
/// - Chỉ hiển thị danh sách bài học (không bung câu làm tràn màn hình).
/// - Nhấn vào bài hoặc nút "Luyện tập" để chuyển thẳng sang Tab Luyện tập với bài đó.
class LearningRoadmapPage extends StatefulWidget {
  final Function(StudySentence sentence)? onSelectSentenceToPractice;
  final Function(String levelCode, CourseLesson lesson)? onSelectLessonToPractice;

  const LearningRoadmapPage({
    super.key,
    this.onSelectSentenceToPractice,
    this.onSelectLessonToPractice,
  });

  @override
  State<LearningRoadmapPage> createState() => _LearningRoadmapPageState();
}

class _LearningRoadmapPageState extends State<LearningRoadmapPage> {
  String _expandedLevelCode = 'A1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levels = CourseRoadmapRepository.allLevels;
    final progressProvider = context.watch<LearningProgressProvider>();
    final progress = progressProvider.progress;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF1FF), // Soft Ice White
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // -----------------------------------------------------------------
            // 1. HEADER & USER PROFILE BAR
            // -----------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const UserProfileBar(isCard: true),
                    const SizedBox(height: 12),
                    // Quick Daily Motivation & Streak
                    _buildDailyStreakBanner(theme, progress),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------------
            // 2. TIÊU ĐỀ LỘ TRÌNH CÁC KHÓA HỌC DỌC
            // -----------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LỘ TRÌNH KHÓA HỌC (CEFR)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      '6 Cấp độ • 66 Bài học',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------------
            // 3. DANH SÁCH DỌC 6 CẤP ĐỘ KHÓA HỌC (A1 -> C2)
            // -----------------------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final level = levels[index];
                    final isExpanded = level.code == _expandedLevelCode;
                    return _buildLevelVerticalCard(theme, level, isExpanded);
                  },
                  childCount: levels.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET: DAILY STREAK BANNER (NÚT HỌC NGAY CHUYỂN THẲNG SANG BÀI 1 A1)
  // ---------------------------------------------------------------------------
  Widget _buildDailyStreakBanner(
      ThemeData theme, DailyLearningProgress progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB1B2FF).withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7ED), // Cam lửa nhạt
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFF97316),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Chuỗi học: ${progress.streakCount} ngày',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF97316),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Text(
                  progress.isGoalAchieved
                      ? 'Tuyệt vời! Bạn đã hoàn thành mục tiêu hôm nay.'
                      : 'Hôm nay: ${progress.todayStudyMinutes}/${progress.dailyGoalMinutes} phút mục tiêu.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              // Bắt đầu từ Bài 1 của Level A1 (hoặc level đang mở) và chuyển thẳng sang tab Luyện tập
              final activeLevel =
                  CourseRoadmapRepository.getLevel(_expandedLevelCode) ??
                      CourseRoadmapRepository.getLevel('A1') ??
                      CourseRoadmapRepository.allLevels.first;
              if (activeLevel.lessons.isNotEmpty) {
                final firstLesson = activeLevel.lessons.first;
                if (widget.onSelectLessonToPractice != null) {
                  widget.onSelectLessonToPractice!(activeLevel.code, firstLesson);
                } else {
                  widget.onSelectSentenceToPractice?.call(firstLesson.sentences.first);
                }
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded, size: 20),
                SizedBox(width: 4),
                Text('Học ngay', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET: CARD CẤP ĐỘ THEO DANH SÁCH DỌC (VERTICAL LIST)
  // ---------------------------------------------------------------------------
  Widget _buildLevelVerticalCard(
    ThemeData theme,
    CourseLevel level,
    bool isExpanded,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded
              ? level.primaryColor
              : const Color(0xFFD2DAFF).withAlpha(120),
          width: isExpanded ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? level.primaryColor.withAlpha(40)
                : const Color(0xFFB1B2FF).withAlpha(30),
            blurRadius: isExpanded ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEVEL HEADER (Có thể chạm để mở rộng / thu gọn)
          InkWell(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: Radius.circular(isExpanded ? 0 : 20),
            ),
            onTap: () {
              setState(() {
                _expandedLevelCode = isExpanded ? '' : level.code;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isExpanded ? level.primaryColor : level.secondaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      level.icon,
                      color: isExpanded ? Colors.white : level.primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: level.primaryColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                level.code,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: level.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                level.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${level.subtitle} • 11 Bài học (${level.totalSentences} câu)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isExpanded ? level.primaryColor : Colors.grey.shade500,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),

          // NỘI DUNG KHI LEVEL ĐƯỢC CHỌN / MỞ RỘNG
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Mô tả Level
                  Text(
                    level.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nút Luyện tập toàn khóa (bắt đầu từ Bài 1)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: level.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                    icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
                    label: Text(
                      'Luyện tập toàn bộ khóa ${level.code}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (level.lessons.isNotEmpty) {
                        final firstLesson = level.lessons.first;
                        if (widget.onSelectLessonToPractice != null) {
                          widget.onSelectLessonToPractice!(level.code, firstLesson);
                        } else {
                          widget.onSelectSentenceToPractice
                              ?.call(firstLesson.sentences.first);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // DANH SÁCH 11 BÀI HỌC CỦA KHÓA HỌC (CHỈ DANH SÁCH BÀI, KHÔNG BUNG CÂU)
            Container(
              color: const Color(0xFFF8FAFF),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: level.lessons.map((lesson) {
                  final isIdiomsLesson = lesson.unitNumber == 11;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isIdiomsLesson
                          ? const Color(0xFFFFF9E6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isIdiomsLesson
                            ? const Color(0xFFF59E0B).withAlpha(120)
                            : const Color(0xFFE2E8F0),
                        width: isIdiomsLesson ? 1.2 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: isIdiomsLesson
                            ? const Color(0xFFF59E0B)
                            : level.secondaryColor,
                        foregroundColor: isIdiomsLesson
                            ? Colors.white
                            : level.primaryColor,
                        child: Icon(
                          lesson.icon,
                          size: 19,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isIdiomsLesson
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF1E293B),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isIdiomsLesson) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Đặc biệt',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${lesson.description} • ${lesson.sentences.length} câu',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          backgroundColor: isIdiomsLesson
                              ? const Color(0xFFFEF3C7)
                              : const Color(0xFFEEF1FF),
                          foregroundColor: isIdiomsLesson
                              ? const Color(0xFFB45309)
                              : const Color(0xFF6C63FF),
                        ),
                        onPressed: () {
                          if (widget.onSelectLessonToPractice != null) {
                            widget.onSelectLessonToPractice!(level.code, lesson);
                          } else {
                            widget.onSelectSentenceToPractice
                                ?.call(lesson.sentences.first);
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Luyện tập',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.arrow_forward_rounded, size: 13),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (widget.onSelectLessonToPractice != null) {
                          widget.onSelectLessonToPractice!(level.code, lesson);
                        } else {
                          widget.onSelectSentenceToPractice
                              ?.call(lesson.sentences.first);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
