// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VehicleType {
  final String name;
  final int seat;
  VehicleType({
    required this.name,
    required this.seat,
  });

  VehicleType copyWith({
    String? name,
    int? seat,
  }) {
    return VehicleType(
      name: name ?? this.name,
      seat: seat ?? this.seat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'seat': seat,
    };
  }

  factory VehicleType.fromMap(Map<String, dynamic> map) {
    return VehicleType(
      name: map['name'] as String,
      seat: map['seat'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleType.fromJson(String source) => VehicleType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VehicleType(name: $name, seat: $seat)';

  @override
  bool operator ==(covariant VehicleType other) {
    if (identical(this, other)) return true;

    return other.name == name && other.seat == seat;
  }

  @override
  int get hashCode => name.hashCode ^ seat.hashCode;
}
