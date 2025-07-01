// test/digipin_converter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:digipin_converter/digipin_converter.dart'; // Adjust import based on your package structure

void main() {
  group('DIGIPIN Conversion Tests', () {
    // Test cases based on hypothetical examples that fit the algorithm's logic
    // NOTE: For real-world accuracy, these values should come from official
    // DIGIPIN examples or a known working implementation.

    const double testLat = 13.080680;
    const double testLon = 80.287555;
    const String digipin = '4T3-8M9-FK7L';

    group('error handling', () {
      test(
        'should throw ArgumentError for latitude out of lower bound',
        () async {
          expect(
            () async => await coordinatesToDigipin(
              bounds['minLat']! - 0.001,
              bounds['minLon']!,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Latitude out of range'),
              ),
            ),
          );
        },
      );

      test(
        'should throw ArgumentError for latitude out of upper bound',
        () async {
          expect(
            () async => await coordinatesToDigipin(
              bounds['maxLat']! + 0.001,
              bounds['minLon']!,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Latitude out of range'),
              ),
            ),
          );
        },
      );

      test(
        'should throw ArgumentError for longitude out of lower bound',
        () async {
          expect(
            () async => await coordinatesToDigipin(
              bounds['minLat']!,
              bounds['minLon']! - 0.001,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Longitude out of range'),
              ),
            ),
          );
        },
      );

      test(
        'should throw ArgumentError for longitude out of upper bound',
        () async {
          expect(
            () async => await coordinatesToDigipin(
              bounds['minLat']!,
              bounds['maxLon']! + 0.001,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Longitude out of range'),
              ),
            ),
          );
        },
      );

      test('should throw ArgumentError for invalid DIGIPIN length', () async {
        expect(
          () async => await digipinToCoordinates('ABC-DEF'), // Too short
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Invalid DIGIPIN format'),
            ),
          ),
        );
        expect(
          () async =>
              await digipinToCoordinates('ABC-DEF-GHIJ-KLM'), // Too long
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Invalid DIGIPIN format'),
            ),
          ),
        );
      });

      test(
        'should throw ArgumentError for invalid character in DIGIPIN',
        () async {
          expect(
            () async => await digipinToCoordinates(
              'A12-345-678Z',
            ), // 'Z' is not in DIGIPIN_GRID
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Invalid character'),
              ),
            ),
          );
        },
      );
    });

    group('coordinatesToDigipin', () {
      test(
        'should correctly encode coordinates to DIGIPIN (Example 1)',
        () async {
          final generatedDigipin = await coordinatesToDigipin(testLat, testLon);
          expect(generatedDigipin, isA<String>());
          expect(generatedDigipin!.length, equals(12)); // 10 chars + 2 hyphens
          expect(generatedDigipin, equals(digipin));
        },
      );
    });

    group('digipinToCoordinates', () {
      test(
        'should correctly decode DIGIPIN to coordinates (Example 1)',
        () async {
          final coords = await digipinToCoordinates(digipin);
          expect(coords, isNotNull);
          // Due to floating point precision, use closeTo matcher or compare fixed values
          expect(coords!['latitude']!, closeTo(testLat, 0.0001));
          expect(coords['longitude']!, closeTo(testLon, 0.0001));
        },
      );

      test('should handle DIGIPIN with missing hyphens', () async {
        final digipinWithoutHyphens = 'K9JK72TL5C'; // 10 characters
        final coords = await digipinToCoordinates(digipinWithoutHyphens);
        expect(coords, isNotNull);
        expect(coords!['latitude'], isA<double>());
        expect(coords['longitude'], isA<double>());
      });
    });

    test('should convert and de-convert', () async {
      final coords = await digipinToCoordinates(digipin);
      final convertedDigiPin = await coordinatesToDigipin(
        coords!['latitude']!,
        coords['longitude']!,
      );
      expect(convertedDigiPin, isNotNull);
      expect(convertedDigiPin, digipin);
    });
  });
}
