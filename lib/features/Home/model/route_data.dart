import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteData {
  LatLng startLoc;
  LatLng endLoc;
  Set<Polyline> polyline;
  Marker startMarker;
  Marker destinationMarker;
  double distanceInMeters;
  Duration durationInSeconds;

  RouteData({
    required this.startLoc,
    required this.endLoc,
    required this.polyline,
    required this.startMarker,
    required this.destinationMarker,
    required this.distanceInMeters,
    required this.durationInSeconds,
  });

  RouteData copyWith({
    LatLng? startLoc,
    LatLng? endLoc,
    Set<Polyline>? polyline,
    Marker? startMarker,
    Marker? destinationMarker,
    double? distanceInMeters,
    Duration? durationInSeconds,
  }) {
    return RouteData(
      startLoc: startLoc ?? this.startLoc,
      endLoc: endLoc ?? this.endLoc,
      polyline: polyline ?? this.polyline,
      startMarker: startMarker ?? this.startMarker,
      destinationMarker: destinationMarker ?? this.destinationMarker,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }

  @override
  String toString() {
    return 'RouteData(startLoc: $startLoc, endLoc: $endLoc, polyline: $polyline, startMarker: $startMarker, destinationMarker: $destinationMarker, distanceInMeters: $distanceInMeters, durationInSeconds: $durationInSeconds)';
  }

  @override
  bool operator ==(covariant RouteData other) {
    if (identical(this, other)) return true;

    return other.startLoc == startLoc &&
        other.endLoc == endLoc &&
        setEquals(other.polyline, polyline) &&
        other.startMarker == startMarker &&
        other.destinationMarker == destinationMarker &&
        other.distanceInMeters == distanceInMeters &&
        other.durationInSeconds == durationInSeconds;
  }

  @override
  int get hashCode {
    return startLoc.hashCode ^ endLoc.hashCode ^ polyline.hashCode ^ startMarker.hashCode ^ destinationMarker.hashCode ^ distanceInMeters.hashCode ^ durationInSeconds.hashCode;
  }
}
