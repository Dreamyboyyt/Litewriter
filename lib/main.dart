import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:litewriter/services/hive_service.dart';
import 'package:litewriter/theme/app_theme.dart';
import 'package:litewriter/views/home_view.dart';
import 'package:litewriter/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Litewriter',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
            home: const HomeView(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

