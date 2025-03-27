import 'dart:convert';
import 'package:adrash/core/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverData {
  String driverDocId;
  double lastLocLat;
  double lastLocLong;
  bool isDriverAvailable;

  DriverData({
    required this.driverDocId,
    required this.lastLocLat,
    required this.lastLocLong,
    required this.isDriverAvailable,
  });

  DriverData copyWith({
    String? driverDocId,
    double? lastLocLat,
    double? lastLocLong,
    bool? isDriverAvailable,
  }) {
    return DriverData(
      driverDocId: driverDocId ?? this.driverDocId,
      lastLocLat: lastLocLat ?? this.lastLocLat,
      lastLocLong: lastLocLong ?? this.lastLocLong,
      isDriverAvailable: isDriverAvailable ?? this.isDriverAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'driverDocId': driverDocId,
      // 'lastLocLat': lastLocLat,
      // 'lastLocLong': lastLocLong,
      'lastLocData': convertLatLongToGeoPoint(LatLng(lastLocLat, lastLocLong)),
      'isDriverAvailable': isDriverAvailable,
    };
  }

  factory DriverData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> lastLocData = map['lastLocData'] as Map<String, dynamic>;
    GeoPoint lastLocGeoPoint = lastLocData['geopoint'] as GeoPoint;

    return DriverData(
      driverDocId: map['driverDocId'] as String,
      lastLocLat: lastLocGeoPoint.latitude,
      lastLocLong: lastLocGeoPoint.longitude,
      isDriverAvailable: map['isDriverAvailable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverData.fromJson(String source) => DriverData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DriverData(driverDocId: $driverDocId, lastLocLat: $lastLocLat, lastLocLong: $lastLocLong, isDriverAvailable: $isDriverAvailable)';
  }

  @override
  bool operator ==(covariant DriverData other) {
    if (identical(this, other)) return true;

    return other.driverDocId == driverDocId && other.lastLocLat == lastLocLat && other.lastLocLong == lastLocLong && other.isDriverAvailable == isDriverAvailable;
  }

  @override
  int get hashCode {
    return driverDocId.hashCode ^ lastLocLat.hashCode ^ lastLocLong.hashCode ^ isDriverAvailable.hashCode;
  }
}
