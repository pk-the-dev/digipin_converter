// lib/digipin_converter.dart

/// A Dart package for converting between geographical coordinates (latitude, longitude)
/// and India Post's DIGIPINs.
///
/// This package provides functions to:
/// - Encode latitude and longitude into a DIGIPIN.
/// - Decode a DIGIPIN back into its corresponding latitude and longitude.
library digipin_converter;

// DIGIPIN Encoder and Decoder Library
// Developed by India Post, Department of Posts
// Released under an open-source license for public use

// The DIGIPIN grid characters
const List<List<String>> digipinGrid = [
  ['F', 'C', '9', '8'],
  ['J', '3', '2', '7'],
  ['K', '4', '5', '6'],
  ['L', 'M', 'P', 'T'],
];

// The geographical bounds for DIGIPIN generation in India
const Map<String, double> bounds = {
  'minLat': 2.5,
  'maxLat': 38.5,
  'minLon': 63.5,
  'maxLon': 99.5,
};

/// Converts geographical coordinates (latitude, longitude) to a DIGIPIN.
///
/// This function implements the precise DIGIPIN encoding algorithm
/// based on India Post's specifications.
///
/// Parameters:
/// - `latitude`: The latitude of the location.
/// - `longitude`: The longitude of the location.
///
/// Returns:
/// A `Future<String?>` representing the generated DIGIPIN, or `null` if conversion fails
/// (e.g., coordinates out of bounds).
Future<String?> coordinatesToDigipin(double latitude, double longitude) async {
  await Future.delayed(Duration(milliseconds: 10));

  if (latitude < bounds['minLat']! || latitude > bounds['maxLat']!) {
    throw ArgumentError(
      'Latitude out of range: $latitude. Must be between ${bounds['minLat']} and ${bounds['maxLat']}.',
    );
  }
  if (longitude < bounds['minLon']! || longitude > bounds['maxLon']!) {
    throw ArgumentError(
      'Longitude out of range: $longitude. Must be between ${bounds['minLon']} and ${bounds['maxLon']}.',
    );
  }

  double minLat = bounds['minLat']!;
  double maxLat = bounds['maxLat']!;
  double minLon = bounds['minLon']!;
  double maxLon = bounds['maxLon']!;

  String digiPin = '';

  for (int level = 1; level <= 10; level++) {
    final latDiv = (maxLat - minLat) / 4;
    final lonDiv = (maxLon - minLon) / 4;

    // REVERSED row logic (to match original JS)
    int row = 3 - ((latitude - minLat) / latDiv).floor();
    int col = ((longitude - minLon) / lonDiv).floor();

    row = row.clamp(0, 3); // Ensure row is within [0, 3]
    col = col.clamp(0, 3); // Ensure col is within [0, 3]

    digiPin += digipinGrid[row][col];

    if (level == 3 || level == 6) {
      digiPin += '-';
    }

    // Update bounds (reverse logic for row)
    maxLat = minLat + latDiv * (4 - row);
    minLat = minLat + latDiv * (3 - row);

    minLon = minLon + lonDiv * col;
    maxLon = minLon + lonDiv; // CORRECTED: Match JavaScript exactly
  }

  return digiPin;
}

/// Decodes a DIGIPIN into its corresponding geographical coordinates (latitude, longitude).
///
/// This function implements the precise DIGIPIN decoding algorithm
/// based on India Post's specifications.
///
/// Parameters:
/// - `digipin`: The 10-character alphanumeric DIGIPIN.
///
/// Returns:
/// A `Future<Map<String, double>?>` containing 'latitude' and 'longitude',
/// or `null` if decoding fails or the DIGIPIN is invalid.
Future<Map<String, double>?> digipinToCoordinates(String digipin) async {
  // Simulate asynchronous operation
  await Future.delayed(Duration(milliseconds: 10));

  final pin = digipin.replaceAll('-', '');
  if (pin.length != 10) {
    throw ArgumentError(
      'Invalid DIGIPIN format. Must be 10 alphanumeric characters (excluding hyphens).',
    );
  }

  double minLat = bounds['minLat']!;
  double maxLat = bounds['maxLat']!;
  double minLon = bounds['minLon']!;
  double maxLon = bounds['maxLon']!;

  for (int i = 0; i < 10; i++) {
    final char = pin[i];
    bool found = false;
    int ri = -1;
    int ci = -1;

    // Locate character in DIGIPIN grid
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (digipinGrid[r][c] == char) {
          ri = r;
          ci = c;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    if (!found) {
      throw ArgumentError('Invalid character "$char" found in DIGIPIN.');
    }

    final latDiv = (maxLat - minLat) / 4;
    final lonDiv = (maxLon - minLon) / 4;

    // CORRECTED: Match the JavaScript logic exactly
    final lat1 = maxLat - latDiv * (ri + 1);
    final lat2 = maxLat - latDiv * ri;
    final lon1 = minLon + lonDiv * ci;
    final lon2 = minLon + lonDiv * (ci + 1);

    // Update bounding box for next level
    minLat = lat1;
    maxLat = lat2;
    minLon = lon1;
    maxLon = lon2;
  }

  final centerLat = (minLat + maxLat) / 2;
  final centerLon = (minLon + maxLon) / 2;

  // Return coordinates with a fixed precision for consistency
  return {
    'latitude': double.parse(centerLat.toStringAsFixed(6)),
    'longitude': double.parse(centerLon.toStringAsFixed(6)),
  };
}
