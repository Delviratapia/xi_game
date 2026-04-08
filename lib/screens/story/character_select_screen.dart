import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import '../game/game_screen.dart';

/// Pantalla de selección de personaje para el Modo Historia
class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  StoryCharacter? _selectedCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XITheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: XITheme.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MODO HISTORIA',
          style: TextStyle(
            color: XITheme.primary,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Elige un alma cuya historia descubrir',
                style: TextStyle(
                  color: XITheme.textMuted,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Lista de personajes
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Personajes desbloqueados
                  ...allCharacters.map((character) => _buildCharacterCard(character)),

                  // Separador
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: XITheme.textMuted)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'PRÓXIMAMENTE',
                            style: TextStyle(
                              color: XITheme.textMuted,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: XITheme.textMuted)),
                      ],
                    ),
                  ),

                  // Personajes bloqueados
                  for (int i = 3; i <= 10; i++)
                    _buildLockedCharacterCard(i),
                ],
              ),
            ),

            // Botón de jugar
            if (_selectedCharacter != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: _startGame,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: XITheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'JUGAR COMO ${_selectedCharacter!.name.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: XITheme.background,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(StoryCharacter character) {
    final isSelected = _selectedCharacter?.id == character.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedCharacter = character),
      child: AnimatedContainer(
        duration: XIAnimations.fast,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? XITheme.primary.withValues(alpha: 0.15)
              : XITheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? XITheme.primary : XITheme.textMuted.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Carta del personaje
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: XITheme.cardBlue,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? XITheme.primary : XITheme.textMuted,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    character.cardValue == 1 ? 'A' : '${character.cardValue}',
                    style: TextStyle(
                      color: isSelected ? XITheme.primary : XITheme.textSecondary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Info del personaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: TextStyle(
                      color: isSelected ? XITheme.primary : XITheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${character.occupation} • ${character.age} años',
                    style: const TextStyle(
                      color: XITheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    character.deathDescription,
                    style: TextStyle(
                      color: XITheme.textMuted,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Indicador de selección
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: XITheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedCharacterCard(int cardNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XITheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: XITheme.textMuted.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Carta bloqueada
          Container(
            width: 60,
            height: 90,
            decoration: BoxDecoration(
              color: XITheme.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: XITheme.textMuted.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$cardNumber',
                  style: TextStyle(
                    color: XITheme.textMuted.withValues(alpha: 0.5),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.lock,
                  color: XITheme.textMuted.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Info bloqueada
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '???',
                  style: TextStyle(
                    color: XITheme.textMuted.withValues(alpha: 0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Disponible en una actualización futura',
                  style: TextStyle(
                    color: XITheme.textMuted.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    if (_selectedCharacter == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          gameState: GameState.newGame(
            mode: GameMode.story,
            characterId: _selectedCharacter!.id,
          ),
        ),
      ),
    );
  }
}
