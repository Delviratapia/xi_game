import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Pantalla para apostar fragmentos antes de cada ronda
class BettingScreen extends StatefulWidget {
  final int maxBet;
  final int currentFragments;
  final int fragmentsAtRisk;
  final bool isGambleFree;

  const BettingScreen({
    super.key,
    required this.maxBet,
    required this.currentFragments,
    required this.fragmentsAtRisk,
    required this.isGambleFree,
  });

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  int _selectedBet = 0;
  final List<int> _quickBets = [5, 10, 25, 50, 100];

  @override
  void initState() {
    super.initState();
    _selectedBet = widget.maxBet > 0 ? 10.clamp(0, widget.maxBet) : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XITheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Título
              const Text(
                'APUESTA',
                style: TextStyle(
                  color: XITheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isGambleFree
                    ? 'Sin riesgo, sin recompensa'
                    : '¿Cuánto estás dispuesto a arriesgar?',
                style: const TextStyle(
                  color: XITheme.textMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // Fragmentos actuales
              _buildFragmentsDisplay(),
              const SizedBox(height: 40),

              // Selector de apuesta
              if (!widget.isGambleFree && widget.maxBet > 0) ...[
                _buildBetSelector(),
                const SizedBox(height: 24),
                _buildQuickBets(),
              ] else if (widget.maxBet == 0) ...[
                _buildNoFragmentsMessage(),
              ],

              const Spacer(),

              // Botón de confirmar
              _buildConfirmButton(),
              const SizedBox(height: 16),

              // Botón de jugar sin apuesta
              if (!widget.isGambleFree && widget.maxBet > 0)
                TextButton(
                  onPressed: () => Navigator.pop(context, 0),
                  child: const Text(
                    'JUGAR SIN APOSTAR',
                    style: TextStyle(
                      color: XITheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFragmentsDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: XITheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: XITheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.diamond_outlined,
                color: XITheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '${widget.currentFragments}',
                style: const TextStyle(
                  color: XITheme.textPrimary,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Text(
            'FRAGMENTOS DISPONIBLES',
            style: TextStyle(
              color: XITheme.textMuted,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          if (widget.fragmentsAtRisk > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: XITheme.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning, color: XITheme.error, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.fragmentsAtRisk} EN RIESGO',
                    style: const TextStyle(
                      color: XITheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBetSelector() {
    return Column(
      children: [
        Text(
          '$_selectedBet',
          style: const TextStyle(
            color: XITheme.primary,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: XITheme.primary,
            inactiveTrackColor: XITheme.surface,
            thumbColor: XITheme.primaryLight,
            overlayColor: XITheme.primary.withValues(alpha: 0.2),
            trackHeight: 8,
          ),
          child: Slider(
            value: _selectedBet.toDouble(),
            min: 0,
            max: widget.maxBet.toDouble(),
            divisions: widget.maxBet > 0 ? widget.maxBet : 1,
            onChanged: (value) {
              setState(() {
                _selectedBet = value.round();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickBets() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _quickBets.where((bet) => bet <= widget.maxBet).map((bet) {
        final isSelected = _selectedBet == bet;
        return GestureDetector(
          onTap: () => setState(() => _selectedBet = bet),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? XITheme.primary : XITheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? XITheme.primaryLight : XITheme.textMuted,
                width: 1,
              ),
            ),
            child: Text(
              '$bet',
              style: TextStyle(
                color: isSelected ? XITheme.background : XITheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoFragmentsMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: XITheme.cardRed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: XITheme.secondary, width: 1),
      ),
      child: const Column(
        children: [
          Icon(Icons.warning_amber, color: XITheme.secondary, size: 48),
          SizedBox(height: 16),
          Text(
            'SIN FRAGMENTOS',
            style: TextStyle(
              color: XITheme.secondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '"Juega. Si ganas, te doy Fragmentos.\nSi pierdes... me quedo con algo tuyo."',
            style: TextStyle(
              color: XITheme.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '— The Gatekeeper',
            style: TextStyle(
              color: XITheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final hasValidBet = widget.isGambleFree || _selectedBet > 0 || widget.maxBet == 0;

    return GestureDetector(
      onTap: hasValidBet
          ? () => Navigator.pop(context, _selectedBet)
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: hasValidBet ? XITheme.primary : XITheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasValidBet ? XITheme.primaryLight : XITheme.textMuted,
            width: 2,
          ),
        ),
        child: Text(
          widget.isGambleFree
              ? 'JUGAR'
              : _selectedBet > 0
                  ? 'APOSTAR $_selectedBet'
                  : widget.maxBet == 0
                      ? 'ACEPTAR TRATO'
                      : 'SELECCIONA UNA APUESTA',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: hasValidBet ? XITheme.background : XITheme.textMuted,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
