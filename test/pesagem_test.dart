import 'package:flutter_test/flutter_test.dart';
import 'package:ecogestao_movel/services/sqlite_service.dart';

void main() {
  test('Deve gerar registro imutavel offline com comprovante #00459', () async {
    final service = SqliteService();
    final resultado = await service.registrarPesagemImutavel(
      material: 'Papelão Pardo',
      pesoKg: 148.5,
    );
    expect(resultado['comprovante'], '#00459');
    expect(resultado['status'], 'offline_gravado');
  });
}
