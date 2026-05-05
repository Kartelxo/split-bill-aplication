import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dividir Conta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BillSplitterPage(),
    );
  }
}

class Participant {
  final String id;
  final String name;
  Participant({required this.id, required this.name});
}

class BillItem {
  String name;
  double price;
  String? assignedToId; // null significa dividir por todos

  BillItem({required this.name, required this.price, this.assignedToId});
}

class BillSplitterPage extends StatefulWidget {
  const BillSplitterPage({super.key});

  @override
  State<BillSplitterPage> createState() => _BillSplitterPageState();
}

class _BillSplitterPageState extends State<BillSplitterPage> {
  final List<Participant> _participants = [
    Participant(id: '1', name: 'Eu'),
    Participant(id: '2', name: 'Amigo A'),
    Participant(id: '3', name: 'Amigo B'),
  ];

  final List<BillItem> _items = [
    BillItem(name: 'Jantar', price: 45.0),
    BillItem(name: 'Bebidas', price: 15.5),
  ];

  void _addItem() {
    setState(() {
      _items.add(BillItem(name: 'Novo Item', price: 0.0));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Map<String, double> _calculateTotals() {
    Map<String, double> totals = {for (var p in _participants) p.id: 0.0};

    for (var item in _items) {
      if (item.assignedToId == null) {
        double splitAmount = item.price / _participants.length;
        for (var p in _participants) {
          totals[p.id] = (totals[p.id] ?? 0.0) + splitAmount;
        }
      } else {
        totals[item.assignedToId!] = (totals[item.assignedToId!] ?? 0.0) + item.price;
      }
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totals = _calculateTotals();
    final totalBill = _items.fold(0.0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dividir Conta'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _buildSummary(totalBill),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) => _buildItemCard(index),
            ),
          ),
          _buildParticipantBreakdown(totals),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        label: const Text('Artigo'),
        icon: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  Widget _buildSummary(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Text('Total acumulado', style: Theme.of(context).textTheme.labelLarge),
          Text(
            '${total.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index) {
    final item = _items[index];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item.name,
                    decoration: const InputDecoration(hintText: 'Nome do item', border: InputBorder.none),
                    onChanged: (val) => item.name = val,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: item.price.toString(),
                    decoration: const InputDecoration(suffixText: '€', border: InputBorder.none),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    onChanged: (val) => setState(() => item.price = double.tryParse(val) ?? 0.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeItem(index),
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pagar por:'),
                DropdownButton<String?>(
                  value: item.assignedToId,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos (Dividir)')),
                    ..._participants.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
                  ],
                  onChanged: (val) => setState(() => item.assignedToId = val),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantBreakdown(Map<String, double> totals) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo por Participante', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            ..._participants.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.name),
                      Text(
                        '${totals[p.id]?.toStringAsFixed(2)} €',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
