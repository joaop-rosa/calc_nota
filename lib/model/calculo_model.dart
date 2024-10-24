class Calculo {
  double? nota;
  DateTime? timestamp;

  Calculo({this.nota, this.timestamp});

  // Converter JSON para o modelo
  factory Calculo.fromJson(Map<String, dynamic> json) {
    return Calculo(
      nota: json['nota']?.toDouble(),
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  // Converter o modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'nota': nota,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
