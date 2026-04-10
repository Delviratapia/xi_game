import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

/// Pantalla de intro según GDD v1.4
/// Secuencia: Título → Manos → Cartas en CÍRCULO → Carta roja → Menú
class IntroScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroScreen({super.key, required this.onComplete});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  int _currentFrame = 0;

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

    // Frame 3: Carta + separación en círculo (1 seg)
    setState(() => _currentFrame = 2);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Frame 4: Círculo de 10 cartas (0.3 seg)
    setState(() => _currentFrame = 3);
    await Future.delayed(const Duration(milliseconds: 300));

    // Frame 5: Carta roja central con flash (0.3 seg)
    setState(() => _currentFrame = 4);
    await Future.delayed(const Duration(milliseconds: 300));

    // Frame 6: Menú aparece (0.4 seg)
    setState(() => _currentFrame = 5);
    await Future.delayed(const Duration(milliseconds: 800));
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
        return _buildCardsExpandingFrame();
      case 3:
        return _buildCircleFrame();
      case 4:
        return _buildRedCardFrame();
      case 5:
        return _buildFinalFrame();
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
        fontSize: 100,
        fontWeight: FontWeight.bold,
        letterSpacing: 20,
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .then(delay: 700.ms)
        .fadeOut(duration: 400.ms);
  }

  /// Frame 2: Manos huesudas entran
  Widget _buildHandsFrame() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSkeletonHand(isLeft: true)
            .animate()
            .slideX(begin: -2, end: 0, duration: 400.ms)
            .fadeIn(duration: 300.ms),
        const SizedBox(width: 200),
        _buildSkeletonHand(isLeft: false)
            .animate()
            .slideX(begin: 2, end: 0, duration: 400.ms)
            .fadeIn(duration: 300.ms),
      ],
    );
  }

  /// Frame 3: Carta se clona y expande en círculo
  Widget _buildCardsExpandingFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, progress, child) {
        final cardCount = (progress * 10).ceil().clamp(1, 10);
        final radius = progress * 100;

        return SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Manos separándose
              Positioned(
                left: 20 - progress * 60,
                child: Opacity(
                  opacity: 1 - progress * 0.3,
                  child: _buildSkeletonHand(isLeft: true),
                ),
              ),
              Positioned(
                right: 20 - progress * 60,
                child: Opacity(
                  opacity: 1 - progress * 0.3,
                  child: _buildSkeletonHand(isLeft: false),
                ),
              ),
              // Cartas expandiéndose en círculo
              ...List.generate(cardCount, (i) {
                final angle = (i / 10) * 2 * math.pi - math.pi / 2;
                return Transform.translate(
                  offset: Offset(
                    math.cos(angle) * radius,
                    math.sin(angle) * radius,
                  ),
                  child: Transform.rotate(
                    angle: angle + math.pi / 2,
                    child: _buildCard(i),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Frame 4: Círculo completo de 10 cartas
  Widget _buildCircleFrame() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Manos a los lados
          Positioned(left: 0, child: _buildSkeletonHand(isLeft: true)),
          Positioned(right: 0, child: _buildSkeletonHand(isLeft: false)),
          // Círculo de cartas
          ...List.generate(10, (i) {
            final angle = (i / 10) * 2 * math.pi - math.pi / 2;
            const radius = 110.0;
            return Transform.translate(
              offset: Offset(
                math.cos(angle) * radius,
                math.sin(angle) * radius,
              ),
              child: Transform.rotate(
                angle: angle + math.pi / 2,
                child: _buildCard(i, showDetails: true),
              ),
            );
          })
              .animate(interval: 30.ms)
              .fadeIn(duration: 100.ms),
        ],
      ),
    );
  }

  /// Frame 5: Carta roja aparece en el centro con flash
  Widget _buildRedCardFrame() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Manos
          Positioned(left: 0, child: _buildSkeletonHand(isLeft: true)),
          Positioned(right: 0, child: _buildSkeletonHand(isLeft: false)),
          // Círculo de cartas
          ...List.generate(10, (i) {
            final angle = (i / 10) * 2 * math.pi - math.pi / 2;
            const radius = 110.0;
            return Transform.translate(
              offset: Offset(
                math.cos(angle) * radius,
                math.sin(angle) * radius,
              ),
              child: Transform.rotate(
                angle: angle + math.pi / 2,
                child: _buildCard(i, showDetails: true),
              ),
            );
          }),
          // Carta roja central
          Container(
            width: 60,
            height: 85,
            decoration: BoxDecoration(
              color: XIColors.cardRed,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: XIColors.secondary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: XIColors.primary.withValues(alpha: 0.7),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'XI',
                style: TextStyle(
                  color: XIColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              .animate()
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 200.ms)
              .shimmer(duration: 400.ms, color: XIColors.primary),
        ],
      ),
    );
  }

  /// Frame 6: Frame final con menú
  Widget _buildFinalFrame() {
    return SizedBox(
      width: 320,
      height: 380,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Manos
          Positioned(left: 0, top: 50, child: _buildSkeletonHand(isLeft: true)),
          Positioned(right: 0, top: 50, child: _buildSkeletonHand(isLeft: false)),
          // Círculo de cartas
          ...List.generate(10, (i) {
            final angle = (i / 10) * 2 * math.pi - math.pi / 2;
            const radius = 110.0;
            return Transform.translate(
              offset: Offset(
                math.cos(angle) * radius,
                math.sin(angle) * radius,
              ),
              child: Transform.rotate(
                angle: angle + math.pi / 2,
                child: _buildCard(i, showDetails: true),
              ),
            );
          }),
          // Carta roja central con menú
          Container(
            width: 80,
            height: 110,
            decoration: BoxDecoration(
              color: XIColors.cardRed,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: XIColors.secondary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: XIColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(width: 30, height: 1, color: XIColors.primary.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                _buildMiniMenuItem('STORY'),
                _buildMiniMenuItem('FREE PLAY'),
                _buildMiniMenuItem('CONFIG'),
              ],
            ),
          ),
          // Indicador de continuar
          Positioned(
            bottom: 0,
            child: Text(
              'Toca para continuar',
              style: TextStyle(
                color: XIColors.textMuted.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn().then().fadeOut(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMenuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: XIColors.textSecondary,
          fontSize: 7,
          letterSpacing: 0.5,
        ),
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 150.ms);
  }

  Widget _buildSkeletonHand({required bool isLeft}) {
    return SizedBox(
      width: 50,
      height: 80,
      child: CustomPaint(
        painter: _SkeletonHandPainter(isLeft: isLeft),
      ),
    );
  }

  Widget _buildCard(int index, {bool showDetails = false}) {
    final cardValues = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
    final names = ['OWEN', 'NORA', '???', '???', '???', '???', '???', '???', '???', '???'];
    final isUnlocked = index < 2;

    return Container(
      width: 35,
      height: 50,
      decoration: BoxDecoration(
        color: XIColors.cardBlue,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isUnlocked ? XIColors.primary : XIColors.textMuted.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: showDetails
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cardValues[index],
                  style: TextStyle(
                    color: isUnlocked ? XIColors.primary : XIColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isUnlocked) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 15,
                    height: 12,
                    color: XIColors.background.withValues(alpha: 0.5),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  names[index],
                  style: TextStyle(
                    color: XIColors.textMuted.withValues(alpha: 0.6),
                    fontSize: 4,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'XI',
                style: TextStyle(
                  color: XIColors.primary.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}

/// Painter para manos esqueléticas
class _SkeletonHandPainter extends CustomPainter {
  final bool isLeft;

  _SkeletonHandPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final palmY = size.height * 0.6;

    // Palma
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, palmY), width: 25, height: 30),
      paint,
    );

    // Dedos
    final fingerLengths = [22.0, 30.0, 32.0, 28.0, 18.0];
    final fingerAngles = isLeft
        ? [-0.4, -0.2, 0.0, 0.2, 0.4]
        : [0.4, 0.2, 0.0, -0.2, -0.4];

    for (int i = 0; i < 5; i++) {
      final startX = centerX + (i - 2) * 5;
      final startY = palmY - 12;
      final angle = fingerAngles[i];
      final length = fingerLengths[i];

      final endX = startX + math.sin(angle) * length;
      final endY = startY - math.cos(angle) * length;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      canvas.drawCircle(Offset(startX, startY), 2, paint);
    }

    // Muñeca
    canvas.drawLine(
      Offset(centerX, palmY + 15),
      Offset(centerX, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
