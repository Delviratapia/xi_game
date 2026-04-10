import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import 'character_intro_screen.dart';

/// Pantalla de selección de personaje según GDD v1.3
/// Muestra: Imagen del personaje + nombre + descripción sin spoiler + estado + botón Jugar
class CharacterSelectScreen extends StatefulWidget {
  final StoryCharacter? preselectedCharacter;

  const CharacterSelectScreen({super.key, this.preselectedCharacter});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  StoryCharacter? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _selectedCharacter = widget.preselectedCharacter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XIColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),

            // Si hay personaje seleccionado, mostrar detalles
            if (_selectedCharacter != null)
              Expanded(child: _buildCharacterDetails(_selectedCharacter!))
            else
              Expanded(child: _buildCharacterList()),

            // Botón Jugar
            if (_selectedCharacter != null) _buildPlayButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: XIColors.textSecondary),
            onPressed: () {
              if (_selectedCharacter != null && widget.preselectedCharacter == null) {
                setState(() => _selectedCharacter = null);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const Expanded(
            child: Text(
              'MODO HISTORIA',
              style: TextStyle(
                color: XIColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance para el botón back
        ],
      ),
    );
  }

  Widget _buildCharacterList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const Text(
          'Elige un alma cuya historia descubrir',
          style: TextStyle(
            color: XIColors.textMuted,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Owen
        _buildCharacterListItem(owen),
        const SizedBox(height: 12),

        // Nora
        _buildCharacterListItem(nora),

        const SizedBox(height: 24),
        const Divider(color: XIColors.textMuted, height: 1),
        const SizedBox(height: 16),

        const Text(
          'PRÓXIMAMENTE',
          style: TextStyle(
            color: XIColors.textMuted,
            fontSize: 10,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Personajes bloqueados
        for (int i = 3; i <= 10; i++) _buildLockedCharacterItem(i),

        const SizedBox(height: 16),

        // Owen Returns (Carta 11)
        _buildOwenReturnsItem(),
      ],
    );
  }

  Widget _buildCharacterListItem(StoryCharacter character) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCharacter = character),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: XIColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: XIColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Carta con silueta
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: XIColors.cardBlue,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: XIColors.primary, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    character.cardValue == 1 ? 'A' : '${character.cardValue}',
                    style: const TextStyle(
                      color: XIColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: XIColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.selectDescription,
                    style: TextStyle(
                      color: XIColors.textMuted,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: XIColors.primary,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildLockedCharacterItem(int cardNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: XIColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: XIColors.textMuted.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 55,
            decoration: BoxDecoration(
              color: XIColors.background,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: XIColors.textMuted.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$cardNumber',
                  style: TextStyle(
                    color: XIColors.textMuted.withValues(alpha: 0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.lock,
                  color: XIColors.textMuted.withValues(alpha: 0.4),
                  size: 12,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '???',
            style: TextStyle(
              color: XIColors.textMuted.withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwenReturnsItem() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: XIColors.cardRed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: XIColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 55,
            decoration: BoxDecoration(
              color: XIColors.cardRed,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: XIColors.secondary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '11',
                  style: TextStyle(
                    color: XIColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.lock,
                  color: XIColors.secondary.withValues(alpha: 0.5),
                  size: 12,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OWEN RETURNS',
                  style: TextStyle(
                    color: XIColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Modo especial - Completa la historia de Owen primero',
                  style: TextStyle(
                    color: XIColors.textMuted.withValues(alpha: 0.6),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Detalles del personaje seleccionado
  Widget _buildCharacterDetails(StoryCharacter character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Imagen del personaje (placeholder pixel art)
          _buildCharacterImage(character),
          const SizedBox(height: 20),

          // Nombre
          Text(
            character.name,
            style: const TextStyle(
              color: XIColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // Ocupación y edad
          Text(
            '${character.occupation} · ${character.age} años',
            style: const TextStyle(
              color: XIColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Descripción sin spoiler
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: XIColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: XIColors.textMuted.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              character.selectDescription,
              style: const TextStyle(
                color: XIColors.textPrimary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Estado de completado
          _buildCompletionStatus(character),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCharacterImage(StoryCharacter character) {
    // Placeholder de imagen pixel art del personaje
    return Container(
      width: 200,
      height: 180,
      decoration: BoxDecoration(
        color: XIColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: XIColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Fondo del ambiente
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: character.id == 'owen'
                    ? [
                        const Color(0xFF1a1510), // Apartamento oscuro
                        const Color(0xFF0d0a08),
                      ]
                    : [
                        const Color(0xFF101520), // Hospital frío
                        const Color(0xFF080a10),
                      ],
              ),
            ),
          ),
          // Silueta del personaje
          Center(
            child: CustomPaint(
              size: const Size(100, 120),
              painter: _CharacterPortraitPainter(characterId: character.id),
            ),
          ),
          // Efecto de lluvia para Owen
          if (character.id == 'owen')
            Positioned.fill(
              child: CustomPaint(
                painter: _RainEffectPainter(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletionStatus(StoryCharacter character) {
    // TODO: Obtener de shared_preferences
    const isCompleted = false;
    const isInProgress = false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: XIColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: XIColors.textMuted.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle
                : isInProgress
                    ? Icons.play_circle
                    : Icons.circle_outlined,
            color: isCompleted
                ? XIColors.success
                : isInProgress
                    ? XIColors.warning
                    : XIColors.textMuted,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isCompleted
                ? 'COMPLETADO'
                : isInProgress
                    ? 'EN PROGRESO'
                    : 'SIN JUGAR',
            style: TextStyle(
              color: isCompleted
                  ? XIColors.success
                  : isInProgress
                      ? XIColors.warning
                      : XIColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: _startGame,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: XIColors.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: XIColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'JUGAR',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: XIColors.background,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideY(begin: 0.2, end: 0);
  }

  void _startGame() {
    if (_selectedCharacter == null) return;

    // Ir a la escena introductoria del personaje
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterIntroScreen(character: _selectedCharacter!),
      ),
    );
  }
}

/// Painter para el retrato del personaje
class _CharacterPortraitPainter extends CustomPainter {
  final String characterId;

  _CharacterPortraitPainter({required this.characterId});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;

    if (characterId == 'owen') {
      // Owen sentado en escritorio
      // Cabeza
      canvas.drawCircle(Offset(centerX, 30), 15, paint);
      // Cuerpo
      canvas.drawRect(
        Rect.fromLTWH(centerX - 20, 45, 40, 35),
        paint,
      );
      // Escritorio
      paint.color = XIColors.primary.withValues(alpha: 0.4);
      canvas.drawRect(
        Rect.fromLTWH(10, 80, size.width - 20, 8),
        paint,
      );
      // Partituras
      paint.color = XIColors.textMuted.withValues(alpha: 0.3);
      canvas.drawRect(Rect.fromLTWH(20, 75, 15, 20), paint);
      canvas.drawRect(Rect.fromLTWH(45, 73, 12, 18), paint);
      canvas.drawRect(Rect.fromLTWH(65, 76, 14, 16), paint);
    } else if (characterId == 'nora') {
      // Nora de pie con clipboard
      // Cabeza
      canvas.drawCircle(Offset(centerX, 25), 12, paint);
      // Cuerpo de pie
      canvas.drawRect(
        Rect.fromLTWH(centerX - 15, 37, 30, 50),
        paint,
      );
      // Clipboard
      paint.color = XIColors.primary.withValues(alpha: 0.5);
      canvas.drawRect(
        Rect.fromLTWH(centerX + 12, 50, 10, 15),
        paint,
      );
      // Piernas
      paint.color = XIColors.textMuted.withValues(alpha: 0.6);
      canvas.drawRect(Rect.fromLTWH(centerX - 12, 87, 10, 25), paint);
      canvas.drawRect(Rect.fromLTWH(centerX + 2, 87, 10, 25), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter para efecto de lluvia
class _RainEffectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = XIColors.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // Gotas de lluvia estáticas (en producción serían animadas)
    for (int i = 0; i < 15; i++) {
      final x = (i * 17) % size.width;
      final y = (i * 23) % size.height;
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 2, y + 8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
