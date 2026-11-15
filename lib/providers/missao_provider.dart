import 'package:flutter/material.dart';

import '../models/missoes.dart';
import '../services/missao_service.dart';

class MissoesProvider extends ChangeNotifier {
  final MissoesService _service = MissoesService();

  List<Missoes> missoes = [];

  bool carregando = true;

  MissoesProvider() {
    carregarMissoes();
  }

  void carregarMissoes() {
    _service.listarMissoes().listen((lista) {
      missoes = lista;

      carregando = false;

      notifyListeners();
    });
  }

  Future<void> adicionar(String titulo, int grau) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    await _service.adicionarMissao(
      titulo.trim(),
      grau,
    );
  }

  Future<void> alterarStatus(Missoes missoes) async {
    await _service.alterarStatus(missoes);
  }

  Future<void> excluir(String id) async {
    await _service.excluirTarefa(id);
  }
}
