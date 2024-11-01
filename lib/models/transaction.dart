// transaction.dart
class Transaction {
  final String? agentId;
  final String? clientId;
  final String typeOperation;
  final int montantOperation;
  final String? moyenPaiement;
  final String? statutOperation;
  final String? xbetId;
  final String? transId;
  final String? retraitId;
  final String? codeId;
  final String? numeroReccepteur;
  final String? nomReccepteur;
  final String bookmaker;
  final String? lieuRetrait;
  final String? createdAt;

  Transaction({
    this.agentId,
    this.clientId,
    required this.typeOperation,
    required this.montantOperation,
    this.moyenPaiement,
    this.statutOperation,
    this.xbetId,
    this.transId,
    this.lieuRetrait,
    this.retraitId,
    this.codeId,
    this.numeroReccepteur,
    this.nomReccepteur,
    required this.bookmaker,
    this.createdAt,
  });

  // Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'agent_id': agentId,
      'client_id': clientId,
      'type_operation': typeOperation,
      'montant_operation': montantOperation,
      'moyen_paiement': moyenPaiement,
      'statut_operation': statutOperation,
      'xbet_id': xbetId,
      'trans_id': transId,
      'retrait_id': retraitId,
      'code_id': codeId,
      'lieu_retrait': lieuRetrait,
      'numero_reccepteur': numeroReccepteur,
      'nom_reccepteur': nomReccepteur,
      'bookmaker': bookmaker,
    };
  }

  // Create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      agentId: json['agent_id'],
      clientId: json['client_id'],
      typeOperation: json['type_operation'],
      montantOperation: int.parse(json['montant_operation']),
      moyenPaiement: json['moyen_paiement'],
      statutOperation: json['statut_operation'],
      xbetId: json['xbet_id'],
      transId: json['trans_id'],
      retraitId: json['retrait_id'],
      codeId: json['code_id'],
      numeroReccepteur: json['numero_reccepteur'],
      lieuRetrait: json['lieu_retrait'],
      nomReccepteur: json['nom_reccepteur'],
      bookmaker: json['bookmaker'],
      createdAt: json['created_at'],
    );
  }
}
