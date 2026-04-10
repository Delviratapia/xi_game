import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import '../story/character_select_screen.dart';
import '../game/game_screen.dart';
import '../settings/settings_screen.dart';

/// Menú principal según GDD v1.3
/// Arco de 11 cartas con siluetas. Carta roja central = menú.
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int? _hoveredCardIndex;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XIColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            // Arco de cartas de personajes (cartas 1-10)
            _buildCharacterArc(),
            const SizedBox(height: 20),
            // Carta roja central con menú (carta 11)
            _buildCentralMenuCard(),
            const Spacer(flex: 2),
            // Quote de The Gatekeeper
            _buildGatekeeperQuote(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Arco de 10 cartas con siluetas de personajes
  Widget _buildCharacterArc() {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(10, (index) {
          final angle = (index - 4.5) * 0.1;
          final yOffset = (index - 4.5).abs() * 6;
          final xOffset = (index - 4.5) * 38;

          return Transform.translate(
            offset: Offset(xOffset, yOffset),
            child: Transform.rotate(
              angle: angle,
              child: GestureDetector(
                onTap: () => _onCardTap(index),
                onTapDown: (_) => setState(() => _hoveredCardIndex = index),
                onTapUp: (_) => setState(() => _hoveredCardIndex = null),
                onTapCancel: () => setState(() => _hoveredCardIndex = null),
                child: _buildCharacterCard(index),
              ),
            ),
          )
              .animate(delay: Duration(milliseconds: index * 50))
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.5, end: 0, duration: 400.ms);
        }),
      ),
    );
  }

  /// Carta de personaje con silueta integrada
  Widget _buildCharacterCard(int index) {
    final isUnlocked = index < 2; // Solo Owen y Nora desbloqueados
    final isHovered = _hoveredCardIndex == index;
    final isOwenReturns = index == 10; // Carta 11

    // Datos del personaje
    final cardValues = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
    final names = ['OWEN', 'NORA', '???', '???', '???', '???', '???', '???', '???', '???'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 55,
      height: 80,
      transform: isHovered ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
      decoration: BoxDecoration(
        color: XIColors.cardBlue,
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
                  color: XIColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Valor de la carta
          Text(
            cardValues[index],
            style: TextStyle(
              color: isUnlocked ? XIColors.primary : XIColors.textMuted.withValues(alpha: 0.5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Silueta del personaje
          _buildSilhouette(index, isUnlocked),
          const SizedBox(height: 4),
          // Nombre del personaje
          Text(
            names[index],
            style: TextStyle(
              color: isUnlocked
                  ? XIColors.textSecondary
                  : XIColors.textMuted.withValues(alpha: 0.4),
              fontSize: 7,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Silueta del personaje (pixel art simplificado)
  Widget _buildSilhouette(int index, bool isUnlocked) {
    if (!isUnlocked) {
      // Silueta con signo de interrogación para personajes bloqueados
      return Container(
        width: 30,
        height: 25,
        decoration: BoxDecoration(
          color: XIColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(
              color: XIColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Siluetas específicas para Owen y Nora
    return Container(
      width: 30,
      height: 25,
      decoration: BoxDecoration(
        color: XIColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(2),
      ),
      child: CustomPaint(
        painter: _SilhouettePainter(characterIndex: index),
      ),
    );
  }

  /// Carta roja central con las opciones del menú
  Widget _buildCentralMenuCard() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.02);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 140,
        height: 200,
        decoration: BoxDecoration(
          color: XIColors.cardRed,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: XIColors.secondary, width: 2),
          boxShadow: [
            BoxShadow(
              color: XIColors.secondary.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título XI
            const Text(
              'XI',
              style: TextStyle(
                color: XIColors.primary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 60,
              height: 1,
              color: XIColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            // Opciones del menú
            _buildMenuOption('STORY MODE', Icons.auto_stories, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CharacterSelectScreen()),
              );
            }),
            _buildMenuOption('FREE PLAY', Icons.casino, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    gameState: GameState.newGame(mode: GameMode.freePlay),
                  ),
                ),
              );
            }),
            _buildMenuOption('GAMBLE FREE', Icons.sports_esports, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    gameState: GameState.newGame(mode: GameMode.gambleFree),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            _buildMenuOption('SETTINGS', Icons.settings, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }, small: true),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms);
  }

  Widget _buildMenuOption(
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool small = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: small ? 2 : 4,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: small ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: XIColors.background.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: XIColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: XIColors.primary,
              size: small ? 12 : 14,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: XIColors.textPrimary,
                fontSize: small ? 9 : 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quote de The Gatekeeper
  Widget _buildGatekeeperQuote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        XIStrings.gatekeeperQuote,
        style: TextStyle(
          color: XIColors.textMuted.withValues(alpha: 0.6),
          fontSize: 11,
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 600.ms);
  }

  void _onCardTap(int index) {
    if (index < 2) {
      // Personaje desbloqueado - ir a selección
      final character = index == 0 ? owen : nora;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacterSelectScreen(preselectedCharacter: character),
        ),
      );
    } else {
      // Personaje bloqueado - mostrar mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Próximamente...'),
          backgroundColor: XIColors.surface,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}

/// Painter para siluetas de personajes
class _SilhouettePainter extends CustomPainter {
  final int characterIndex;

  _SilhouettePainter({required this.characterIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    if (characterIndex == 0) {
      // Owen: silueta sentada con cabeza inclinada sobre mesa
      // Cabeza
      canvas.drawCircle(Offset(centerX, centerY - 4), 5, paint);
      // Cuerpo inclinado
      canvas.drawRect(
        Rect.fromLTWH(centerX - 6, centerY, 12, 10),
        paint,
      );
      // Mesa (línea horizontal)
      canvas.drawRect(
        Rect.fromLTWH(2, size.height - 4, size.width - 4, 2),
        paint,
      );
    } else if (characterIndex == 1) {
      // Nora: silueta de pie con clipboard
      // Cabeza
      canvas.drawCircle(Offset(centerX, centerY - 6), 4, paint);
      // Cuerpo de pie
      canvas.drawRect(
        Rect.fromLTWH(centerX - 5, centerY - 2, 10, 14),
        paint,
      );
      // Clipboard
      canvas.drawRect(
        Rect.fromLTWH(centerX + 4, centerY + 2, 4, 6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
