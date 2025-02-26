enum TextFormat {
  NORMAL,
  LIGHT,
}

// Extensión para obtener el valor en texto
extension TextFormatExtension on TextFormat {
  String get asString {
    switch (this) {
      case TextFormat.NORMAL:
        return "NORMAL";
      case TextFormat.LIGHT:
        return "LIGHT";
      }
  }

  static TextFormat fromString(String value) {
    switch (value) {
      case "NORMAL":
        return TextFormat.NORMAL;
      case "LIGHT":
        return TextFormat.LIGHT;
      default:
        return TextFormat.LIGHT; // Valor por defecto
    }
  }
}