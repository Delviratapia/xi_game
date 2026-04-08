/// The Gatekeeper - El personaje principal antagonista
/// No es malvada ni buena. Es indiferente.
enum GatekeeperMood {
  bored,      // Gamble Free - aburrida, bosteza, indiferente
  attentive,  // Apuesta normal - atenta, seria, observa
  intense,    // Apuesta alta - viva, casi emocionada
  knowing,    // Jugador con Fragmentos en riesgo - sabe que hay algo que perder
  graceful,   // Victoria del jugador - acepta con elegancia glacial
  silent,     // Derrota del jugador - recoge en silencio, sin burla
}

class Gatekeeper {
  GatekeeperMood mood;
  String currentQuote;

  // Personalización desbloqueada
  String tunic;
  String? accessory;
  String scytheDesign;

  Gatekeeper({
    this.mood = GatekeeperMood.attentive,
    this.currentQuote = '',
    this.tunic = 'default',
    this.accessory,
    this.scytheDesign = 'default',
  });

  /// Frases generales de The Gatekeeper
  static const List<String> generalQuotes = [
    '"Todos llegan aquí tarde o temprano. Pero algunos tienen la opción de volver."',
    '"Juega. Gana suficiente... y quizás recuerdes cómo se siente respirar."',
    '"Los recuerdos que casi recuperaste... ahora son míos."',
    '"Vuelve cuando seas digno... o cuando dejes de temblar."',
  ];

  /// Frases cuando el jugador juega sin apuesta (Gamble Free)
  static const List<String> boredQuotes = [
    '"Sin apuesta? ...Como quieras. Jugaré contigo. Pero no esperes que me esfuerce."',
    '"Ganaste... supongo. ¿Se supone que debo aplaudirte?"',
    '"Qué aburrido..."',
  ];

  /// Frases cuando hay apuesta alta
  static const List<String> intenseQuotes = [
    '"Ahora sí se pone interesante..."',
    '"Puedo sentir tu miedo. Me gusta."',
    '"Apuestas mucho para alguien que ya lo perdió todo una vez."',
  ];

  /// Frases cuando el jugador tiene fragmentos en riesgo
  static const List<String> knowingQuotes = [
    '"Veo que traes algo valioso. Qué generoso de tu parte."',
    '"Esos fragmentos... pronto serán míos."',
    '"El peso de lo que puedes perder... ¿lo sientes?"',
  ];

  /// Actualiza el humor según la situación del juego
  void updateMood({
    required bool isGambleFree,
    required int betAmount,
    required int fragmentsAtRisk,
    required bool playerWon,
  }) {
    if (isGambleFree) {
      mood = GatekeeperMood.bored;
      currentQuote = boredQuotes[DateTime.now().millisecond % boredQuotes.length];
    } else if (fragmentsAtRisk > 0) {
      mood = GatekeeperMood.knowing;
      currentQuote = knowingQuotes[DateTime.now().millisecond % knowingQuotes.length];
    } else if (betAmount > 50) {
      mood = GatekeeperMood.intense;
      currentQuote = intenseQuotes[DateTime.now().millisecond % intenseQuotes.length];
    } else {
      mood = GatekeeperMood.attentive;
      currentQuote = generalQuotes[DateTime.now().millisecond % generalQuotes.length];
    }
  }

  /// Actualiza después de que termina una ronda
  void updateAfterRound(bool playerWon) {
    if (playerWon) {
      mood = GatekeeperMood.graceful;
    } else {
      mood = GatekeeperMood.silent;
    }
  }

  /// Obtiene la animación actual según el humor
  String get currentAnimation {
    switch (mood) {
      case GatekeeperMood.bored:
        return 'bored'; // tamborilea dedos, bosteza
      case GatekeeperMood.attentive:
        return 'attentive'; // observa cada movimiento
      case GatekeeperMood.intense:
        return 'intense'; // viva, emocionada
      case GatekeeperMood.knowing:
        return 'knowing'; // sabe que hay algo que perder
      case GatekeeperMood.graceful:
        return 'graceful'; // acepta con elegancia
      case GatekeeperMood.silent:
        return 'silent'; // recoge en silencio
    }
  }

  /// Túnicas desbloqueables
  static const List<String> availableTunics = [
    'default',
    'golden',      // dorada
    'blood_red',   // roja sangre
    'spectral',    // blanca espectral
  ];

  /// Accesorios desbloqueables
  static const List<String> availableAccessories = [
    'crown',       // corona
    'flowers',     // flores
    'hourglass',   // reloj de arena
  ];

  /// Diseños de guadaña
  static const List<String> availableScythes = [
    'default',
    'ornate',
    'ancient',
    'ethereal',
  ];
}
