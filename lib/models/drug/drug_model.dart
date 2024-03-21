// ignore_for_file: non_constant_identifier_names

class Drug {
  const Drug({
    required this.name,
    required this.dosage,
  });

  final String name;
  final List<String> dosage;

  factory Drug.fromJson(dynamic json) {
    return Drug(
      name: json['name'],
      dosage:
          (json['dosage'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
    };
  }
}
