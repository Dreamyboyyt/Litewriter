import 'package:hive_flutter/hive_flutter.dart';
import 'package:litewriter/models/chapter.dart';
import 'package:litewriter/models/character.dart';
import 'package:litewriter/models/note.dart';
import 'package:litewriter/models/plot.dart';
import 'package:litewriter/models/project.dart';
import 'package:litewriter/models/theme.dart';
import 'package:litewriter/models/writing_goal.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(ChapterAdapter());
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(PlotAdapter());
    Hive.registerAdapter(ThemeAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(WritingGoalAdapter());
  }

  Future<Box<Project>> get projectBox async =>
      await Hive.openBox<Project>('projects');
  Future<Box<Chapter>> get chapterBox async =>
      await Hive.openBox<Chapter>('chapters');
  Future<Box<Character>> get characterBox async =>
      await Hive.openBox<Character>('characters');
  Future<Box<Plot>> get plotBox async => await Hive.openBox<Plot>('plots');
  Future<Box<Theme>> get themeBox async => await Hive.openBox<Theme>('themes');
  Future<Box<Note>> get noteBox async => await Hive.openBox<Note>('notes');
  Future<Box<WritingGoal>> get writingGoalBox async =>
      await Hive.openBox<WritingGoal>('writing_goals');
}

