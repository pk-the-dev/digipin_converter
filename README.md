# `digipin_converter`

A Dart package for converting between geographical coordinates (latitude, longitude) and India Post's DIGIPINs.

## Overview

This package provides a pure Dart implementation of the DIGIPIN encoding and decoding algorithm, as specified by the Department of Posts, Government of India. It allows developers to:

* **Encode:** Convert a given latitude and longitude into its unique 10-character alphanumeric DIGIPIN.

* **Decode:** Convert a DIGIPIN back into its central latitude and longitude coordinates.

The DIGIPIN system is designed to provide precise location identification within India, dividing the country into approximately 4m x 4m grids, each assigned a unique code.

## Installation

Add `digipin_converter` to your `pubspec.yaml` file:

```yaml
dependencies:
  digipin_converter: ^0.1.0 # Use the latest version
```

Then, run `flutter pub get` or `dart pub get` to fetch the package

## Usage

### Encoding Coordinates to DIGIPIN

To convert latitude and longitude to a DIGIPIN:

```dart
import 'package:digipin_converter/digipin_converter.dart';

void main() async {
  // Example: Coordinates for a location in Chennai
  const double latitude = 13.0827;
  const double longitude = 80.2707;

  try {
    final String? digipin = await coordinatesToDigipin(latitude, longitude);
    if (digipin != null) {
      print('Coordinates ($latitude, $longitude) encoded to DIGIPIN: $digipin');
    } else {
      print('Failed to encode coordinates to DIGIPIN.');
    }
  } catch (e) {
    print('Error encoding coordinates: $e');
  }
}
```

### Decoding DIGIPIN to Coordinates

To convert a DIGIPIN back to its central latitude and longitude:

import 'package:digipin_converter/digipin_converter.dart';

```dart
void main() async {
  // Example: A hypothetical DIGIPIN
  const String digipinCode = 'K9J-K2T-L5C'; // Replace with an actual DIGIPIN

  try {
    final Map<String, double>? coordinates = await digipinToCoordinates(digipinCode);
    if (coordinates != null) {
      print('DIGIPIN "$digipinCode" decoded to:');
      print('  Latitude: ${coordinates['latitude']}');
      print('  Longitude: ${coordinates['longitude']}');
    } else {
      print('Failed to decode DIGIPIN "$digipinCode".');
    }
  } catch (e) {
    print('Error decoding DIGIPIN: $e');
  }
}
```

## Important Notes on Accuracy

The accuracy of the DIGIPIN conversion relies heavily on the precise implementation of the algorithm as defined by India Post. While this package aims to faithfully reproduce that logic, it is crucial to:

- Verify with Official Examples: Test the package extensively with official DIGIPIN examples and their corresponding coordinates provided by India Post to ensure the accuracy of the coordinatesToDigipin and digipinToCoordinates functions.

- Floating Point Precision: Be aware of floating-point arithmetic limitations when comparing double values. Use appropriate precision comparisons in your application logic.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the GitHub repository (if publicly available).

## License

This package is released under the [MIT License](https://opensource.org/licenses/MIT).
