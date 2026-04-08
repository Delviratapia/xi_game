/// Personajes del Modo Historia
/// Cada personaje tiene una historia independiente de 7 rondas

class StoryCharacter {
  final String id;
  final String name;
  final int age;
  final String origin;
  final String occupation;
  final String deathDescription;
  final int cardValue; // Qué carta representa (As = 1, etc.)
  final List<StoryFragment> fragments;
  final String plotTwist;
  final List<StoryEnding> endings;
  final List<String> gatekeeperQuotes;
  final bool isUnlocked;

  const StoryCharacter({
    required this.id,
    required this.name,
    required this.age,
    required this.origin,
    required this.occupation,
    required this.deathDescription,
    required this.cardValue,
    required this.fragments,
    required this.plotTwist,
    required this.endings,
    required this.gatekeeperQuotes,
    this.isUnlocked = false,
  });
}

class StoryFragment {
  final int round;
  final String title;
  final String content;
  final bool isPlotTwist;

  const StoryFragment({
    required this.round,
    required this.title,
    required this.content,
    this.isPlotTwist = false,
  });
}

class StoryEnding {
  final String id;
  final String title;
  final int minWins; // Mínimo de rondas ganadas
  final int maxWins; // Máximo de rondas ganadas
  final String description;
  final String? playerChoice; // Elección del jugador si aplica

  const StoryEnding({
    required this.id,
    required this.title,
    required this.minWins,
    required this.maxWins,
    required this.description,
    this.playerChoice,
  });
}

/// Owen - El Músico (As, Carta 1)
const owen = StoryCharacter(
  id: 'owen',
  name: 'Owen',
  age: 38,
  origin: 'Europeo',
  occupation: 'Músico olvidado',
  deathDescription: 'Solo en su apartamento. Nadie lo notó por tres días.',
  cardValue: 1,
  isUnlocked: true,
  fragments: [
    StoryFragment(
      round: 1,
      title: 'Su nombre y su música',
      content: '''
Te llamas Owen. Eso lo sabes. Lo que no recuerdas es por qué ese nombre
duele tanto cuando lo piensas.

Hay una melodía en tu cabeza. Fragmentos de algo que nunca terminaste.
Las notas flotan en el vacío, incompletas, como tú.

The Gatekeeper observa mientras barajas. No dice nada.
Todavía no.
''',
    ),
    StoryFragment(
      round: 2,
      title: 'Una hija que adoraba',
      content: '''
Lily. Tenía una hija llamada Lily.

La imagen aparece como un destello: rizos castaños, una risa que
llenaba habitaciones enteras, pequeñas manos tocando el piano junto a ti.

"¿La recuerdas?" pregunta The Gatekeeper, sin mirarte.
"¿O solo recuerdas cómo querías que te recordara?"
''',
    ),
    StoryFragment(
      round: 3,
      title: 'Por qué dejó de verla',
      content: '''
El divorcio. Las peleas. Las promesas rotas.

"Solo necesito tiempo", le decías. "Solo necesito terminar esta canción."
Pero el tiempo pasaba y la canción nunca terminaba.

Las visitas se hicieron menos frecuentes.
Luego mensuales.
Luego... nada.
''',
    ),
    StoryFragment(
      round: 4,
      title: 'Las cartas que nunca envió',
      content: '''
En tu escritorio había una pila de sobres. Cartas para Lily.
Cada una empezaba igual: "Querida Lily, perdóname por..."

Ninguna estaba terminada.
Ninguna fue enviada.

The Gatekeeper sonríe levemente. "¿Qué es más difícil?
¿Escribir una disculpa o vivir sin necesitarla?"
''',
    ),
    StoryFragment(
      round: 5,
      title: 'La noche que todo cambió',
      content: '''
Una llamada. Tu ex esposa llorando.
"Lily preguntó por ti. Por primera vez en dos años."

Dijiste que irías. Que esta vez sería diferente.
Colgaste el teléfono.

Y no fuiste.

¿Por qué? El recuerdo se nubla. Hay algo que no quieres ver.
''',
    ),
    StoryFragment(
      round: 6,
      title: 'Lo que realmente pasó esa noche',
      content: '''
No fue cobardía. Fue peor.

Te sentaste al piano y escribiste. Toda la noche.
La canción más hermosa que jamás compusiste.
Una carta musical para Lily.

Pero no era un regalo. Era una despedida.
Sabías que no la verías nunca más.
Lo elegiste.

The Gatekeeper te observa sin parpadear.
''',
    ),
    StoryFragment(
      round: 7,
      title: 'PLOT TWIST',
      content: '''
Owen no murió solo por accidente.

Las cartas que "nunca envió" eran confesiones. Owen abusó
psicológicamente de su familia durante años, destruyó a su hija
lentamente con su negligencia, sus promesas rotas, su narcisismo
disfrazado de arte.

Cuando Lily finalmente lo cortó de su vida, él se dejó morir
esperando que alguien lo llorara.

Nadie fue al funeral. No fue coincidencia. Fue una decisión colectiva.

La canción sin terminar era para su hija. La última nota revela la letra:
no es un pedido de perdón. Es un reclamo.

"Creí que merecía ser recordado."

The Gatekeeper te mira y no dice nada. Eso ya es una respuesta.
''',
      isPlotTwist: true,
    ),
  ],
  plotTwist: '''
Owen no murió solo por accidente. Su ex pareja lo encontró primero.
Él sabía que ella vendría. Las cartas que 'nunca envió' eran confesiones.
Owen abusó psicológicamente de su familia durante años, destruyó a su hija
lentamente. Cuando ella lo cortó de su vida definitivamente, él se dejó
morir esperando que alguien lo llorara.

Nadie fue al funeral. No fue coincidencia. Fue una decisión colectiva.
''',
  endings: [
    StoryEnding(
      id: 'owen_a',
      title: 'Final A - Recordado',
      minWins: 6,
      maxWins: 7,
      description: '''
The Gatekeeper hace que alguien encuentre tu canción.
Se vuelve famosa años después.

Owen nunca vuelve... pero es recordado para siempre.
''',
      playerChoice: 'Elige el título de la canción',
    ),
    StoryEnding(
      id: 'owen_b',
      title: 'Final B - Una Despedida',
      minWins: 4,
      maxWins: 5,
      description: '''
Owen vuelve por 24 horas.
Una persona. Una conversación. Una despedida real.

El juego no muestra qué hace con ese tiempo.
''',
    ),
    StoryEnding(
      id: 'owen_c',
      title: 'Final C - Silencio',
      minWins: 0,
      maxWins: 3,
      description: '''
The Gatekeeper recoge las cartas y se va sin decir nada.

"Y así, por segunda vez, nadie supo exactamente cuándo se fue."
''',
    ),
  ],
  gatekeeperQuotes: [
    '"Moriste esperando que alguien llorara. Nadie lo hizo. Curioso, ¿no?"',
    '"Las canciones incompletas son las que más duelen."',
    '"¿Cuántas veces dijiste \'mañana\' antes de quedarte sin mañanas?"',
  ],
);

/// Nora Salcedo - La Enfermera (Carta 2)
const nora = StoryCharacter(
  id: 'nora',
  name: 'Nora Salcedo',
  age: 51,
  origin: 'Latina',
  occupation: 'Enfermera de noche, 14 años de servicio',
  deathDescription: 'Respetada, con flores en su funeral. Nadie sospechó nunca.',
  cardValue: 2,
  isUnlocked: true,
  fragments: [
    StoryFragment(
      round: 1,
      title: 'Su nombre y su vocación',
      content: '''
Nora Salcedo. Enfermera. 14 años cuidando de otros.

Las manos que ahora sostienen las cartas han sostenido
cientos de manos moribundas. Has visto más muerte que
la mayoría de las personas pueden imaginar.

"Interesante profesión", dice The Gatekeeper.
"Siempre en la línea entre mis dominios y los tuyos."
''',
    ),
    StoryFragment(
      round: 2,
      title: 'El hospital donde trabajó 14 años',
      content: '''
El Hospital San Vicente. Turno nocturno.

Los pasillos silenciosos a las 3 de la mañana. El sonido
de las máquinas. Los susurros de los pacientes que no
pueden dormir.

Eras la favorita de todos. Los pacientes pedían por ti.
Las familias te agradecían con lágrimas en los ojos.

"Una santa", te llamaban.
''',
    ),
    StoryFragment(
      round: 3,
      title: 'Un paciente especial que recuerda',
      content: '''
Don Eduardo. 87 años. Cáncer terminal.

Lloraba todas las noches. Su familia no venía a visitarlo.
"No quiero seguir", te decía. "Ya no puedo más."

Una noche dejó de llorar.
La mañana siguiente, su cama estaba vacía.

"Murió en paz", le dijiste a la familia.
Ellos te abrazaron, agradecidos.
''',
    ),
    StoryFragment(
      round: 4,
      title: 'El momento en que empezó a cambiar',
      content: '''
Después de Don Eduardo, algo cambió.

Empezaste a ver el sufrimiento de otra manera.
No como algo que aliviar... sino como algo que terminar.

"Nadie debería sufrir tanto", pensabas.
"Nadie debería tener que esperar tanto tiempo."

The Gatekeeper inclina la cabeza. "Continúa."
''',
    ),
    StoryFragment(
      round: 5,
      title: 'Lo que hacía en los turnos nocturnos',
      content: '''
Los turnos nocturnos eran perfectos.
Menos personal. Menos ojos.

Un ajuste en el goteo. Una dosis adicional.
Nada que levantara sospechas.

Ancianos. Enfermos terminales. Algunos que ni siquiera
estaban tan graves.

Pero tú sabías mejor. Tú sabías cuándo era "el momento".
''',
    ),
    StoryFragment(
      round: 6,
      title: 'Por qué nadie sospechó nunca',
      content: '''
Eras la mejor enfermera del hospital.
Compasiva. Dedicada. Siempre presente en los momentos difíciles.

Los médicos confiaban en ti.
Las familias te adoraban.
Los pacientes te pedían por nombre.

¿Quién sospecharía de un ángel?

The Gatekeeper sonríe. "Ángel. Qué palabra tan interesante."
''',
    ),
    StoryFragment(
      round: 7,
      title: 'PLOT TWIST',
      content: '''
Nora era un ángel de la muerte.

Durante años eligió qué pacientes "descansaban" en sus turnos
nocturnos. No por maldad clásica, sino porque genuinamente creía
que los liberaba del sufrimiento.

El fragmento final es su diario. La última entrada:

"Hoy ayudé a trece. Dios entiende lo que los médicos no pueden
hacer. Mañana hay tres más en la lista."

Frente a The Gatekeeper, Nora no siente culpa.
Eso es lo más perturbador.

"¿Hice algo malo? Solo hice lo que tú haces. ¿No somos colegas?"

The Gatekeeper no responde. Solo baraja las cartas.
''',
      isPlotTwist: true,
    ),
  ],
  plotTwist: '''
Nora era un ángel de la muerte. Durante años eligió qué pacientes
"descansaban" en sus turnos nocturnos. No por maldad clásica, sino
porque genuinamente creía que los liberaba del sufrimiento.

Frente a The Gatekeeper, Nora no siente culpa. Eso es lo más perturbador.
''',
  endings: [
    StoryEnding(
      id: 'nora_a',
      title: 'Final A - Redención',
      minWins: 6,
      maxWins: 7,
      description: '''
The Gatekeeper te ofrece una elección:
Volver como enfermera, pero esta vez solo para aliviar el dolor.
Sin atajos. Sin decisiones que no te corresponden.

¿Aceptas?
''',
    ),
    StoryEnding(
      id: 'nora_b',
      title: 'Final B - Verdad',
      minWins: 4,
      maxWins: 5,
      description: '''
Tu diario es encontrado. Tu legado se destruye.
Pero algunas familias, en secreto, te agradecen.

"Mi padre ya no sufre por tu culpa", dice una carta anónima.
No sabes si es agradecimiento o acusación.
''',
    ),
    StoryEnding(
      id: 'nora_c',
      title: 'Final C - Juicio',
      minWins: 0,
      maxWins: 3,
      description: '''
The Gatekeeper se levanta de la mesa.

"Hay alguien que quiere verte."

Detrás de ella, trece sombras esperan.
Tienes mucho que explicar.
''',
    ),
  ],
  gatekeeperQuotes: [
    '"Cuántas veces me enviaste visitas sin avisar. Creo que es justo que ahora hablemos."',
    '"Dices que los liberabas. ¿Quién te dio ese derecho?"',
    '"Trece. Ese fue el número en tu último día. Qué coincidencia."',
  ],
);

/// Lista de todos los personajes
const List<StoryCharacter> allCharacters = [owen, nora];

/// Personajes bloqueados (próximamente)
const List<String> lockedCharacters = [
  'Personaje 3 - ???',
  'Personaje 4 - ???',
  'Personaje 5 - ???',
  'Personaje 6 - ???',
  'Personaje 7 - ???',
  'Personaje 8 - ???',
  'Personaje 9 - ???',
  'Personaje 10 - ???',
];
