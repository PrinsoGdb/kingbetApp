class Caisse {
  final int choosedAgent;
  final String caisse;

  Caisse({
    required this.choosedAgent,
    required this.caisse,
  });

  // Factory method to create a Caisse object from JSON data
  factory Caisse.fromJson(Map<String, dynamic> json) {
    return Caisse(
      choosedAgent: json['choosed_agent'],
      caisse: json['caisse'],
    );
  }

  // Method to convert a Caisse object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'choosedAgent': choosedAgent,
      'caisse': caisse,
    };
  }
}
