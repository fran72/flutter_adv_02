class Band {
  int id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

// crea una nueva instancia de la clase, en base al obj que le pasas
  factory Band.fromMap(Map<dynamic, dynamic> obj) => Band(
        id: obj['id'], // id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj['name'],
        votes: obj['votes'], // tambien puede ser asi directamente
      );
}
