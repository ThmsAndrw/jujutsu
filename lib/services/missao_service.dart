import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/missoes.dart';

class MissoesService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String colecao = 'jujutsu_missoes';

  String? get usuarioIdAtual => _auth.currentUser?.uid;

  Stream<List<Missoes>> listarMissoes() {
    final userId = usuarioIdAtual;

    if (userId == null) {
      return const Stream.empty();
    }

    return _firebase
        .collection(colecao)
        .where('usuarioId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((documento) {
            return Missoes.fromMap(
              documento.id,
              documento.data(),
            );
          }).toList();
        });
  }

  Future<void> adicionarMissao(String titulo, int grau) async {
    final userId = usuarioIdAtual;

    if (userId == null) {
      return;
    }

    await _firebase.collection(colecao).add({
      'titulo': titulo,
      'grau': grau,
      'concluida': false,
      'usuarioId': userId,
    });
  }

  Future<void> alterarStatus(Missoes missoes) async {
    await _firebase.collection(colecao).doc(missoes.id).update({
      'concluida': !missoes.concluida,
    });
  }

  Future<void> excluirTarefa(String id) async {
    await _firebase.collection(colecao).doc(id).delete();
  }
}
