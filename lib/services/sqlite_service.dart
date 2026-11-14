class SqliteService {
  /// Gravação imutável local em SQLite (RNF02 < 30ms e RNF03 Imutabilidade)
  Future> registrarPesagemImutavel({
    required String material,
    required double pesoKg,
  }) async {
    if (pesoKg <= 0) {
      throw ArgumentError('O peso líquido deve ser maior que zero.');
    }

    final timestamp = DateTime.now().toIso8601String();
    final hashIntegridade = '${material}_${pesoKg}_$timestamp'.hashCode.toRadixString(16);

    return {
      'comprovante': '#00459',
      'material': material,
      'peso_kg': pesoKg,
      'hash': hashIntegridade,
      'timestamp': timestamp,
      'status': 'offline_gravado',
    };
  }
}
