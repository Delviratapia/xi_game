import 'package:flutter/material.dart';
import '../models/card.dart';
import '../config/theme.dart';

/// Widget que representa una carta del juego
class CardWidget extends StatelessWidget {
  final XICard? card;
  final bool showBack;
  final double scale;
  final VoidCallback? onTap;

  const CardWidget({
    super.key,
    this.card,
    this.showBack = false,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = CardStyles.cardWidth * scale;
    final height = CardStyles.cardHeight * scale;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: XIAnimations.normal,
        width: width,
        height: height,
        decoration: showBack || card == null
            ? CardStyles.cardBack
            : card!.value == 11
                ? CardStyles.specialCard
                : CardStyles.cardFront,
        child: showBack || card == null
            ? _buildCardBack()
            : _buildCardFront(card!),
      ),
    );
  }

  Widget _buildCardBack() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'XI',
            style: TextStyle(
              color: XITheme.primary,
              fontSize: 24 * scale,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4 * scale),
          Container(
            width: 30 * scale,
            height: 2 * scale,
            color: XITheme.primary.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(XICard card) {
    final isSpecial = card.value == 11 || card.value == 1;
    final textColor = isSpecial ? XITheme.secondary : XITheme.textPrimary;

    return Padding(
      padding: EdgeInsets.all(8 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Valor arriba izquierda
          Text(
            card.name,
            style: TextStyle(
              color: textColor,
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Valor grande en el centro
          Center(
            child: Text(
              card.name,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.3),
                fontSize: 40 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          // Valor abajo derecha (invertido)
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: 3.14159, // 180 grados
              child: Text(
                card.name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que muestra una mano de cartas
class HandWidget extends StatelessWidget {
  final List<XICard> cards;
  final bool hideFirst;
  final double scale;

  const HandWidget({
    super.key,
    required this.cards,
    this.hideFirst = false,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(cards.length, (index) {
        final card = cards[index];
        final showBack = hideFirst && index == 0 && !card.isFaceUp;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4 * scale),
          child: CardWidget(
            card: card,
            showBack: showBack,
            scale: scale,
          ),
        );
      }),
    );
  }
}

/// Animación de carta siendo repartida
class DealingCardWidget extends StatefulWidget {
  final XICard card;
  final Offset startPosition;
  final Offset endPosition;
  final bool showFront;
  final VoidCallback? onComplete;

  const DealingCardWidget({
    super.key,
    required this.card,
    required this.startPosition,
    required this.endPosition,
    this.showFront = true,
    this.onComplete,
  });

  @override
  State<DealingCardWidget> createState() => _DealingCardWidgetState();
}

class _DealingCardWidgetState extends State<DealingCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: XIAnimations.slow,
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: XIAnimations.defaultCurve,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: XIAnimations.defaultCurve,
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: CardWidget(
              card: widget.card,
              showBack: !widget.showFront,
            ),
          ),
        );
      },
    );
  }
}
