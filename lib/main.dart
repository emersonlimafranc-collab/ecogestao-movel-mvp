import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const EcoGestaoApp());
}

class EcoGestaoApp extends StatelessWidget {
  const EcoGestaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoGestão Móvel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          contrastLevel: 1.0, // WCAG AA Alta Legibilidade (RNF04)
        ),
        useMaterial3: true,
      ),
      home: const TelaMenuInicial(),
    );
  }
}

class TelaMenuInicial extends StatefulWidget {
  const TelaMenuInicial({super.key});

  @override
  State<TelaMenuInicial> createState() => _TelaMenuInicialState();
}

class _TelaMenuInicialState extends State<TelaMenuInicial> {
  final List> _pesagensLocais = [
    {
      'id': '#00458',
      'material': 'Plástico PET',
      'peso': '82.0 kg',
      'hash': 'a8f9c2e1',
    },
  ];

  void _adicionarPesagem(String material, String peso) {
    setState(() {
      final proximoId = '#00${459 + _pesagensLocais.length - 1}';
      _pesagensLocais.insert(0, {
        'id': proximoId,
        'material': material,
        'peso': '$peso kg',
        'hash': DateTime.now().millisecondsSinceEpoch.toRadixString(16),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text(
          'EcoGestão Móvel',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFFFFB300),
            child: const Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.black, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'MODO OFFLINE ATIVO • Gravação Local Segura',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 88, // RNF04: > 80 dp
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final resultado = await Navigator.push>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaRegistroPesagem(),
                    ),
                  );
                  if (resultado != null) {
                    _adicionarPesagem(
                      resultado['material']!,
                      resultado['peso']!,
                    );
                  }
                },
                icon: const Icon(Icons.scale, size: 36),
                label: const Text(
                  'NOVA PESAGEM',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lotes Gravados no Aparelho (SQLite):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _pesagensLocais.length,
              itemBuilder: (context, index) {
                final item = _pesagensLocais[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF1B5E20),
                      size: 36,
                    ),
                    title: Text(
                      '${item['id']} • ${item['material']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Peso: ${item['peso']} | Hash: ${item['hash']}',
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TelaRegistroPesagem extends StatefulWidget {
  const TelaRegistroPesagem({super.key});

  @override
  State<TelaRegistroPesagem> createState() => _TelaRegistroPesagemState();
}

class _TelaRegistroPesagemState extends State<TelaRegistroPesagem> {
  String _materialSelecionado = 'Papelão Pardo';
  String _pesoDigitado = '';

  final List<String> _materiais = [
    'Papelão Pardo',
    'Plástico PET',
    'Alumínio',
    'Vidro',
  ];

  void _pressionarTecla(String valor) {
    HapticFeedback.selectionClick();
    setState(() {
      if (valor == 'APAGAR') {
        if (_pesoDigitado.isNotEmpty) {
          _pesoDigitado = _pesoDigitado.substring(0, _pesoDigitado.length - 1);
        }
      } else if (valor == '.') {
        if (!_pesoDigitado.contains('.') && _pesoDigitado.isNotEmpty) {
          _pesoDigitado += '.';
        }
      } else {
        if (_pesoDigitado.length < 6) {
          _pesoDigitado += valor;
        }
      }
    });
  }

  void _confirmarPesagem() {
    if (_pesoDigitado.isEmpty || double.tryParse(_pesoDigitado) == null) {
      return;
    }
    HapticFeedback.heavyImpact();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaConfirmacao(
          material: _materialSelecionado,
          peso: _pesoDigitado,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text('Registrar Peso', style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _materiais.map((mat) {
                final selecionado = mat == _materialSelecionado;
                return ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      mat,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: selecionado ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  selected: selecionado,
                  selectedColor: const Color(0xFF1B5E20),
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    setState(() => _materialSelecionado = mat);
                  },
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              _pesoDigitado.isEmpty ? '0.0 kg' : '$_pesoDigitado kg',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.35,
                children: [
                  '1', '2', '3',
                  '4', '5', '6',
                  '7', '8', '9',
                  '.', '0', 'APAGAR',
                ].map((tecla) {
                  final ehApagar = tecla == 'APAGAR';
                  return SizedBox(
                    minWidth: 80,
                    minHeight: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ehApagar
                            ? Colors.red.shade800
                            : Colors.grey.shade900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _pressionarTecla(tecla),
                      child: Text(
                        tecla,
                        style: TextStyle(
                          fontSize: ehApagar ? 18 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                ),
                onPressed: _confirmarPesagem,
                child: const Text(
                  'CONFIRMAR PESAGEM',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaConfirmacao extends StatelessWidget {
  final String material;
  final String peso;

  const TelaConfirmacao({
    super.key,
    required this.material,
    required this.peso,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF1B5E20),
                size: 110,
              ),
              const SizedBox(height: 16),
              const Text(
                'PESAGEM SALVA!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comprovante Local #00459',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 2),
                    Text(
                      'Material: $material',
                      style: const TextStyle(fontSize: 19),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Peso Líquido: $peso kg',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status: Gravado Offline (Imutável)',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 84,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'material': material,
                      'peso': peso,
                    });
                  },
                  child: const Text(
                    'VOLTAR AO MENU',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
