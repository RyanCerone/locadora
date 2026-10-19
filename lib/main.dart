import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocadoraPage(),
    );
  }
}

class LocadoraPage extends StatefulWidget {
  const LocadoraPage({super.key});

  @override
  State<LocadoraPage> createState() => _LocadoraPageState();
}

class _LocadoraPageState extends State<LocadoraPage> {
  // Variáveis básicas do app
  int tipoCarro = 1; // 1 = Econômico, 2 = SUV, 3 = Luxo
  bool seguro = false;
  bool gps = false;
  bool motorista = false;
  int dias = 1; // Quantidade de dias como um número inteiro simples

  @override
  Widget build(BuildContext context) {
    // 1. Valor da diária do carro
    double valorDiaria = 120.0;
    if (tipoCarro == 2) {
      valorDiaria = 180.0;
    } else if (tipoCarro == 3) {
      valorDiaria = 300.0;
    }

    // 2. Somar opcionais na diária
    if (seguro) valorDiaria += 40.0;
    if (gps) valorDiaria += 15.0;

    // 3. Valor bruto (diária total * dias)
    double valorBruto = valorDiaria * dias;

    // 4. Motorista adicional
    if (motorista) {
      valorBruto += 100.0;
    }

    // 5. Desconto por fidelidade
    double desconto = 0;
    if (dias >= 15) {
      desconto = valorBruto * 0.10;
    } else if (dias >= 7) {
      desconto = valorBruto * 0.05;
    }

    // 6. Valor final
    double valorFinal = valorBruto - desconto;

    // Desafio Extra: Categoria
    String categoria = "Bronze";
    if (valorFinal > 5000) {
      categoria = "Platinum";
    } else if (valorFinal > 3000) {
      categoria = "Ouro";
    } else if (valorFinal > 1000) {
      categoria = "Prata";
    }

    // Nome do carro para o resumo
    String nomeCarro = "Econômico";
    if (tipoCarro == 2) nomeCarro = "SUV";
    if (tipoCarro == 3) nomeCarro = "Luxo";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locadora de Carros'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Escolha do Carro
            const Text('1. Escolha o Veículo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(value: 1, label: Text('Econômico')),
                  ButtonSegment<int>(value: 2, label: Text('SUV')),
                  ButtonSegment<int>(value: 3, label: Text('Luxo')),
                ],
                selected: {tipoCarro},
                onSelectionChanged: (Set<int> novaSelecao) {
                  setState(() {
                    tipoCarro = novaSelecao.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // 2 e 3. Opcionais
            const Text('2 e 3. Opcionais', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Seguro Completo (R\$ 40/dia)'),
              value: seguro,
              onChanged: (bool? valor) {
                setState(() {
                  seguro = valor ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('GPS (R\$ 15/dia)'),
              value: gps,
              onChanged: (bool? valor) {
                setState(() {
                  gps = valor ?? false;
                });
              },
            ),

            // 4. Motorista
            const Text('4. Motorista Adicional', style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Taxa Fixa (R\$ 100)'),
              value: motorista,
              onChanged: (bool valor) {
                setState(() {
                  motorista = valor;
                });
              },
            ),
            const SizedBox(height: 16),

            // 5. Quantidade de Dias (Slider simples)
            Text('5. Quantidade de Dias: $dias', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: dias.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: dias.toString(),
              onChanged: (double valor) {
                setState(() {
                  dias = valor.toInt();
                });
              },
            ),
            const Divider(height: 30),

            // Exibição na tela
            Text('Valor Bruto: R\$ ${valorBruto.toStringAsFixed(2)}'),
            Text('Desconto: R\$ ${desconto.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
            Text('Valor Final: R\$ ${valorFinal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Categoria: $categoria', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // 9. Botão Finalizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Resumo da Locação'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Veículo: $nomeCarro'),
                            Text('Dias: $dias'),
                            Text('Seguro: ${seguro ? "Sim" : "Não"}'),
                            Text('GPS: ${gps ? "Sim" : "Não"}'),
                            Text('Motorista: ${motorista ? "Sim" : "Não"}'),
                            Text('Valor Bruto: R\$ ${valorBruto.toStringAsFixed(2)}'),
                            Text('Desconto: R\$ ${desconto.toStringAsFixed(2)}'),
                            Text('Valor Final: R\$ ${valorFinal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Categoria: $categoria', style: const TextStyle(color: Colors.blue)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Confirmar Reserva'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reserva realizada com sucesso!')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Finalizar Reserva'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}