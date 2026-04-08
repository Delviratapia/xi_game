import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Pantalla de configuración
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Configuraciones
  String _language = 'Español';
  bool _colorBlindMode = false;
  bool _largeText = false;
  double _soundVolume = 0.8;
  double _musicVolume = 0.6;
  bool _vibration = true;

  final List<String> _languages = ['Español', 'English', 'Português'];

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
          'CONFIGURACIÓN',
          style: TextStyle(
            color: XITheme.primary,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Idioma
          _buildSectionTitle('IDIOMA'),
          _buildLanguageSelector(),
          const SizedBox(height: 32),

          // Accesibilidad
          _buildSectionTitle('ACCESIBILIDAD'),
          _buildSwitchTile(
            title: 'Modo daltónico',
            subtitle: 'Cambia la paleta de colores',
            value: _colorBlindMode,
            onChanged: (value) => setState(() => _colorBlindMode = value),
          ),
          _buildSwitchTile(
            title: 'Texto grande',
            subtitle: 'Aumenta el tamaño del texto',
            value: _largeText,
            onChanged: (value) => setState(() => _largeText = value),
          ),
          const SizedBox(height: 32),

          // Audio
          _buildSectionTitle('AUDIO'),
          _buildSliderTile(
            title: 'Sonido',
            value: _soundVolume,
            onChanged: (value) => setState(() => _soundVolume = value),
          ),
          _buildSliderTile(
            title: 'Música',
            value: _musicVolume,
            onChanged: (value) => setState(() => _musicVolume = value),
          ),
          const SizedBox(height: 32),

          // Otros
          _buildSectionTitle('OTROS'),
          _buildSwitchTile(
            title: 'Vibración',
            subtitle: 'Vibrar en eventos del juego',
            value: _vibration,
            onChanged: (value) => setState(() => _vibration = value),
          ),
          const SizedBox(height: 32),

          // Información
          _buildSectionTitle('INFORMACIÓN'),
          _buildInfoTile(
            title: 'Versión',
            value: '1.0.0 (Draft)',
          ),
          _buildInfoTile(
            title: 'Desarrollado con',
            value: 'Flutter',
          ),
          const SizedBox(height: 32),

          // Botón de reset
          Center(
            child: TextButton(
              onPressed: _showResetConfirmation,
              child: const Text(
                'REINICIAR PROGRESO',
                style: TextStyle(
                  color: XITheme.error,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: XITheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: XITheme.textMuted.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _language,
          isExpanded: true,
          dropdownColor: XITheme.surface,
          style: const TextStyle(
            color: XITheme.textPrimary,
            fontSize: 16,
          ),
          icon: const Icon(Icons.expand_more, color: XITheme.textMuted),
          items: _languages.map((lang) {
            return DropdownMenuItem(
              value: lang,
              child: Text(lang),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _language = value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: XITheme.textMuted.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: XITheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: XITheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: XITheme.primary,
            activeTrackColor: XITheme.primary.withValues(alpha: 0.5),
            inactiveThumbColor: XITheme.textMuted,
            inactiveTrackColor: XITheme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: XITheme.textMuted.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: XITheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  color: XITheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: XITheme.primary,
              inactiveTrackColor: XITheme.textMuted.withValues(alpha: 0.3),
              thumbColor: XITheme.primaryLight,
              overlayColor: XITheme.primary.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: XITheme.textMuted.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: XITheme.textPrimary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: XITheme.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: XITheme.surface,
        title: const Text(
          '¿Reiniciar progreso?',
          style: TextStyle(color: XITheme.textPrimary),
        ),
        content: const Text(
          'Esto borrará todos tus Fragmentos, Almas y personalizaciones. Esta acción no se puede deshacer.',
          style: TextStyle(color: XITheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar reset
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progreso reiniciado'),
                  backgroundColor: XITheme.error,
                ),
              );
            },
            child: const Text(
              'REINICIAR',
              style: TextStyle(color: XITheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
