class NegativeBehavior {
  final int id;
  final String description;

  NegativeBehavior({
    required this.id,
    required this.description,
  });

  factory NegativeBehavior.fromJson(Map<String, dynamic> json) {
    return NegativeBehavior(
      id: json['id'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }
}
