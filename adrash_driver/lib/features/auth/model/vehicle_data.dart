// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VehicleData {
  String id;
  String make; //The manufacturer or brand of the vehicle (e.g., Toyota, Ford, Tesla).
  String model; //The specific model of the vehicle (e.g., Corolla, Focus, Model S).
  int year; //The year the vehicle was manufactured.
  String licensePlate; //The unique license plate number of the vehicle.
  String color; //The color of the vehicle (e.g., Red, Black, White).
  int seats; //The number of seats in the vehicle.
  // String fuelType; //The type of fuel used in the vehicle (e.g., Gasoline, Diesel, Electric).
  // String transmission; //The type of transmission system used in the vehicle (e.g., Manual, Automatic, Semi-Automatic).
  // double mileage; //The total distance the vehicle has traveled (odometer reading).
  List<String> vehicleImages;

  VehicleData({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.seats,
    required this.vehicleImages,
  });

  VehicleData copyWith({
    String? id,
    String? make,
    String? model,
    int? year,
    String? licensePlate,
    String? color,
    int? seats,
    List<String>? vehicleImages,
  }) {
    return VehicleData(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      color: color ?? this.color,
      seats: seats ?? this.seats,
      vehicleImages: vehicleImages ?? this.vehicleImages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'color': color,
      'seats': seats,
      'vehicleImages': vehicleImages,
    };
  }

  factory VehicleData.fromMap(Map<String, dynamic> map) {
    return VehicleData(
      id: map['id'] as String,
      make: map['make'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      licensePlate: map['licensePlate'] as String,
      color: map['color'] as String,
      seats: map['seats'] as int,
      vehicleImages: List<String>.from(
        (map['vehicleImages'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleData.fromJson(String source) => VehicleData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VehicleData(id: $id, make: $make, model: $model, year: $year, licensePlate: $licensePlate, color: $color, seats: $seats, vehicleImages: $vehicleImages)';
  }

  @override
  bool operator ==(covariant VehicleData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.make == make &&
        other.model == model &&
        other.year == year &&
        other.licensePlate == licensePlate &&
        other.color == color &&
        other.seats == seats &&
        listEquals(other.vehicleImages, vehicleImages);
  }

  @override
  int get hashCode {
    return id.hashCode ^ make.hashCode ^ model.hashCode ^ year.hashCode ^ licensePlate.hashCode ^ color.hashCode ^ seats.hashCode ^ vehicleImages.hashCode;
  }
}
