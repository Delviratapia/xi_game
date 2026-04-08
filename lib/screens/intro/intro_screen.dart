import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Pantalla de intro animada
/// Secuencia de frames según el GDD
class IntroScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroScreen({super.key, required this.onComplete});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  int _currentFrame = 0;
  late AnimationController _fadeController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: XIAnimations.dramatic,
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _startIntroSequence();
  }

  void _startIntroSequence() async {
    // Frame 1: Título XI
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    await Future.delayed(const Duration(seconds: 2));
    _fadeController.reverse();
    await Future.delayed(XIAnimations.dramatic);

    // Frame 2-6: Animación de cartas
    for (int i = 1; i <= 5; i++) {
      setState(() => _currentFrame = i);
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Frame 7: Transición al menú
    setState(() => _currentFrame = 6);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onComplete, // Skip intro on tap
      child: Scaffold(
        backgroundColor: XITheme.background,
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
        return _buildCardAppearFrame();
      case 3:
        return _buildCardsMultiplyFrame();
      case 4:
        return _buildArcFrame();
      case 5:
        return _buildFinalArcFrame();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Frame 1: Título XI aparece y se desvanece
  Widget _buildTitleFrame() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Text(
        'XI',
        style: TextStyle(
          color: XITheme.primary,
          fontSize: 120,
          fontWeight: FontWeight.bold,
          letterSpacing: 20,
        ),
      ),
    );
  }

  /// Frame 2: Dos manos huesudas aparecen
  Widget _buildHandsFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: XIAnimations.slow,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-100 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildHand(isLeft: true),
              ),
            ),
            const SizedBox(width: 100),
            Transform.translate(
              offset: Offset(100 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildHand(isLeft: false),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Frame 3: Carta aparece entre las manos
  Widget _buildCardAppearFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: XIAnimations.slow,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHand(isLeft: true),
                const SizedBox(width: 100),
                _buildHand(isLeft: false),
              ],
            ),
            Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _buildCard(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Frame 4: Las cartas se multiplican
  Widget _buildCardsMultiplyFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 10.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        final cardCount = value.floor();
        return Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-value * 10, 0),
                  child: _buildHand(isLeft: true),
                ),
                SizedBox(width: 100 + value * 20),
                Transform.translate(
                  offset: Offset(value * 10, 0),
                  child: _buildHand(isLeft: false),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cardCount, (i) {
                final offset = (i - cardCount / 2) * 25;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: _buildCard(small: true),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  /// Frame 5: Las cartas forman un arco
  Widget _buildArcFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: XIAnimations.slow,
      builder: (context, value, child) {
        return CustomPaint(
          size: const Size(300, 200),
          painter: _CardArcPainter(
            progress: value,
            cardCount: 10,
          ),
        );
      },
    );
  }

  /// Frame 6: Arco completo con carta roja central
  Widget _buildFinalArcFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: XIAnimations.slow,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(300, 200),
              painter: _CardArcPainter(
                progress: 1.0,
                cardCount: 10,
              ),
            ),
            Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _buildCard(isRed: true),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHand({required bool isLeft}) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: XITheme.textMuted, width: 1),
      ),
      child: Icon(
        isLeft ? Icons.back_hand : Icons.front_hand,
        color: XITheme.textMuted,
        size: 40,
      ),
    );
  }

  Widget _buildCard({bool small = false, bool isRed = false}) {
    final size = small ? 40.0 : 60.0;
    return Container(
      width: size,
      height: size * 1.5,
      decoration: BoxDecoration(
        color: isRed ? XITheme.cardRed : XITheme.cardBlue,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isRed ? XITheme.secondary : XITheme.primary,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          'XI',
          style: TextStyle(
            color: isRed ? XITheme.secondary : XITheme.primary,
            fontSize: small ? 12 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Painter para dibujar el arco de cartas
class _CardArcPainter extends CustomPainter {
  final double progress;
  final int cardCount;

  _CardArcPainter({required this.progress, required this.cardCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XITheme.cardBlue
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = XITheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerX = size.width / 2;
    final centerY = size.height + 50;
    final radius = size.width / 2;

    for (int i = 0; i < cardCount; i++) {
      final angle = -3.14159 / 2 + (i / (cardCount - 1) - 0.5) * 3.14159 * 0.8;
      final x = centerX + radius * (1 - progress * 0.3) * (i / cardCount - 0.5) * 2;
      final y = centerY - radius * progress * (0.5 + 0.3 * (1 - ((i / cardCount - 0.5).abs() * 2)));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle * progress);

      final cardRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 30, height: 45),
        const Radius.circular(4),
      );

      canvas.drawRRect(cardRect, paint);
      canvas.drawRRect(cardRect, borderPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CardArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
