import 'dart:convert';

class ExperienceModel {
  /// Primary identifier (non-negative). Use -1 if unknown.
  final int id;

  /// Human-readable name (non-empty recommended).
  final String name;

  /// Short tagline or subtitle (optional).
  final String? tagline;

  /// Longer description (optional).
  final String? description;

  /// Public image URL (optional).
  final String? imageUrl;

  /// Icon URL (optional).
  final String? iconUrl;

  const ExperienceModel({
    required this.id,
    required this.name,
    this.tagline,
    this.description,
    this.imageUrl,
    this.iconUrl,
  });

  /// Creates a copy with updated fields.
  ExperienceModel copyWith({
    int? id,
    String? name,
    String? tagline,
    String? description,
    String? imageUrl,
    String? iconUrl,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  /// Convert to a plain map with keys matching the input JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
    };
  }

  /// Robust factory from a map. Accepts numbers-as-strings and tolerates missing keys.
  factory ExperienceModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const ExperienceModel(id: -1, name: '');
    }

    int parseInt(dynamic v) {
      if (v == null) return -1;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) {
        final cleaned = v.trim();
        if (cleaned.isEmpty) return -1;
        return int.tryParse(cleaned) ?? (double.tryParse(cleaned)?.toInt() ?? -1);
      }
      return -1;
    }

    String? parseString(dynamic v) {
      if (v == null) return null;
      if (v is String) {
        final s = v.trim();
        return s.isEmpty ? null : s;
      }
      return v.toString();
    }

    final parsedId = parseInt(map['id']);
    final parsedName = parseString(map['name']) ?? '';
    final parsedTagline = parseString(map['tagline']);
    final parsedDescription = parseString(map['description']);
    final parsedImage = parseString(map['image_url']) ?? parseString(map['imageUrl']);
    final parsedIcon = parseString(map['icon_url']) ?? parseString(map['iconUrl']);

    return ExperienceModel(
      id: parsedId,
      name: parsedName,
      tagline: parsedTagline,
      description: parsedDescription,
      imageUrl: parsedImage,
      iconUrl: parsedIcon,
    );
  }

  /// JSON -> ExperienceModel
  factory ExperienceModel.fromJson(String source) =>
      ExperienceModel.fromMap(json.decode(source) as Map<String, dynamic>?);

  /// Map -> JSON
  String toJson() => json.encode(toMap());

  /// Basic validations. Returns list of human-friendly error messages.
  /// Use `isValid` for quick boolean check.
  List<String> validate({bool checkUrls = false}) {
    final errors = <String>[];
    if (id < 0) errors.add('id must be a non-negative integer.');
    if (name.trim().isEmpty) errors.add('name must not be empty.');
    if (checkUrls) {
      final urlPattern = RegExp(r'^(https?:\/\/)?[^\s\/$.?#].[^\s]*$', caseSensitive: false);
      if (imageUrl != null && imageUrl!.isNotEmpty && !urlPattern.hasMatch(imageUrl!)) {
        errors.add('image_url is not a valid URL.');
      }
      if (iconUrl != null && iconUrl!.isNotEmpty && !urlPattern.hasMatch(iconUrl!)) {
        errors.add('icon_url is not a valid URL.');
      }
    }
    return errors;
  }

  bool get isValid => validate().isEmpty;

  @override
  String toString() {
    return 'ExperienceModel(id: $id, name: $name, tagline: ${tagline ?? "null"}, '
        'description: ${description != null ? (description!.length > 60 ? "${description!.substring(0, 60)}..." : description) : "null"}, '
        'imageUrl: ${imageUrl ?? "null"}, iconUrl: ${iconUrl ?? "null"})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExperienceModel &&
        other.id == id &&
        other.name == name &&
        other.tagline == tagline &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.iconUrl == iconUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    (tagline?.hashCode ?? 0) ^
    (description?.hashCode ?? 0) ^
    (imageUrl?.hashCode ?? 0) ^
    (iconUrl?.hashCode ?? 0);
  }
}
