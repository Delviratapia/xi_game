import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/theme.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/menu/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación (solo portrait para móvil)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar barra de estado transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: XITheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const XIGame());
}

/// Aplicación principal de XI
class XIGame extends StatelessWidget {
  const XIGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XI',
      debugShowCheckedModeBanner: false,
      theme: XITheme.darkTheme,
      home: const AppEntry(),
    );
  }
}

/// Punto de entrada que maneja la intro y el menú
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showIntro = true;

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return IntroScreen(
        onComplete: () {
          setState(() => _showIntro = false);
        },
      );
    }

    return const MainMenuScreen();
  }
}
