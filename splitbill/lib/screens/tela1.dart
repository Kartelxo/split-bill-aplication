import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// IMPORTS DOS TEUS WIDGETS
import '../widgets/appButton.dart';
import '../widgets/extendedFAB.dart';
import '../widgets/listTileClass.dart';
import '../widgets/textField.dart';

// IMPORTS DOS MODELS
import '../models/pessoa.dart';
import '../models/produto.dart';

/// PROVIDERS (no mesmo ficheiro)
final pessoasProvider =
    StateNotifierProvider<PessoasNotifier, List<Pessoa>>(
  (ref) => PessoasNotifier(),
);

class PessoasNotifier extends StateNotifier<List<Pessoa>> {
  PessoasNotifier() : super([]);

  void adicionar(String nome) {
    state = [
      ...state,
      Pessoa(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nome: nome,
      ),
    ];
  }
}

final produtosProvider =
    StateNotifierProvider<ProdutosNotifier, List<Produto>>(
  (ref) => ProdutosNotifier(),
);

class ProdutosNotifier extends StateNotifier<List<Produto>> {
  ProdutosNotifier() : super([]);

  void adicionar(String nome, double preco) {
    state = [
      ...state,
      Produto(
        nome: nome,
        preco: preco,
        quantidade: 1,
      ),
    ];
  }
}

/// SCREEN
class DivisaoScreen extends ConsumerStatefulWidget {
  const DivisaoScreen({super.key});

  @override
  ConsumerState<DivisaoScreen> createState() => _DivisaoScreenState();
}

class _DivisaoScreenState extends ConsumerState<DivisaoScreen> {
  final pessoaController = TextEditingController();
  final produtoNomeController = TextEditingController();
  final produtoPrecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pessoas = ref.watch(pessoasProvider);
    final produtos = ref.watch(produtosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Divisão de Contas"),
      ),

     //adicionar botao para pagina seguinte 

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 PESSOAS
            const Text(
              "Pessoas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            AppTextField(
              controller: pessoaController,
              label: "Nome da pessoa",
            ),

            const SizedBox(height: 8),

            AppButton(
              text: "Adicionar Pessoa",
              onPressed: _adicionarPessoa,
            ),

            const SizedBox(height: 12),

            ...pessoas.map(
              (p) => SimpleListTile(
                title: p.nome,
              ),
            ),

            const SizedBox(height: 24),

            /// 🛒 PRODUTOS
            const Text(
              "Produtos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            AppTextField(
              controller: produtoNomeController,
              label: "Nome do produto",
            ),

            const SizedBox(height: 8),

            AppTextField(
              controller: produtoPrecoController,
              label: "Preço",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 8),

            AppButton(
              text: "Adicionar Produto",
              onPressed: _adicionarProduto,
            ),

            const SizedBox(height: 12),

            ...produtos.map(
              (p) => SimpleListTile(
                title: p.nome,
                subtitle: "${p.preco.toStringAsFixed(2)} €",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarPessoa() {
    final nome = pessoaController.text.trim();
    if (nome.isEmpty) return;

    ref.read(pessoasProvider.notifier).adicionar(nome);
    pessoaController.clear();
  }

  void _adicionarProduto() {
    final nome = produtoNomeController.text.trim();
    final preco = double.tryParse(produtoPrecoController.text);

    if (nome.isEmpty || preco == null) return;

    ref.read(produtosProvider.notifier).adicionar(nome, preco);
    produtoNomeController.clear();
    produtoPrecoController.clear();
  }
}