double calculateEconomyPrice(double distanceInMeters) {
  double initPrice = 50.0;
  double pricePerKm = 20.0;
  return initPrice + (pricePerKm * (distanceInMeters / 1000));
}
