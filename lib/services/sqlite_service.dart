class SqliteService {
  Future> registrarPesagemImutavel({
    required String material,
    required double pesoKg,
  }) async {
    return {
      'comprovante': '#00459',
      'material': material,
      'peso_kg': pesoKg,
      'hash': DateTime.now().millisecondsSinceEpoch.toRadixString(16),
      'status': 'offline_gravado',
    };
  }
}
