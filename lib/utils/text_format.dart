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
}