class Missoes {
  String id;
  String titulo;
  int grau;
  bool concluida;
  String usuarioId;

  Missoes({
    required this.id,
    required this.titulo,
    required this.grau,
    required this.concluida,
    required this.usuarioId,
  });

  factory Missoes.fromMap(String id, Map<String, dynamic> dados) {
    return Missoes(
      id: id,
      titulo: dados['titulo'] ?? '',
      grau: dados['grau'] ?? 0,
      concluida: dados['concluida'] ?? false,
      usuarioId: dados['usuarioId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'concluida': concluida,
      'grau': grau,
      'usuarioId': usuarioId,
    };
  }
}
