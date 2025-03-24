// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserGeocodedLoc {
  final String name;
  final String subLocality;
  final String locality;
  UserGeocodedLoc({
    required this.name,
    required this.subLocality,
    required this.locality,
  });

  UserGeocodedLoc copyWith({
    String? name,
    String? subLocality,
    String? locality,
  }) {
    return UserGeocodedLoc(
      name: name ?? this.name,
      subLocality: subLocality ?? this.subLocality,
      locality: locality ?? this.locality,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subLocality': subLocality,
      'locality': locality,
    };
  }

  factory UserGeocodedLoc.fromMap(Map<String, dynamic> map) {
    return UserGeocodedLoc(
      name: map['name'] as String,
      subLocality: map['subLocality'] as String,
      locality: map['locality'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGeocodedLoc.fromJson(String source) => UserGeocodedLoc.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserGeocodedLoc(name: $name, subLocality: $subLocality, locality: $locality)';

  @override
  bool operator ==(covariant UserGeocodedLoc other) {
    if (identical(this, other)) return true;

    return other.name == name && other.subLocality == subLocality && other.locality == locality;
  }

  @override
  int get hashCode => name.hashCode ^ subLocality.hashCode ^ locality.hashCode;
}
