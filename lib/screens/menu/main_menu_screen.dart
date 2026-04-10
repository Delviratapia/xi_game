import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import '../story/character_select_screen.dart';
import '../game/game_screen.dart';
import '../settings/settings_screen.dart';

/// Menú principal según GDD v1.4
/// CÍRCULO de 10 cartas con siluetas + manos huesudas a los lados
/// Carta roja central = menú XI
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  int? _hoveredCardIndex;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 20;

    return Scaffold(
      backgroundColor: XIColors.background,
      body: Stack(
        children: [
          // Fondo con partículas sutiles
          _buildBackground(),

          // Mano izquierda
          Positioned(
            left: 10,
            top: centerY - 60,
            child: _buildSkeletonHand(isLeft: true),
          ),

          // Mano derecha
          Positioned(
            right: 10,
            top: centerY - 60,
            child: _buildSkeletonHand(isLeft: false),
          ),

          // Círculo de cartas de personajes
          Center(
            child: SizedBox(
              width: size.width * 0.85,
              height: size.width * 0.85,
              child: _buildCardCircle(),
            ),
          ),

          // Carta roja central con menú
          Center(
            child: _buildCentralMenuCard(),
          ),

          // Quote de The Gatekeeper
          Positioned(
            bottom: 30,
            left: 40,
            right: 40,
            child: _buildGatekeeperQuote(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF151515),
            Color(0xFF0a0a0a),
            Color(0xFF050505),
          ],
        ),
      ),
    );
  }

  /// Manos huesudas pixel art
  Widget _buildSkeletonHand({required bool isLeft}) {
    return SizedBox(
      width: 60,
      height: 120,
      child: CustomPaint(
        painter: _SkeletonHandPainter(isLeft: isLeft),
      ),
    )
        .animate(delay: 300.ms)
        .fadeIn(duration: 500.ms)
        .slideX(
          begin: isLeft ? -1 : 1,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  /// Círculo de 10 cartas con siluetas de personajes
  Widget _buildCardCircle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(10, (index) {
            // Ángulo para cada carta en el círculo
            final angle = (index / 10) * 2 * math.pi - math.pi / 2;
            final radius = 130.0;

            return Transform.translate(
              offset: Offset(
                math.cos(angle) * radius,
                math.sin(angle) * radius,
              ),
              child: Transform.rotate(
                angle: angle + math.pi / 2, // Rotar para que miren hacia afuera
                child: GestureDetector(
                  onTap: () => _onCardTap(index),
                  onTapDown: (_) => setState(() => _hoveredCardIndex = index),
                  onTapUp: (_) => setState(() => _hoveredCardIndex = null),
                  onTapCancel: () => setState(() => _hoveredCardIndex = null),
                  child: _buildCharacterCard(index),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Carta de personaje con silueta e ilustración del reverso
  Widget _buildCharacterCard(int index) {
    final isUnlocked = index < 2;
    final isHovered = _hoveredCardIndex == index;

    final cardValues = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
    final names = ['OWEN', 'NORA', '???', '???', '???', '???', '???', '???', '???', '???'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 45,
      height: 65,
      transform: isHovered ? (Matrix4.identity()..scale(1.15)) : Matrix4.identity(),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isUnlocked
              ? (isHovered ? XIColors.primaryLight : XIColors.primary)
              : XIColors.textMuted.withValues(alpha: 0.3),
          width: isHovered ? 2 : 1,
        ),
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: XIColors.primary.withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            // Reverso del mazo (único por personaje)
            _buildCardBack(index, isUnlocked),

            // Silueta del personaje superpuesta
            Center(
              child: _buildSilhouette(index, isUnlocked),
            ),

            // Valor de la carta (arriba)
            Positioned(
              top: 3,
              left: 4,
              child: Text(
                cardValues[index],
                style: TextStyle(
                  color: isUnlocked
                      ? XIColors.primary.withValues(alpha: 0.9)
                      : XIColors.textMuted.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Nombre (abajo)
            Positioned(
              bottom: 2,
              left: 0,
              right: 0,
              child: Text(
                names[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnlocked
                      ? XIColors.textSecondary
                      : XIColors.textMuted.withValues(alpha: 0.4),
                  fontSize: 5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 + index * 50)).fadeIn(duration: 400.ms);
  }

  /// Reverso del mazo según personaje
  Widget _buildCardBack(int index, bool isUnlocked) {
    if (!isUnlocked) {
      return Container(color: const Color(0xFF1a1a1a));
    }

    if (index == 0) {
      // Owen: partituras incompletas
      return Container(
        color: const Color(0xFF0d0d0d),
        child: CustomPaint(
          painter: _OwenCardBackPainter(),
        ),
      );
    } else {
      // Nora: electrocardiograma
      return Container(
        color: const Color(0xFF0a0d0a),
        child: CustomPaint(
          painter: _NoraCardBackPainter(),
        ),
      );
    }
  }

  /// Silueta del personaje
  Widget _buildSilhouette(int index, bool isUnlocked) {
    if (!isUnlocked) {
      return const Text(
        '?',
        style: TextStyle(
          color: XIColors.textMuted,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return SizedBox(
      width: 25,
      height: 30,
      child: CustomPaint(
        painter: _SilhouettePainter(characterIndex: index),
      ),
    );
  }

  /// Carta roja central con menú XI
  Widget _buildCentralMenuCard() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.02);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 110,
        height: 150,
        decoration: BoxDecoration(
          color: XIColors.cardRed,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: XIColors.secondary, width: 2),
          boxShadow: [
            BoxShadow(
              color: XIColors.secondary.withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 15,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // XI
            const Text(
              'XI',
              style: TextStyle(
                color: XIColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 4),
            Container(width: 50, height: 1, color: XIColors.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),

            // Opciones
            _buildMenuOption('STORY', Icons.auto_stories, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CharacterSelectScreen()));
            }),
            _buildMenuOption('FREE PLAY', Icons.casino, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          GameScreen(gameState: GameState.newGame(mode: GameMode.freePlay))));
            }),
            _buildMenuOption('GAMBLE FREE', Icons.sports_esports, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          GameScreen(gameState: GameState.newGame(mode: GameMode.gambleFree))));
            }),
            const SizedBox(height: 6),
            _buildMenuOption('CONFIG', Icons.settings, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            }, small: true),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 500.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 500.ms,
        );
  }

  Widget _buildMenuOption(String text, IconData icon, VoidCallback onTap, {bool small = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: small ? 1 : 3),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: small ? 3 : 5),
        decoration: BoxDecoration(
          color: XIColors.background.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: XIColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: XIColors.primary, size: small ? 10 : 12),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: XIColors.textPrimary,
                fontSize: small ? 7 : 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatekeeperQuote() {
    return Text(
      XIStrings.gatekeeperQuote,
      style: TextStyle(
        color: XIColors.textMuted.withValues(alpha: 0.5),
        fontSize: 10,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms);
  }

  void _onCardTap(int index) {
    if (index < 2) {
      final character = index == 0 ? owen : nora;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacterSelectScreen(preselectedCharacter: character),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Próximamente...'),
          backgroundColor: XIColors.surface,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}

/// Painter para manos esqueléticas
class _SkeletonHandPainter extends CustomPainter {
  final bool isLeft;

  _SkeletonHandPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = XIColors.surface.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final palmY = size.height * 0.6;

    // Palma
    final palmPath = Path();
    palmPath.addOval(Rect.fromCenter(
      center: Offset(centerX, palmY),
      width: 35,
      height: 45,
    ));
    canvas.drawPath(palmPath, fillPaint);
    canvas.drawPath(palmPath, paint);

    // Dedos (5)
    final fingerLengths = [35.0, 45.0, 50.0, 45.0, 30.0];
    final fingerAngles = isLeft
        ? [-0.5, -0.25, 0.0, 0.25, 0.5]
        : [0.5, 0.25, 0.0, -0.25, -0.5];

    for (int i = 0; i < 5; i++) {
      final startX = centerX + (i - 2) * 7;
      final startY = palmY - 20;
      final angle = fingerAngles[i];
      final length = fingerLengths[i];

      // Hueso del dedo
      final endX = startX + math.sin(angle) * length;
      final endY = startY - math.cos(angle) * length;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Nudillo
      canvas.drawCircle(Offset(startX, startY), 3, paint);
      canvas.drawCircle(
        Offset(startX + math.sin(angle) * length * 0.5, startY - math.cos(angle) * length * 0.5),
        2,
        paint,
      );
    }

    // Muñeca
    canvas.drawLine(
      Offset(centerX, palmY + 22),
      Offset(centerX, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reverso de carta Owen: partituras incompletas
class _OwenCardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.primary.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Líneas de pentagrama
    for (int i = 0; i < 5; i++) {
      final y = size.height * 0.3 + i * 4;
      canvas.drawLine(Offset(5, y), Offset(size.width - 5, y), paint);
    }

    for (int i = 0; i < 5; i++) {
      final y = size.height * 0.6 + i * 4;
      canvas.drawLine(Offset(5, y), Offset(size.width - 5, y), paint);
    }

    // Nota musical incompleta en el centro
    paint.style = PaintingStyle.fill;
    paint.color = XIColors.primary.withValues(alpha: 0.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 8,
        height: 6,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reverso de carta Nora: electrocardiograma
class _NoraCardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2a4a2a).withValues(alpha: 0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;

    // Línea de ECG
    path.moveTo(0, centerY);
    path.lineTo(size.width * 0.2, centerY);
    path.lineTo(size.width * 0.25, centerY - 5);
    path.lineTo(size.width * 0.3, centerY + 8);
    path.lineTo(size.width * 0.35, centerY - 12);
    path.lineTo(size.width * 0.4, centerY);
    // Flatline
    path.lineTo(size.width, centerY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Siluetas de personajes
class _SilhouettePainter extends CustomPainter {
  final int characterIndex;

  _SilhouettePainter({required this.characterIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textPrimary.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;

    if (characterIndex == 0) {
      // Owen: sentado con cabeza inclinada
      canvas.drawCircle(Offset(centerX, 6), 5, paint);
      canvas.drawRect(Rect.fromLTWH(centerX - 7, 11, 14, 12), paint);
      // Mesa
      paint.color = XIColors.primary.withValues(alpha: 0.3);
      canvas.drawRect(Rect.fromLTWH(2, 23, size.width - 4, 3), paint);
    } else {
      // Nora: de pie con clipboard
      canvas.drawCircle(Offset(centerX, 5), 4, paint);
      canvas.drawRect(Rect.fromLTWH(centerX - 5, 9, 10, 15), paint);
      // Clipboard
      paint.color = XIColors.primary.withValues(alpha: 0.4);
      canvas.drawRect(Rect.fromLTWH(centerX + 4, 12, 4, 6), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
