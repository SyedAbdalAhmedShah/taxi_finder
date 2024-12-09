class CityToCityModel {
  final String? cityUrl;
  final String? docId;
  final String? fare;
  final String? from;
  final String? to;

  CityToCityModel({
    this.cityUrl,
    this.docId,
    this.fare,
    this.from,
    this.to,
  });

  // Factory constructor to create a Trip from a JSON map
  factory CityToCityModel.fromJson(Map<String, dynamic> json) {
    return CityToCityModel(
      cityUrl: json['cityUrl'] as String?,
      docId: json['docId'] as String?,
      fare: json['fare'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
    );
  }

  // Method to convert Trip to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'cityUrl': cityUrl,
      'docId': docId,
      'fare': fare,
      'from': from,
      'to': to,
    };
  }

  // Optional: Add copyWith method for easy modification
  CityToCityModel copyWith({
    String? cityUrl,
    String? docId,
    String? fare,
    String? from,
    String? to,
  }) {
    return CityToCityModel(
      cityUrl: cityUrl ?? this.cityUrl,
      docId: docId ?? this.docId,
      fare: fare ?? this.fare,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}
