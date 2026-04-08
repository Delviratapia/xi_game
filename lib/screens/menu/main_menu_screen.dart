import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../data/characters.dart';
import '../../models/game_state.dart';
import '../game/game_screen.dart';
import '../story/character_select_screen.dart';
import '../settings/settings_screen.dart';

/// Pantalla del menú principal
/// Diseño: Carta roja central (XI) con opciones, cartas azules formando arco (personajes)
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  int _selectedIndex = -1;

  final List<_MenuOption> _menuOptions = [
    _MenuOption(
      title: AppStrings.storyMode,
      subtitle: 'Narrativa lineal, 7 rondas',
      icon: Icons.auto_stories,
      mode: GameMode.story,
    ),
    _MenuOption(
      title: AppStrings.freePlay,
      subtitle: 'Partidas infinitas con apuestas',
      icon: Icons.casino,
      mode: GameMode.freePlay,
    ),
    _MenuOption(
      title: AppStrings.gambleFree,
      subtitle: 'Sin riesgos, para pasar el tiempo',
      icon: Icons.sports_esports,
      mode: GameMode.gambleFree,
    ),
    _MenuOption(
      title: AppStrings.settings,
      subtitle: 'Configuración',
      icon: Icons.settings,
      mode: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMenuItemTap(_MenuOption option) {
    if (option.mode == null) {
      // Settings
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    } else if (option.mode == GameMode.story) {
      // Story Mode - ir a selección de personaje
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CharacterSelectScreen()),
      );
    } else {
      // Free Play o Gamble Free - ir directo al juego
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            gameState: GameState.newGame(mode: option.mode!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XITheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Título XI
            _buildTitle(),
            const SizedBox(height: 20),
            // Subtítulo
            Text(
              '"Todos llegan aquí tarde o temprano."',
              style: TextStyle(
                color: XITheme.textMuted,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Cartas de personajes (arco superior)
            _buildCharacterArc(),
            const Spacer(),
            // Opciones del menú
            _buildMenuOptions(),
            const SizedBox(height: 40),
            // Créditos
            TextButton(
              onPressed: () => _showCredits(context),
              child: const Text(
                'CREDITS',
                style: TextStyle(
                  color: XITheme.textMuted,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                XITheme.primary,
                XITheme.primaryLight,
                XITheme.primary,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: const Text(
              'XI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                letterSpacing: 15,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterArc() {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Personajes desbloqueados y bloqueados
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Owen (As)
              _buildCharacterCard(
                character: owen,
                isUnlocked: true,
                rotation: -0.15,
              ),
              // Nora (2)
              _buildCharacterCard(
                character: nora,
                isUnlocked: true,
                rotation: -0.08,
              ),
              // Cartas bloqueadas (3-10)
              for (int i = 3; i <= 6; i++)
                _buildLockedCard(
                  number: i,
                  rotation: (i - 4.5) * 0.08,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard({
    required StoryCharacter character,
    required bool isUnlocked,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: GestureDetector(
        onTap: isUnlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      gameState: GameState.newGame(
                        mode: GameMode.story,
                        characterId: character.id,
                      ),
                    ),
                  ),
                );
              }
            : null,
        child: Container(
          width: 50,
          height: 75,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: XITheme.cardBlue,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isUnlocked ? XITheme.primary : XITheme.textMuted,
              width: 1,
            ),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: XITheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                character.cardValue == 1 ? 'A' : '${character.cardValue}',
                style: TextStyle(
                  color: XITheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                character.name.split(' ')[0],
                style: TextStyle(
                  color: XITheme.textSecondary,
                  fontSize: 8,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedCard({required int number, required double rotation}) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 50,
        height: 75,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: XITheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: XITheme.textMuted.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$number',
              style: TextStyle(
                color: XITheme.textMuted.withValues(alpha: 0.5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.lock,
              color: XITheme.textMuted.withValues(alpha: 0.5),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _menuOptions.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTapDown: (_) => setState(() => _selectedIndex = index),
          onTapUp: (_) {
            setState(() => _selectedIndex = -1);
            _onMenuItemTap(option);
          },
          onTapCancel: () => setState(() => _selectedIndex = -1),
          child: AnimatedContainer(
            duration: XIAnimations.fast,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? XITheme.primary.withValues(alpha: 0.2)
                  : XITheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? XITheme.primary
                    : XITheme.textMuted.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  option.icon,
                  color: isSelected ? XITheme.primary : XITheme.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          color: isSelected
                              ? XITheme.primary
                              : XITheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          color: XITheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isSelected ? XITheme.primary : XITheme.textMuted,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: XITheme.surface,
        title: const Text(
          'XI',
          style: TextStyle(color: XITheme.primary),
          textAlign: TextAlign.center,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Un juego de cartas de horror y suspenso psicológico',
              style: TextStyle(color: XITheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Desarrollado con Flutter',
              style: TextStyle(color: XITheme.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }
}

class _MenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final GameMode? mode;

  _MenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.mode,
  });
}
