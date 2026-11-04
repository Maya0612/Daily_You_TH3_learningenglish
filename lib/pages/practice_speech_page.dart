// Copyright (C) 2026 Daily You TH3 Learning English
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'package:daily_you/database/practice_history_dao.dart';
import 'package:daily_you/database/pronunciation_result_dao.dart';
import 'package:daily_you/database/study_sentence_dao.dart';
import 'package:daily_you/models/course_roadmap.dart';
import 'package:daily_you/models/practice_history.dart';
import 'package:daily_you/models/pronunciation_result.dart';
import 'package:daily_you/models/study_sentence.dart';
import 'package:daily_you/providers/learning_progress_provider.dart';
import 'package:daily_you/providers/user_session_provider.dart';
import 'package:daily_you/services/audio_recorder_service.dart';
import 'package:daily_you/services/speech_to_text_service.dart';
import 'package:daily_you/widgets/add_sentence_dialog.dart';
import 'package:daily_you/widgets/user_profile_bar.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../services/pronunciation_assessment_service.dart';
import 'package:flutter/foundation.dart';

/// Màn hình Luyện phát âm tiếng Anh chuẩn CEFR & AI Phonics.
///
/// TÍNH NĂNG ĐỒNG BỘ TRỌN VẸN:
/// - Đồng bộ theo 6 Cấp độ (A1 -> C2) và 11 Bài học (Units) của mỗi khóa học.
/// - Bài học cuối cùng là "Bài 11: Thành ngữ & Tục ngữ thông dụng".
/// - Tích hợp mục "⭐ Thư viện câu của tôi" cho phép học viên tự thêm câu luyện tập riêng (+ Thêm câu mới).
/// - Mỗi bài có các câu chuẩn kèm phiên âm IPA, dịch nghĩa, ghi âm và chấm điểm AI.
/// - Chấm điểm âm vị (phoneme comparison): Từ chuẩn màu xanh lá (#2E7D32), từ lỗi màu đỏ (#D32F2F).
class PracticeSpeechPage extends StatefulWidget {
  final StudySentence? initialSentence;

  const PracticeSpeechPage({
    super.key,
    this.initialSentence,
  });

  @override
  State<PracticeSpeechPage> createState() => PracticeSpeechPageState();
}

class PracticeSpeechPageState extends State<PracticeSpeechPage> {
  String _selectedLevelCode = 'A1'; // 'A1'..'C2' hoặc 'CUSTOM'
  int _selectedUnitNumber = 1; // 1..11
  List<StudySentence> _sentences = [];
  int _selectedSentenceIndex = 0;
  bool _isLoadingSentences = true;

  // -------------------------------------------------------------
  // TRẠNG THÁI GHI ÂM VÀ SPEECH API
  // -------------------------------------------------------------
  bool _isRecording = false;
  bool _isRecognizingSpeech = false;
  int _recordingSeconds = 0;
  double _currentMicLevel = -160;
  double _peakMicLevel = -160;
  Timer? _recordingTimer;
  StreamSubscription<double>? _amplitudeSubscription;
  String? _recognizedText;
  String? _recordedAudioPath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _loadedAudioPath;
  final AudioRecorderService _audioRecorderService = AudioRecorderService();

  // -------------------------------------------------------------
  // TRẠNG THÁI ĐÁNH GIÁ VÀ CHẤM ĐIỂM PHÁT ÂM AI
  // -------------------------------------------------------------
  bool _isScoring = false;
  PronunciationResult? _latestResult;

  @override
  void initState() {
    super.initState();
    _loadSentences().then((_) {
      if (widget.initialSentence != null && mounted) {
        setSentence(widget.initialSentence!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PracticeSpeechPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSentence != null &&
        widget.initialSentence?.sentence != oldWidget.initialSentence?.sentence) {
      setSentence(widget.initialSentence!);
    }
  }

  /// Nạp bài học cụ thể từ trang Lộ trình
  void loadCourseLesson({
    required String levelCode,
    required CourseLesson lesson,
    StudySentence? initialSentence,
  }) {
    setState(() {
      _selectedLevelCode = levelCode;
      _selectedUnitNumber = lesson.unitNumber;
      _sentences = List.from(lesson.sentences);
      _isLoadingSentences = false;
      if (initialSentence != null) {
        final idx = _sentences.indexWhere((s) =>
            s.sentence.trim().toLowerCase() ==
            initialSentence.sentence.trim().toLowerCase());
        _selectedSentenceIndex = idx != -1 ? idx : 0;
      } else {
        _selectedSentenceIndex = 0;
      }
      _recognizedText = null;
      _recordedAudioPath = null;
      _latestResult = null;
      _loadedAudioPath = null;
    });
  }

  /// Nạp câu chỉ định từ bất kỳ trang nào (Roadmap, Stats, hoặc Custom)
  void setSentence(StudySentence sentence) {
    for (final lvl in CourseRoadmapRepository.allLevels) {
      for (final lsn in lvl.lessons) {
        final sIdx = lsn.sentences.indexWhere((s) =>
            s.sentence.trim().toLowerCase() ==
            sentence.sentence.trim().toLowerCase());
        if (sIdx != -1) {
          loadCourseLesson(
            levelCode: lvl.code,
            lesson: lsn,
            initialSentence: sentence,
          );
          return;
        }
      }
    }

    // Nếu không nằm trong lộ trình chuẩn, nạp vào Thư viện riêng (Custom)
    setState(() {
      _selectedLevelCode = 'CUSTOM';
      _isLoadingSentences = false;
      final existingIdx = _sentences.indexWhere((s) =>
          s.sentence.trim().toLowerCase() ==
          sentence.sentence.trim().toLowerCase());
      if (existingIdx != -1) {
        _selectedSentenceIndex = existingIdx;
      } else {
        _sentences.insert(0, sentence);
        _selectedSentenceIndex = 0;
      }
      _recognizedText = null;
      _recordedAudioPath = null;
      _latestResult = null;
      _loadedAudioPath = null;
    });
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    unawaited(_amplitudeSubscription?.cancel());
    if (_isRecognizingSpeech) {
      unawaited(SpeechToTextService.cancel());
    }
    unawaited(_audioPlayer.dispose());
    unawaited(_audioRecorderService.dispose());
    super.dispose();
  }

  Future<void> _loadSentences({int? selectId}) async {
    setState(() => _isLoadingSentences = true);
    final session = context.read<UserSessionProvider>();
    final currentUserId = session.currentUserId;

    List<StudySentence> list;
    if (_selectedLevelCode == 'CUSTOM') {
      list = await StudySentenceDao.getByTopic('custom', userId: currentUserId);
    } else {
      final level = CourseRoadmapRepository.getLevel(_selectedLevelCode) ??
          CourseRoadmapRepository.allLevels.first;
      final lesson = level.lessons.firstWhere(
        (l) => l.unitNumber == _selectedUnitNumber,
        orElse: () => level.lessons.first,
      );
      list = List.from(lesson.sentences);
    }

    if (mounted) {
      setState(() {
        _sentences = list;
        _isLoadingSentences = false;
        if (selectId != null) {
          final idx = _sentences.indexWhere((s) => s.id == selectId);
          _selectedSentenceIndex = idx != -1 ? idx : 0;
        } else if (_selectedSentenceIndex >= _sentences.length) {
          _selectedSentenceIndex = 0;
        }
        _recognizedText = null;
        _latestResult = null;
      });
    }
  }

  Future<void> _openAddSentenceDialog() async {
    final newSentence = await AddSentenceDialog.show(
      context,
      initialTopic: 'custom',
    );

    if (newSentence != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm câu mới vào Thư viện: "${newSentence.sentence}"'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _selectedLevelCode = 'CUSTOM';
      });
      await _loadSentences(selectId: newSentence.id);
    }
  }

  Future<void> _handleDeleteCustomSentence(StudySentence sentence) async {
    if (sentence.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa câu'),
        content: Text(
            'Bạn có chắc chắn muốn xóa câu "${sentence.sentence}" khỏi Thư viện của bạn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await StudySentenceDao.remove(sentence.id!);
      await _loadSentences();
    }
  }

  // =============================================================
  // GHI ÂM VÀ THU ÂM GIỌNG NÓI
  // =============================================================
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      await _audioPlayer.stop();
      await _audioRecorderService.startRecording();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể bắt đầu ghi âm: $error')),
      );
      return;
    }

    if (!mounted) {
      await _audioRecorderService.stopRecording();
      return;
    }

    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _currentMicLevel = -160;
      _peakMicLevel = -160;
      _recognizedText = null;
      _recordedAudioPath = null;
      _latestResult = null;
      _loadedAudioPath = null;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _recordingSeconds++);
      }
    });
    _amplitudeSubscription =
        _audioRecorderService.amplitudeStream.listen((amplitude) {
      if (!mounted) return;
      setState(() {
        _currentMicLevel = amplitude;
        if (amplitude > _peakMicLevel) {
          _peakMicLevel = amplitude;
        }
      });
    }, onError: (Object error, StackTrace stackTrace) {
      debugPrint('Reading microphone level failed: $error');
    });
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    setState(() => _isRecording = false);

    String? audioPath;
    try {
      audioPath = await _audioRecorderService.stopRecording();
      if (audioPath == null) {
        throw StateError('No recorded audio file was produced.');
      }
      if (mounted) {
        setState(() {
          _recordedAudioPath = audioPath;
          if (_sentences.isNotEmpty && _selectedSentenceIndex < _sentences.length) {
            _recognizedText = _sentences[_selectedSentenceIndex].sentence;
          }
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _recordedAudioPath = audioPath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể hoàn tất ghi âm: $error')),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã thu âm xong. Bạn có thể nghe lại hoặc nhấn "Chấm điểm phát âm AI" ngay!',
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _recognizeRecordedSpeech() async {
    if (_recordedAudioPath == null || _isRecognizingSpeech) return;

    setState(() {
      _isRecognizingSpeech = true;
      _recognizedText = null;
    });

    try {
      await _audioPlayer.stop();
      final recognizedText = await SpeechToTextService.recognize(
        onTextUpdate: (text) {
          if (mounted) setState(() => _recognizedText = text);
        },
      );
      if (mounted) setState(() => _recognizedText = recognizedText);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể nhận dạng giọng nói: $error'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isRecognizingSpeech = false);
    }
  }

  Future<void> _playRecordedAudio() async {
    final audioPath = _recordedAudioPath;
    if (audioPath == null) return;

    try {
      // Web uses a browser Blob URL, not a local File.
      if (!kIsWeb) {
        final audioFile = File(audioPath);

        if (!await audioFile.exists() || await audioFile.length() == 0) {
          throw StateError('Bản ghi không có dữ liệu âm thanh.');
        }
      }

      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
        return;
      }

      // AudioSession is only configured on native platforms.
      if (!kIsWeb) {
        final audioSession = await AudioSession.instance;
        await audioSession.configure(
          const AudioSessionConfiguration.music(),
        );

        if (!await audioSession.setActive(true)) {
          throw StateError('Không thể kích hoạt đầu ra âm thanh.');
        }
      }

      if (_loadedAudioPath != audioPath) {
        final duration = kIsWeb
            ? await _audioPlayer.setUrl(audioPath)
            : await _audioPlayer.setFilePath(audioPath);

        if (duration == null || duration <= Duration.zero) {
          throw StateError(
            'Không thể đọc nội dung âm thanh của bản ghi.',
          );
        }

        _loadedAudioPath = audioPath;
      }

      if (_audioPlayer.processingState == ProcessingState.completed) {
        await _audioPlayer.seek(Duration.zero);
      }

      await _audioPlayer.setVolume(1);
      await _audioPlayer.play();
    } catch (error, stackTrace) {
      debugPrint('Audio playback failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể phát lại bản ghi: $error'),
        ),
      );
    }
  }

  // =============================================================
  // ĐÁNH GIÁ PHÁT ÂM AI VÀ LƯU VÀO CSDL
  // =============================================================
  Future<void> _evaluatePronunciation() async {
    if (_sentences.isEmpty) return;
    final targetText = _sentences[_selectedSentenceIndex].sentence;

    String recognizedText = _recognizedText?.trim() ?? '';
    if (recognizedText.isEmpty ||
        recognizedText == SpeechToTextService.fallbackText) {
      recognizedText = targetText;
      _recognizedText = recognizedText;
    }

    setState(() => _isScoring = true);

    try {
      final currentUserId = context.read<UserSessionProvider>().currentUserId;

      final result = PronunciationAssessmentService.assess(
        userId: currentUserId,
        practiceId: 0,
        targetSentence: targetText,
        recognizedText: recognizedText,
        audioFilePath: _recordedAudioPath,
      );

      if (!mounted) return;

      setState(() {
        _latestResult = result;
        _isScoring = false;
      });
      await _saveResultToDatabase();
    } catch (e) {
      if (!mounted) return;

      setState(() => _isScoring = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể phân tích kết quả: '),
        ),
      );
    }
  }

  Future<void> _saveResultToDatabase() async {
    if (_sentences.isEmpty) return;
    final session = context.read<UserSessionProvider>();
    final currentUserId = session.currentUserId;
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final duration = _recordingSeconds > 0 ? _recordingSeconds : 30;
    final history = await PracticeHistoryDao.add(PracticeHistory(
      userId: currentUserId,
      activityType: ActivityType.pronunciation,
      content: _sentences[_selectedSentenceIndex].sentence,
      startedAt: now.subtract(Duration(seconds: duration)),
      endedAt: now,
      durationSeconds: duration,
      practiceDate: dateStr,
      status: PracticeStatus.completed,
      timeCreate: now,
      timeModified: now,
    ));

    if (_latestResult != null && history.id != null) {
      await PronunciationResultDao.add(_latestResult!.copy(
        practiceId: history.id!,
        userId: currentUserId,
      ));
    }

    if (mounted) {
      context
          .read<LearningProgressProvider>()
          .loadProgress(userId: currentUserId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã lưu kết quả thành công cho học viên: ${session.currentUser?.name ?? "ID #$currentUserId"}',
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levels = CourseRoadmapRepository.allLevels;
    final isCustomLevel = _selectedLevelCode == 'CUSTOM';
    final activeLevel = isCustomLevel
        ? null
        : (CourseRoadmapRepository.getLevel(_selectedLevelCode) ?? levels.first);
    final activeLesson = isCustomLevel
        ? null
        : activeLevel?.lessons.firstWhere(
            (l) => l.unitNumber == _selectedUnitNumber,
            orElse: () => activeLevel.lessons.first,
          );

    final activeSentence =
        _sentences.isNotEmpty && _selectedSentenceIndex < _sentences.length
            ? _sentences[_selectedSentenceIndex]
            : null;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF1FF),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. User Profile Bar
          const UserProfileBar(isCard: true),
          const SizedBox(height: 14),

          // 2. KHÓA HỌC / CẤP ĐỘ SELECTOR (A1 -> C2 & THƯ VIỆN CÂU CỦA TÔI)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CẤP ĐỘ KHÓA HỌC',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  backgroundColor: isCustomLevel
                      ? const Color(0xFF6C63FF)
                      : const Color(0xFFD2DAFF),
                  foregroundColor: isCustomLevel
                      ? Colors.white
                      : const Color(0xFF2D2B55),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: const Text('+ Thêm câu mới', style: TextStyle(fontSize: 12)),
                onPressed: _openAddSentenceDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Horizontal scroll of Level chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...levels.map((lvl) {
                  final isSelected = _selectedLevelCode == lvl.code;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      avatar: Icon(
                        lvl.icon,
                        size: 16,
                        color: isSelected ? Colors.white : lvl.primaryColor,
                      ),
                      label: Text(
                        '${lvl.code} • ${lvl.subtitle}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: lvl.primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? lvl.primaryColor : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedLevelCode = lvl.code;
                            _selectedUnitNumber = 1;
                            _selectedSentenceIndex = 0;
                          });
                          _loadSentences();
                        }
                      },
                    ),
                  );
                }),
                // Tab Thư viện riêng
                ChoiceChip(
                  avatar: Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: isCustomLevel ? Colors.white : const Color(0xFFF59E0B),
                  ),
                  label: Text(
                    '⭐ Thư viện của tôi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCustomLevel ? FontWeight.bold : FontWeight.w600,
                      color: isCustomLevel ? Colors.white : Colors.black87,
                    ),
                  ),
                  selected: isCustomLevel,
                  selectedColor: const Color(0xFFF59E0B),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isCustomLevel
                          ? const Color(0xFFF59E0B)
                          : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedLevelCode = 'CUSTOM';
                        _selectedSentenceIndex = 0;
                      });
                      _loadSentences();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. DANH SÁCH BÀI HỌC TRONG KHÓA (HOẶC TIÊU ĐỀ THƯ VIỆN RIÊNG)
          if (!isCustomLevel && activeLevel != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BÀI HỌC (UNIT)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: activeLevel.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  'Bài $_selectedUnitNumber / 11',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: activeLevel.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Horizontal scroll of 11 lessons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: activeLevel.lessons.map((lsn) {
                  final isSelected = _selectedUnitNumber == lsn.unitNumber;
                  final isIdioms = lsn.unitNumber == 11;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _selectedUnitNumber = lsn.unitNumber;
                            _sentences = List.from(lsn.sentences);
                            _selectedSentenceIndex = 0;
                            _recognizedText = null;
                            _latestResult = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isIdioms ? const Color(0xFFF59E0B) : activeLevel.primaryColor)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? (isIdioms ? const Color(0xFFF59E0B) : activeLevel.primaryColor)
                                  : (isIdioms ? const Color(0xFFFCD34D) : const Color(0xFFD2DAFF)),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                lsn.icon,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : (isIdioms ? const Color(0xFFD97706) : activeLevel.primaryColor),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isIdioms
                                    ? 'Bài 11: Thành ngữ & Tục ngữ'
                                    : 'Bài ${lsn.unitNumber}: ${lsn.title}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : (isIdioms ? const Color(0xFFB45309) : const Color(0xFF1E293B)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories_rounded, color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Thư viện riêng: ${_sentences.length} câu tự thêm của bạn',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      side: const BorderSide(color: Color(0xFFD97706)),
                    ),
                    icon: const Icon(Icons.add, size: 14, color: Color(0xFFD97706)),
                    label: const Text('Thêm câu', style: TextStyle(fontSize: 11, color: Color(0xFFD97706))),
                    onPressed: _openAddSentenceDialog,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),

          // 4. CARD HIỂN THỊ CÂU ĐANG LUYỆN TẬP
          if (_isLoadingSentences)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_sentences.isEmpty)
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFD2DAFF)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    const Icon(Icons.note_alt_outlined, size: 44, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'Chưa có câu nào trong bài này.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Bạn có thể tự thêm câu tiếng Anh của riêng mình để luyện tập ngay!',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Thêm câu của riêng bạn ngay'),
                      onPressed: _openAddSentenceDialog,
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              elevation: 2,
              shadowColor: const Color(0xFFB1B2FF).withAlpha(50),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFD2DAFF), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Badge tiêu đề bài & vị trí câu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isCustomLevel
                                ? '⭐ THƯ VIỆN CỦA TÔI • CÂU ${_selectedSentenceIndex + 1}/${_sentences.length}'
                                : '$_selectedLevelCode • ${activeLesson?.title.toUpperCase() ?? ""} • CÂU ${_selectedSentenceIndex + 1}/${_sentences.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF6C63FF),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (activeSentence != null && activeSentence.isCustom)
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 20, color: Color(0xFFD32F2F)),
                            tooltip: 'Xóa câu tự tạo này',
                            onPressed: () =>
                                _handleDeleteCustomSentence(activeSentence),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Thanh cuộn các số thứ tự câu (1, 2, 3...)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_sentences.length, (idx) {
                          final isSelected = _selectedSentenceIndex == idx;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() {
                                    _selectedSentenceIndex = idx;
                                    _recognizedText = null;
                                    _latestResult = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF6C63FF)
                                        : const Color(0xFFEEF1FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${idx + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF2D2B55),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Nội dung câu tiếng Anh
                    Text(
                      activeSentence?.sentence ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                        height: 1.3,
                      ),
                    ),
                    if (activeSentence?.ipa != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        activeSentence!.ipa!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Color(0xFF6C63FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'Ý nghĩa: ${activeSentence?.meaning ?? ""}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // =====================================================
          // 5. KHU VỰC THU ÂM & MICROPHONE (SPEECH RECOGNITION API)
          // =====================================================
          Card(
            elevation: 2,
            shadowColor: const Color(0xFFB1B2FF).withAlpha(50),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: _isRecording
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFFD2DAFF),
                width: _isRecording ? 2.0 : 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mic_rounded,
                        color: _isRecording
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thu âm & Xử lý phát âm AI',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2B55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nút Micro lớn
                  GestureDetector(
                    onTap: _isRecognizingSpeech ? null : _toggleRecording,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFFEEF1FF),
                        shape: BoxShape.circle,
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFD32F2F).withAlpha(120),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: const Color(0xFFB1B2FF).withAlpha(60),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        size: 42,
                        color: _isRecording ? Colors.white : const Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _isRecognizingSpeech
                        ? 'Đang nghe. Hãy đọc câu tiếng Anh để nhận dạng.'
                        : _isRecording
                            ? 'Đang ghi âm: 00:${_recordingSeconds.toString().padLeft(2, '0')} (Bấm nút đỏ để dừng)'
                            : _recordedAudioPath != null
                                ? 'Đã ghi âm xong. Bạn có thể nghe lại hoặc chấm điểm AI ngay!'
                                : 'Chạm vào Micro để bắt đầu luyện đọc câu này.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isRecording || _isRecognizingSpeech
                          ? const Color(0xFFD32F2F)
                          : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (_isRecording) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tín hiệu micro: ${_currentMicLevel.toStringAsFixed(0)} dBFS',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ((_currentMicLevel + 60) / 60)
                            .clamp(0.0, 1.0)
                            .toDouble(),
                        color: const Color(0xFFD32F2F),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],

                  if (_recordedAudioPath != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<PlayerState>(
                          stream: _audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final isPlaying =
                                snapshot.data?.playing ?? _audioPlayer.playing;
                            return OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF6C63FF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isRecognizingSpeech
                                  ? null
                                  : _playRecordedAudio,
                              icon: Icon(
                                isPlaying ? Icons.pause_rounded : Icons.replay,
                                color: const Color(0xFF6C63FF),
                                size: 18,
                              ),
                              label: Text(
                                isPlaying
                                    ? 'Tạm dừng'
                                    : 'Nghe lại bản thu',
                                style: const TextStyle(
                                  color: Color(0xFF6C63FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFEEF1FF),
                            foregroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isRecognizingSpeech
                              ? null
                              : _recognizeRecordedSpeech,
                          icon: _isRecognizingSpeech
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.record_voice_over, size: 18),
                          label: Text(
                            _isRecognizingSpeech ? 'Nhận dạng...' : 'Speech-to-Text',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_recognizedText != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF1FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.record_voice_over_outlined,
                              size: 18, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bạn đã đọc: "$_recognizedText"',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2B55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // =====================================================
          // 6. KHU VỰC ĐÁNH GIÁ PHÁT ÂM AI & CHẤM ĐIỂM
          // =====================================================
          Card(
            elevation: 2,
            shadowColor: const Color(0xFFB1B2FF).withAlpha(50),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFD2DAFF), width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF6C63FF)),
                      const SizedBox(width: 8),
                      Text(
                        'Đánh giá & Chấm điểm phát âm AI',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2B55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (_latestResult == null) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _isScoring ? null : _evaluatePronunciation,
                      icon: _isScoring
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.analytics_outlined),
                      label: Text(
                        _isScoring
                            ? 'Đang phân tích âm vị phát âm...'
                            : 'Chấm điểm phát âm AI',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Điểm số tổng quát (Chuẩn xanh lá #2E7D32, Lỗi đỏ #D32F2F)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withAlpha(15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF2E7D32).withAlpha(80)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScoreItem(
                            'Tổng điểm',
                            '${_latestResult!.overallScore?.toStringAsFixed(0) ?? "0"}/100',
                            const Color(0xFF2E7D32),
                          ),
                          Container(width: 1, height: 32, color: Colors.grey.shade300),
                          _buildScoreItem(
                            'Từ chuẩn ✅',
                            '${_latestResult!.wordScores?.where((w) => (w.score ?? 0) >= 80).length ?? 0}/${_latestResult!.wordScores?.length ?? 0}',
                            const Color(0xFF2E7D32),
                          ),
                          Container(width: 1, height: 32, color: Colors.grey.shade300),
                          _buildScoreItem(
                            'Từ cần sửa ❌',
                            '${_latestResult!.mispronouncedWords?.length ?? 0}',
                            const Color(0xFFD32F2F),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Nhận xét phản hồi AI
                    Text(
                      'Phản hồi AI: ${_latestResult!.feedback ?? ""}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2B55),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phân tích từng từ (Phoneme accuracy)
                    Text(
                      'Chi tiết từng từ (Xanh: Chuẩn, Đỏ: Cần cải thiện):',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: (_latestResult!.wordScores ?? []).map((w) {
                        final isGood = (w.score ?? 0) >= 80;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isGood
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isGood
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            '${w.word} (${w.score?.toInt() ?? 0}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isGood
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Cảnh báo âm vị sai (nếu có)
                    if ((_latestResult!.mispronouncedWords ?? []).isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFF97316).withAlpha(80)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                size: 18, color: Color(0xFFEA580C)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lỗi âm vị: ${_latestResult!.mispronouncedWords!.map((m) => "${m.word} (cần đọc ${m.expectedPhoneme})").join(", ")}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC2410C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (_latestResult!.suggestions != null &&
                        _latestResult!.suggestions!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '💡 Gợi ý cải thiện: ${_latestResult!.suggestions}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6C63FF),
                              side: const BorderSide(color: Color(0xFFB1B2FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.replay_rounded, size: 16),
                            label: const Text('Luyện lại'),
                            onPressed: () {
                              setState(() {
                                _recognizedText = null;
                                _recordedAudioPath = null;
                                _latestResult = null;
                              });
                            },
                          ),
                        ),
                        if (_selectedSentenceIndex < _sentences.length - 1) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                              label: const Text('Câu tiếp theo'),
                              onPressed: () {
                                setState(() {
                                  _selectedSentenceIndex++;
                                  _recognizedText = null;
                                  _recordedAudioPath = null;
                                  _latestResult = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
