import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import '../game/game_screen.dart';

/// Escena introductoria del personaje según GDD v1.3
/// Muestra al personaje todavía vivo en su mundo
/// Diálogos estilo novela visual sin ventana
class CharacterIntroScreen extends StatefulWidget {
  final StoryCharacter character;

  const CharacterIntroScreen({super.key, required this.character});

  @override
  State<CharacterIntroScreen> createState() => _CharacterIntroScreenState();
}

class _CharacterIntroScreenState extends State<CharacterIntroScreen>
    with TickerProviderStateMixin {
  int _currentLineIndex = 0;
  bool _isTransitioning = false;
  late List<DialogueLine> _dialogueLines;

  @override
  void initState() {
    super.initState();
    _dialogueLines = widget.character.introScene;
  }

  void _advanceDialogue() {
    if (_isTransitioning) return;

    if (_currentLineIndex < _dialogueLines.length - 1) {
      setState(() {
        _currentLineIndex++;
      });

      // Verificar si es la línea de transición
      if (_dialogueLines[_currentLineIndex].type == DialogueType.transitionStart) {
        _startDeathTransition();
      }
    } else {
      // Fin de la intro, ir al juego
      _goToGame();
    }
  }

  void _startDeathTransition() {
    setState(() => _isTransitioning = true);

    // Transición imperceptible después de un delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _goToGame();
      }
    });
  }

  void _goToGame() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GameScreen(
          gameState: GameState.newGame(
            mode: GameMode.story,
            characterId: widget.character.id,
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Transición sutil, casi imperceptible
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XIColors.background,
      body: GestureDetector(
        onTap: _advanceDialogue,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Fondo del ambiente del personaje
            _buildEnvironmentBackground(),

            // Personaje
            _buildCharacterSprite(),

            // Efectos de ambiente
            _buildAmbientEffects(),

            // Diálogo actual
            _buildDialogue(),

            // Indicador de "toca para continuar"
            if (!_isTransitioning) _buildContinueIndicator(),

            // Overlay de transición de muerte
            if (_isTransitioning) _buildDeathTransitionOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentBackground() {
    final isOwen = widget.character.id == 'owen';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isOwen
              ? [
                  // Apartamento de Owen: cálido pero oscuro
                  const Color(0xFF1a1510),
                  const Color(0xFF0d0a08),
                  Color.lerp(
                    const Color(0xFF0d0a08),
                    XIColors.background,
                    _isTransitioning ? 0.8 : 0,
                  )!,
                ]
              : [
                  // Hospital de Nora: frío y fluorescente
                  const Color(0xFF151820),
                  const Color(0xFF0a0c10),
                  Color.lerp(
                    const Color(0xFF0a0c10),
                    XIColors.background,
                    _isTransitioning ? 0.8 : 0,
                  )!,
                ],
        ),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _EnvironmentPainter(
          characterId: widget.character.id,
          transitionProgress: _isTransitioning ? 1.0 : 0.0,
        ),
      ),
    );
  }

  Widget _buildCharacterSprite() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: _isTransitioning ? 0.3 : 1.0,
          child: CustomPaint(
            size: const Size(150, 200),
            painter: _CharacterSpritePainter(
              characterId: widget.character.id,
              isTransitioning: _isTransitioning,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientEffects() {
    final isOwen = widget.character.id == 'owen';

    if (isOwen) {
      // Lluvia para Owen
      return Positioned.fill(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isTransitioning ? 0.0 : 1.0,
          child: CustomPaint(
            painter: _RainPainter(),
          ),
        ),
      );
    } else {
      // Parpadeo de luz fluorescente para Nora
      return Positioned.fill(
        child: _FluorescentFlicker(isTransitioning: _isTransitioning),
      );
    }
  }

  Widget _buildDialogue() {
    if (_currentLineIndex >= _dialogueLines.length) return const SizedBox.shrink();

    final line = _dialogueLines[_currentLineIndex];
    final isOwen = widget.character.id == 'owen';

    return Positioned(
      left: 40,
      right: 40,
      bottom: line.type == DialogueType.stage ? 250 : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nombre del personaje (solo para diálogos)
          if (line.type == DialogueType.dialogue)
            Text(
              widget.character.name.toUpperCase(),
              style: TextStyle(
                color: isOwen ? XIColors.owenName : XIColors.noraName,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(duration: 200.ms),

          const SizedBox(height: 8),

          // Texto del diálogo
          Text(
            line.text,
            style: TextStyle(
              color: line.type == DialogueType.stage
                  ? XIColors.textMuted.withValues(alpha: 0.6)
                  : XIColors.textPrimary,
              fontSize: line.type == DialogueType.stage ? 13 : 16,
              fontStyle:
                  line.type == DialogueType.stage ? FontStyle.italic : FontStyle.normal,
              height: 1.6,
            ),
          )
              .animate(key: ValueKey(_currentLineIndex))
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildContinueIndicator() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '▼',
          style: TextStyle(
            color: XIColors.textMuted.withValues(alpha: 0.5),
            fontSize: 16,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: 500.ms)
            .then()
            .fadeOut(duration: 500.ms),
      ),
    );
  }

  Widget _buildDeathTransitionOverlay() {
    final isOwen = widget.character.id == 'owen';

    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        color: Colors.transparent,
        child: Stack(
          children: [
            // Oscurecimiento gradual
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: 0.7,
              child: Container(color: XIColors.background),
            ),

            // Elementos del limbo empezando a aparecer
            if (isOwen)
              // Las partituras se convierten en cartas
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      return Container(
                        width: 30,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: XIColors.cardBlue,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: XIColors.primary, width: 1),
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 500 + i * 200))
                          .fadeIn(duration: 800.ms)
                          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1));
                    }),
                  ),
                ),
              ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}

/// Painter para el fondo del ambiente
class _EnvironmentPainter extends CustomPainter {
  final String characterId;
  final double transitionProgress;

  _EnvironmentPainter({
    required this.characterId,
    required this.transitionProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (characterId == 'owen') {
      _paintOwenApartment(canvas, size);
    } else {
      _paintNoraHospital(canvas, size);
    }
  }

  void _paintOwenApartment(Canvas canvas, Size size) {
    final paint = Paint();

    // Ventana con lluvia
    paint.color = const Color(0xFF2a2520).withValues(alpha: 1 - transitionProgress);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.1, size.width * 0.3, size.height * 0.3),
      paint,
    );

    // Marco de ventana
    paint.color = XIColors.textMuted.withValues(alpha: 0.3 * (1 - transitionProgress));
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.1, size.width * 0.3, size.height * 0.3),
      paint,
    );

    // Escritorio
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF3a3025).withValues(alpha: 1 - transitionProgress);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.6, size.width * 0.6, size.height * 0.05),
      paint,
    );

    // Lámpara
    paint.color = XIColors.primary.withValues(alpha: 0.6 * (1 - transitionProgress));
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.5),
      20,
      paint,
    );
  }

  void _paintNoraHospital(Canvas canvas, Size size) {
    final paint = Paint();

    // Pasillo largo
    paint.color = const Color(0xFF1a1d25).withValues(alpha: 1 - transitionProgress);

    // Líneas de perspectiva del pasillo
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = XIColors.textMuted.withValues(alpha: 0.2 * (1 - transitionProgress));

    // Puertas a los lados
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.3 + i * 0.15);
      // Puerta izquierda
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.05, y, size.width * 0.1, size.height * 0.12),
        paint,
      );
      // Puerta derecha
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.85, y, size.width * 0.1, size.height * 0.12),
        paint,
      );
    }

    // Luces fluorescentes en el techo
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFd0d8e0).withValues(alpha: 0.3 * (1 - transitionProgress));
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * (0.05 + i * 0.08),
          size.width * 0.4,
          3,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnvironmentPainter oldDelegate) {
    return oldDelegate.transitionProgress != transitionProgress;
  }
}

/// Painter para el sprite del personaje
class _CharacterSpritePainter extends CustomPainter {
  final String characterId;
  final bool isTransitioning;

  _CharacterSpritePainter({
    required this.characterId,
    required this.isTransitioning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: isTransitioning ? 0.4 : 0.8)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;

    if (characterId == 'owen') {
      // Owen sentado, cabeza inclinada sobre escritorio
      // Cabeza
      canvas.drawCircle(Offset(centerX, 50), 25, paint);
      // Cuerpo sentado
      canvas.drawRect(
        Rect.fromLTWH(centerX - 30, 75, 60, 60),
        paint,
      );
      // Brazos sobre escritorio
      canvas.drawRect(
        Rect.fromLTWH(centerX - 45, 100, 90, 15),
        paint,
      );
      // Piernas
      canvas.drawRect(Rect.fromLTWH(centerX - 25, 135, 20, 40), paint);
      canvas.drawRect(Rect.fromLTWH(centerX + 5, 135, 20, 40), paint);
    } else {
      // Nora de pie con clipboard, caminando
      // Cabeza
      canvas.drawCircle(Offset(centerX, 35), 20, paint);
      // Cuerpo
      canvas.drawRect(
        Rect.fromLTWH(centerX - 25, 55, 50, 70),
        paint,
      );
      // Brazo con clipboard
      paint.color = XIColors.primary.withValues(alpha: 0.5);
      canvas.drawRect(
        Rect.fromLTWH(centerX + 20, 70, 15, 25),
        paint,
      );
      // Piernas (una adelante, una atrás para pose de caminar)
      paint.color = XIColors.textMuted.withValues(alpha: isTransitioning ? 0.4 : 0.8);
      canvas.drawRect(Rect.fromLTWH(centerX - 20, 125, 18, 50), paint);
      canvas.drawRect(Rect.fromLTWH(centerX + 2, 125, 18, 50), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CharacterSpritePainter oldDelegate) {
    return oldDelegate.isTransitioning != isTransitioning;
  }
}

/// Painter para efecto de lluvia
class _RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // Gotas de lluvia en la ventana
    for (int i = 0; i < 30; i++) {
      final x = (size.width * 0.6) + ((i * 17) % (size.width * 0.3));
      final y = (size.height * 0.1) + ((i * 23) % (size.height * 0.3));
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y + 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget para parpadeo de luz fluorescente
class _FluorescentFlicker extends StatefulWidget {
  final bool isTransitioning;

  const _FluorescentFlicker({required this.isTransitioning});

  @override
  State<_FluorescentFlicker> createState() => _FluorescentFlickerState();
}

class _FluorescentFlickerState extends State<_FluorescentFlicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _startRandomFlicker();
  }

  void _startRandomFlicker() async {
    while (mounted && !widget.isTransitioning) {
      // Esperar tiempo aleatorio
      await Future.delayed(Duration(milliseconds: 500 + (DateTime.now().millisecond % 2000)));
      if (!mounted) return;

      // Parpadeo rápido
      setState(() => _opacity = 0.3);
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() => _opacity = 0.0);
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _opacity = 0.2);
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() => _opacity = 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 50),
      opacity: widget.isTransitioning ? 0.0 : _opacity,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
