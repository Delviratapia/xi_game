/// Trump Cards - Cartas especiales con efectos que alteran el juego
/// Aparecen a partir de la segunda ronda
enum TrumpCardType {
  forceHit,      // Forzar al rival a robar una carta adicional
  returnCard,    // Devolver una carta al mazo
  peekHidden,    // Ver la carta oculta del rival
  swapHidden,    // Intercambiar tu carta escondida por la del rival
}

class TrumpCard {
  final TrumpCardType type;
  final String name;
  final String description;
  final String gatekeeperQuote;
  bool isUsed;

  TrumpCard({
    required this.type,
    required this.name,
    required this.description,
    required this.gatekeeperQuote,
    this.isUsed = false,
  });

  /// Crea todas las Trump Cards disponibles
  static List<TrumpCard> createAll() {
    return [
      TrumpCard(
        type: TrumpCardType.forceHit,
        name: 'Mano Forzada',
        description: 'Obliga a tu rival a robar una carta adicional',
        gatekeeperQuote: '"El destino no siempre es una elección."',
      ),
      TrumpCard(
        type: TrumpCardType.returnCard,
        name: 'Segunda Oportunidad',
        description: 'Devuelve una de tus cartas al mazo',
        gatekeeperQuote: '"Algunos errores pueden deshacerse... algunos."',
      ),
      TrumpCard(
        type: TrumpCardType.peekHidden,
        name: 'Visión del Más Allá',
        description: 'Revela la carta oculta de tu rival',
        gatekeeperQuote: '"Los secretos no duran aquí."',
      ),
      TrumpCard(
        type: TrumpCardType.swapHidden,
        name: 'Intercambio de Almas',
        description: 'Intercambia tu carta oculta con la de tu rival',
        gatekeeperQuote: '"Lo que es tuyo... puede ser mío."',
      ),
    ];
  }

  void use() {
    isUsed = true;
  }

  void reset() {
    isUsed = false;
  }

  @override
  String toString() => 'TrumpCard($name)';
}
