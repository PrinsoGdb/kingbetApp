class User {
  final int? id;
  final String name;
  final String email;
  final String telUser;
  final String? statut;
  final String? password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.telUser,
    this.statut,
    this.password,
  });

  // Factory method to create a News object from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telUser: json['telUser'],
    );
  }

  // Method to convert a User object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'telUser': telUser,
      'statut': 'Client',
      'password': password,
    };
  }
}
