import 'package:flutter/material.dart';
import '../models/gatekeeper.dart';
import '../config/theme.dart';

/// Widget que muestra a The Gatekeeper con sus animaciones y frases
class GatekeeperWidget extends StatefulWidget {
  final Gatekeeper gatekeeper;
  final bool showQuote;
  final double size;

  const GatekeeperWidget({
    super.key,
    required this.gatekeeper,
    this.showQuote = true,
    this.size = 200,
  });

  @override
  State<GatekeeperWidget> createState() => _GatekeeperWidgetState();
}

class _GatekeeperWidgetState extends State<GatekeeperWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color get _moodColor {
    switch (widget.gatekeeper.mood) {
      case GatekeeperMood.bored:
        return XITheme.gatekeeperBored;
      case GatekeeperMood.attentive:
        return XITheme.gatekeeperAttentive;
      case GatekeeperMood.intense:
        return XITheme.gatekeeperIntense;
      case GatekeeperMood.knowing:
        return XITheme.gatekeeperKnowing;
      case GatekeeperMood.graceful:
        return XITheme.primary;
      case GatekeeperMood.silent:
        return XITheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The Gatekeeper visual (pixel art placeholder)
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Transform.scale(
              scale: _breathAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _moodColor.withValues(alpha: _glowAnimation.value),
                      Colors.transparent,
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
                child: Center(
                  child: _buildGatekeeperVisual(),
                ),
              ),
            );
          },
        ),
        // Frase de The Gatekeeper
        if (widget.showQuote && widget.gatekeeper.currentQuote.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _QuoteWidget(quote: widget.gatekeeper.currentQuote),
          ),
      ],
    );
  }

  Widget _buildGatekeeperVisual() {
    // Pixel art simplificado de The Gatekeeper
    // En producción, esto sería un sprite animado
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Capucha
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: XITheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            border: Border.all(color: _moodColor, width: 2),
          ),
        ),
        // Rostro oscuro (solo se ven los ojos)
        Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            color: XITheme.background,
            border: Border.all(color: _moodColor.withValues(alpha: 0.5), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEye(),
              _buildEye(),
            ],
          ),
        ),
        // Túnica
        Container(
          width: 70,
          height: 50,
          decoration: BoxDecoration(
            color: XITheme.surface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            border: Border.all(color: _moodColor.withValues(alpha: 0.3), width: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildEye() {
    // Animar ojos según el mood
    double eyeSize = 8;
    Color eyeColor = XITheme.primary;

    switch (widget.gatekeeper.mood) {
      case GatekeeperMood.bored:
        eyeSize = 4; // Ojos entrecerrados
        eyeColor = XITheme.textMuted;
        break;
      case GatekeeperMood.intense:
        eyeSize = 10; // Ojos bien abiertos
        eyeColor = XITheme.secondary;
        break;
      case GatekeeperMood.knowing:
        eyeColor = XITheme.primaryLight;
        break;
      default:
        break;
    }

    return AnimatedContainer(
      duration: XIAnimations.normal,
      width: eyeSize,
      height: eyeSize,
      decoration: BoxDecoration(
        color: eyeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: eyeColor.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar las frases de The Gatekeeper
class _QuoteWidget extends StatefulWidget {
  final String quote;

  const _QuoteWidget({required this.quote});

  @override
  State<_QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<_QuoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: XIAnimations.slow,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_QuoteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quote != widget.quote) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: XITheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: XITheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          widget.quote,
          style: const TextStyle(
            color: XITheme.textSecondary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Widget para el diálogo narrativo de The Gatekeeper
class GatekeeperDialogWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onComplete;
  final bool autoAdvance;

  const GatekeeperDialogWidget({
    super.key,
    required this.text,
    this.onComplete,
    this.autoAdvance = false,
  });

  @override
  State<GatekeeperDialogWidget> createState() => _GatekeeperDialogWidgetState();
}

class _GatekeeperDialogWidgetState extends State<GatekeeperDialogWidget> {
  String _displayedText = '';
  int _currentIndex = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    for (int i = 0; i < widget.text.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _currentIndex = i + 1;
        _displayedText = widget.text.substring(0, _currentIndex);
      });
    }
    setState(() => _isComplete = true);
    if (widget.autoAdvance) {
      await Future.delayed(const Duration(seconds: 2));
      widget.onComplete?.call();
    }
  }

  void _skipToEnd() {
    setState(() {
      _displayedText = widget.text;
      _currentIndex = widget.text.length;
      _isComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isComplete) {
          widget.onComplete?.call();
        } else {
          _skipToEnd();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: XITheme.background.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: XITheme.primary.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The Gatekeeper',
              style: TextStyle(
                color: XITheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _displayedText,
              style: const TextStyle(
                color: XITheme.textPrimary,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            if (_isComplete)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '[ Toca para continuar ]',
                  style: TextStyle(
                    color: XITheme.textMuted.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
