class Tarefa {
  String tipo;
  String titulo;
  String periodo;
  double peso;
  double? nota;
  DateTime? timestamp;

  Tarefa(
      {required this.tipo,
      required this.titulo,
      required this.periodo,
      required this.peso,
      this.nota,
      this.timestamp});

  // Converter JSON para o modelo
  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      tipo: json['tipo'],
      titulo: json['titulo'],
      periodo: json['periodo'],
      peso: json['peso'].toDouble(),
      nota: json['nota']?.toDouble(),
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  // Converter o modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'titulo': titulo,
      'periodo': periodo,
      'peso': peso,
      'nota': nota,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Tarefa(tipo: $tipo, titulo: $titulo, periodo: $periodo, peso: $peso, '
        'nota: ${nota ?? 'N/A'}, timestamp: ${timestamp?.toIso8601String() ?? 'N/A'})';
  }
}
