import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

/// Pantalla de intro animada según GDD v1.3
/// Secuencia: Título → Manos → Cartas → Arco → Carta roja → Menú
class IntroScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroScreen({super.key, required this.onComplete});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  int _currentFrame = 0;
  bool _showMenu = false;
  String _menuText = '';
  int _menuTextIndex = 0;

  @override
  void initState() {
    super.initState();
    _startIntroSequence();
  }

  void _startIntroSequence() async {
    // Frame 1: Título XI (1.5 seg)
    setState(() => _currentFrame = 0);
    await Future.delayed(const Duration(milliseconds: 1500));

    // Frame 2: Manos huesudas (0.5 seg)
    setState(() => _currentFrame = 1);
    await Future.delayed(const Duration(milliseconds: 500));

    // Frame 3: Carta + separación (1 seg)
    setState(() => _currentFrame = 2);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Frame 4: Arco de 10 cartas (0.3 seg)
    setState(() => _currentFrame = 3);
    await Future.delayed(const Duration(milliseconds: 300));

    // Frame 5: Carta roja central con flash (0.3 seg)
    setState(() => _currentFrame = 4);
    await Future.delayed(const Duration(milliseconds: 300));

    // Frame 6: Menú aparece letra por letra (0.4 seg)
    setState(() {
      _currentFrame = 5;
      _showMenu = true;
    });
    await _typeMenuText();

    // Esperar un poco antes de permitir interacción
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _typeMenuText() async {
    const menuItems = 'STORY · FREE PLAY · SETTINGS';
    for (int i = 0; i <= menuItems.length; i++) {
      if (!mounted) return;
      setState(() {
        _menuTextIndex = i;
        _menuText = menuItems.substring(0, i);
      });
      await Future.delayed(const Duration(milliseconds: 15));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onComplete,
      child: Scaffold(
        backgroundColor: XIColors.background,
        body: Center(
          child: _buildCurrentFrame(),
        ),
      ),
    );
  }

  Widget _buildCurrentFrame() {
    switch (_currentFrame) {
      case 0:
        return _buildTitleFrame();
      case 1:
        return _buildHandsFrame();
      case 2:
        return _buildCardsSeparatingFrame();
      case 3:
        return _buildArcFrame();
      case 4:
        return _buildRedCardFrame();
      case 5:
        return _buildMenuFrame();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Frame 1: Título XI - fade in, pausa, fade out
  Widget _buildTitleFrame() {
    return const Text(
      'XI',
      style: TextStyle(
        color: Colors.white,
        fontSize: 120,
        fontWeight: FontWeight.bold,
        letterSpacing: 20,
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .then(delay: 700.ms)
        .fadeOut(duration: 400.ms);
  }

  /// Frame 2: Manos huesudas entran desde los laterales
  Widget _buildHandsFrame() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSkeletonHand(isLeft: true)
            .animate()
            .slideX(begin: -2, end: 0, duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(duration: 300.ms),
        const SizedBox(width: 120),
        _buildSkeletonHand(isLeft: false)
            .animate()
            .slideX(begin: 2, end: 0, duration: 400.ms, curve: Curves.easeOut)
            .fadeIn(duration: 300.ms),
      ],
    );
  }

  /// Frame 3: Carta aparece y se clona mientras manos se separan
  Widget _buildCardsSeparatingFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, progress, child) {
        final cardCount = (progress * 10).ceil().clamp(1, 10);
        final separation = progress * 200;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Manos separándose
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-separation / 2, 0),
                  child: _buildSkeletonHand(isLeft: true),
                ),
                SizedBox(width: 120 + separation),
                Transform.translate(
                  offset: Offset(separation / 2, 0),
                  child: _buildSkeletonHand(isLeft: false),
                ),
              ],
            ),
            // Cartas multiplicándose
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cardCount, (i) {
                final offset = (i - (cardCount - 1) / 2) * 20;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: _buildCard(
                    index: i,
                    showSilhouette: false,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  /// Frame 4: Las 10 cartas forman un arco
  Widget _buildArcFrame() {
    return SizedBox(
      width: 350,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(10, (i) {
          final angle = (i - 4.5) * 0.12;
          final yOffset = (i - 4.5).abs() * 8;

          return Transform.translate(
            offset: Offset((i - 4.5) * 32, yOffset),
            child: Transform.rotate(
              angle: angle,
              child: _buildCard(
                index: i,
                showSilhouette: true,
                small: true,
              ),
            ),
          );
        })
            .animate(interval: 30.ms)
            .fadeIn(duration: 100.ms)
            .slideY(begin: 0.5, end: 0, duration: 200.ms),
      ),
    );
  }

  /// Frame 5: Carta roja (11) aparece en el centro con flash dorado
  Widget _buildRedCardFrame() {
    return SizedBox(
      width: 350,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arco de cartas azules
          ...List.generate(10, (i) {
            final angle = (i - 4.5) * 0.12;
            final yOffset = (i - 4.5).abs() * 8;

            return Transform.translate(
              offset: Offset((i - 4.5) * 32, yOffset - 30),
              child: Transform.rotate(
                angle: angle,
                child: _buildCard(
                  index: i,
                  showSilhouette: true,
                  small: true,
                ),
              ),
            );
          }),
          // Carta roja central con flash
          Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              color: XIColors.cardRed,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: XIColors.secondary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: XIColors.primary.withValues(alpha: 0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'XI',
                style: TextStyle(
                  color: XIColors.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              .animate()
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 200.ms)
              .shimmer(duration: 300.ms, color: XIColors.primary),
        ],
      ),
    );
  }

  /// Frame 6: Menú aparece letra por letra sobre la carta roja
  Widget _buildMenuFrame() {
    return SizedBox(
      width: 350,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arco de cartas azules
          ...List.generate(10, (i) {
            final angle = (i - 4.5) * 0.12;
            final yOffset = (i - 4.5).abs() * 8;

            return Transform.translate(
              offset: Offset((i - 4.5) * 32, yOffset - 50),
              child: Transform.rotate(
                angle: angle,
                child: _buildCard(
                  index: i,
                  showSilhouette: true,
                  small: true,
                ),
              ),
            );
          }),
          // Carta roja central con menú
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              color: XIColors.cardRed,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: XIColors.secondary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: XIColors.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'XI',
                  style: TextStyle(
                    color: XIColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 1,
                  color: XIColors.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                _buildMenuItem('STORY', 0),
                _buildMenuItem('FREE', 1),
                _buildMenuItem('CONFIG', 2),
              ],
            ),
          ),
          // Texto "Toca para continuar"
          Positioned(
            bottom: 0,
            child: Text(
              'Toca para continuar',
              style: TextStyle(
                color: XIColors.textMuted.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ).animate(onPlay: (c) => c.repeat()).fadeIn().then().fadeOut(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, int index) {
    final delay = index * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: XIColors.textSecondary,
          fontSize: 8,
          letterSpacing: 1,
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 150.ms);
  }

  /// Mano esquelética pixel art
  Widget _buildSkeletonHand({required bool isLeft}) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: XIColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: XIColors.textMuted.withValues(alpha: 0.5), width: 1),
      ),
      child: CustomPaint(
        painter: _SkeletonHandPainter(isLeft: isLeft),
      ),
    );
  }

  /// Carta del mazo con silueta opcional
  Widget _buildCard({
    required int index,
    bool showSilhouette = false,
    bool small = false,
  }) {
    final width = small ? 28.0 : 40.0;
    final height = small ? 42.0 : 60.0;

    // Nombres de personajes para las cartas
    final names = ['OWEN', 'NORA', '???', '???', '???', '???', '???', '???', '???', '???'];
    final cardValues = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: XIColors.cardBlue,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: index < 2 ? XIColors.primary : XIColors.textMuted.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
              color: index < 2 ? XIColors.primary : XIColors.textMuted,
              fontSize: small ? 10 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showSilhouette && !small) ...[
            const SizedBox(height: 2),
            // Silueta simplificada
            Container(
              width: 20,
              height: 15,
              decoration: BoxDecoration(
                color: XIColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              names[index],
              style: TextStyle(
                color: XIColors.textMuted.withValues(alpha: 0.7),
                fontSize: 5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Painter para dibujar manos esqueléticas
class _SkeletonHandPainter extends CustomPainter {
  final bool isLeft;

  _SkeletonHandPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Palma
    canvas.drawCircle(Offset(centerX, centerY + 10), 12, paint);

    // Dedos (5 líneas)
    for (int i = 0; i < 5; i++) {
      final angle = (isLeft ? -1 : 1) * (i - 2) * 0.25;
      final startX = centerX + (i - 2) * 6;
      final startY = centerY - 5;
      final endX = startX + (isLeft ? -1 : 1) * angle * 15;
      final endY = startY - 20;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
