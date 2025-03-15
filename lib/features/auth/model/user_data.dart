// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:adrash/features/auth/model/vehicle_data.dart';
import 'dart:convert';
import 'package:adrash/features/auth/model/vehicle_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class UserData {
  String id;
  String docDataId;
  String name;
  String email;
  String phoneNumber;
  String role; // driver or rider
  double rating;
  String profilePictureUrl;
  double lastLocLat;
  double lastLocLong;
  bool isDriverAvailable;
  VehicleData? vehicleData;

  UserData({
    required this.id,
    required this.docDataId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.rating,
    required this.profilePictureUrl,
    required this.lastLocLat,
    required this.lastLocLong,
    this.isDriverAvailable = false,
    this.vehicleData,
  });

  UserData copyWith({
    String? id,
    String? docDataId,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    double? rating,
    String? profilePictureUrl,
    double? lastLocLat,
    double? lastLocLong,
    bool? isDriverAvailable,
    VehicleData? vehicleData,
  }) {
    return UserData(
      id: id ?? this.id,
      docDataId: docDataId ?? this.docDataId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      rating: rating ?? this.rating,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      lastLocLat: lastLocLat ?? this.lastLocLat,
      lastLocLong: lastLocLong ?? this.lastLocLong,
      isDriverAvailable: isDriverAvailable ?? this.isDriverAvailable,
      vehicleData: vehicleData ?? this.vehicleData,
    );
  }

  Map<String, dynamic> toMap() {
    // Define GeoFirePoint by instantiating GeoFirePoint with latitude and longitude.
    final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(lastLocLat, lastLocLong));
    // Gets GeoPoint instance and Geohash string as Map<String, dynamic>.
    final Map<String, dynamic> data = geoFirePoint.data;
    // {geopoint: Instance of 'GeoPoint', geohash: xn76urx66}
    // print(data);

    return <String, dynamic>{
      'id': id,
      'docDataId': docDataId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'rating': rating,
      'profilePictureUrl': profilePictureUrl,
      // 'lastLocLat': lastLocLat,
      // 'lastLocLong': lastLocLong,
      'lastLocData': data,
      'isDriverAvailable': isDriverAvailable,
      'vehicleData': vehicleData?.toMap(),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> lastLocData = map['lastLocData'] as Map<String, dynamic>;
    GeoPoint lastLocGeoPoint = lastLocData['geopoint'] as GeoPoint;

    return UserData(
      id: map['id'] as String,
      docDataId: map['docDataId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      role: map['role'] as String,
      rating: map['rating'] as double,
      profilePictureUrl: map['profilePictureUrl'] as String,
      lastLocLat: lastLocGeoPoint.latitude,
      lastLocLong: lastLocGeoPoint.longitude,
      isDriverAvailable: map['isDriverAvailable'] as bool,
      vehicleData: map['vehicleData'] != null ? VehicleData.fromMap(map['vehicleData'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(id: $id, docDataId: $docDataId, name: $name, email: $email, phoneNumber: $phoneNumber, role: $role, rating: $rating, profilePictureUrl: $profilePictureUrl, lastLocLat: $lastLocLat, lastLocLong: $lastLocLong, isDriverAvailable: $isDriverAvailable, vehicleData: $vehicleData)';
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docDataId == docDataId &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.rating == rating &&
        other.profilePictureUrl == profilePictureUrl &&
        other.lastLocLat == lastLocLat &&
        other.lastLocLong == lastLocLong &&
        other.isDriverAvailable == isDriverAvailable &&
        other.vehicleData == vehicleData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docDataId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        role.hashCode ^
        rating.hashCode ^
        profilePictureUrl.hashCode ^
        lastLocLat.hashCode ^
        lastLocLong.hashCode ^
        isDriverAvailable.hashCode ^
        vehicleData.hashCode;
  }
}
