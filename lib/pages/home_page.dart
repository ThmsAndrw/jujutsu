import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/missao_provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();

  final TextEditingController missaoController = TextEditingController();
  final TextEditingController grauController = TextEditingController();

  @override
  void dispose() {
    missaoController.dispose();
    grauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Missões'),
        actions: [
          IconButton(
            tooltip: 'Trocar conta',
            icon: const Icon(Icons.switch_account),
            onPressed: () async {
              await authService.trocarConta();
            },
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.sair();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (usuario?.photoURL != null)
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          usuario!.photoURL!,
                        ),
                      )
                    else
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario?.displayName ?? 'Usuário',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            usuario?.email ?? 'E-mail não disponível',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: missaoController,
              decoration: const InputDecoration(
                labelText: 'Digite uma missão',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: grauController,
              decoration: const InputDecoration(
                labelText: 'Digite o grau',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<MissoesProvider>();

                  await provider.adicionar(
                    missaoController.text,
                    int.parse(grauController.text),
                  );

                  missaoController.clear();
                },
                child: const Text(
                  'Adicionar missao',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<MissoesProvider>(
                builder: (
                  context,
                  provider,
                  child,
                ) {
                  if (provider.carregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.missoes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma missão cadastrada.',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.missoes.length,
                    itemBuilder: (context, index) {
                      final missao = provider.missoes[index];

                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Checkbox(
                                value: missao.concluida,
                                onChanged: (valor) {
                                  provider.alterarStatus(
                                    missao,
                                  );
                                },
                              ),
                              title: Text(
                                missao.titulo,
                                style: TextStyle(
                                  decoration: missao.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                onPressed: () {
                                  provider.excluir(
                                    missao.id,
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Grau: ${missao.grau}',
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
