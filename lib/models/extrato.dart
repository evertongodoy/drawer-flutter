class Extrato {
  final int id;
  final int idContaOrigem;
  final String pessoaOrigem;
  final int idContaDestino;
  final String pessoaDestino;
  final double valor;
  final DateTime dataLancamento;

  Extrato({
    required this.id,
    required this.idContaOrigem,
    required this.pessoaOrigem,
    required this.idContaDestino,
    required this.pessoaDestino,
    required this.valor,
    required this.dataLancamento,
  });

  factory Extrato.fromJson(Map<String, dynamic> json) {
    return Extrato(
      id: json['id'],
      idContaOrigem: json['id_conta_origem'],
      pessoaOrigem: json['pessoa_origem'],
      idContaDestino: json['id_conta_destino'],
      pessoaDestino: json['pessoa_destino'],
      valor: (json['valor'] as num).toDouble(),
      dataLancamento: DateTime.parse(json['data_lancamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_conta_origem': idContaOrigem,
      'pessoa_origem': pessoaOrigem,
      'id_conta_destino': idContaDestino,
      'pessoa_destino': pessoaDestino,
      'valor': valor,
      'data_lancamento': dataLancamento.toIso8601String().split('T')[0], // apenas a data
    };
  }
}
