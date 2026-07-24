import 'package:cardifly/utils/constants.dart';

/// A dog breed returned by https://dogapi.dog/api/v2/breeds.
///
/// The Dog API follows the JSON:API spec, so each record is nested inside
/// `{ id, type, attributes: { … } }`. [Breed.fromJson] accepts the outer
/// wrapper.
class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.lifeMin,
    required this.lifeMax,
    required this.hypoallergenic,
    required this.maleWeightMin,
    required this.maleWeightMax,
    required this.femaleWeightMin,
    required this.femaleWeightMax,
    this.imageUrl,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    final attrs = (json['attributes'] as Map<String, dynamic>?) ?? const {};
    final life = (attrs['life'] as Map<String, dynamic>?) ?? const {};
    final male = (attrs['male_weight'] as Map<String, dynamic>?) ?? const {};
    final female =
        (attrs['female_weight'] as Map<String, dynamic>?) ?? const {};

    return Breed(
      id: (json['id'] as String?) ?? '',
      name: (attrs['name'] as String?) ?? 'Sans nom',
      description: (attrs['description'] as String?) ?? '',
      lifeMin: _toInt(life['min']),
      lifeMax: _toInt(life['max']),
      hypoallergenic: (attrs['hypoallergenic'] as bool?) ?? false,
      maleWeightMin: _toInt(male['min']),
      maleWeightMax: _toInt(male['max']),
      femaleWeightMin: _toInt(female['min']),
      femaleWeightMax: _toInt(female['max']),
      imageUrl: _toImageUrl(attrs),
    );
  }

  final String id;
  final String name;
  final String description;
  final int lifeMin;
  final int lifeMax;
  final bool hypoallergenic;
  final int maleWeightMin;
  final int maleWeightMax;
  final int femaleWeightMin;
  final int femaleWeightMax;

  /// Remote picture advertised by the API, or `null` when it ships none.
  ///
  /// The Dog API v2 currently returns no picture for `/breeds`, so this is
  /// almost always `null` and the UI falls back on [placeholderAsset].
  final String? imageUrl;

  /// Human-readable "12 – 15 ans".
  String get lifeSpanLabel {
    if (lifeMin == 0 && lifeMax == 0) return 'Espérance inconnue';
    if (lifeMin == lifeMax) return '$lifeMin ans';
    return '$lifeMin – $lifeMax ans';
  }

  /// Human-readable "25 – 30 kg" using the male weight range.
  String get weightLabel {
    if (maleWeightMin == 0 && maleWeightMax == 0) return 'Poids inconnu';
    if (maleWeightMin == maleWeightMax) return '$maleWeightMin kg';
    return '$maleWeightMin – $maleWeightMax kg';
  }

  /// Deterministic character used as an avatar seed (first initial).
  String get initial =>
      name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

  /// `true` when the API gave us a usable remote picture.
  bool get hasRemoteImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Bundled picture used when the API ships no image (or the remote one
  /// fails to load).
  ///
  /// The asset is picked deterministically from the breed's uuid, so the same
  /// breed always shows the same photo across rebuilds and refreshes.
  String get placeholderAsset {
    final seed = (id.isEmpty ? name : id).hashCode.abs();
    return Constants.dogPlaceholders[seed % Constants.dogPlaceholders.length];
  }

  /// Reads the first non-empty picture field the API may expose.
  ///
  /// JSON:API payloads vary between hosts, so we accept a plain string as
  /// well as the `{ url: … }` object shape.
  static String? _toImageUrl(Map<String, dynamic> attrs) {
    const keys = ['image_url', 'imageUrl', 'image', 'photo', 'picture'];
    for (final key in keys) {
      final value = attrs[key];
      final url = switch (value) {
        String s => s,
        Map<String, dynamic> m => (m['url'] ?? m['src']) as String?,
        _ => null,
      };
      if (url != null && url.trim().isNotEmpty) return url.trim();
    }
    return null;
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
