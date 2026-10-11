class LetterNormalizer {
  static final _letterPattern = RegExp(r'^[A-Z]$');

  static const _accentGroups = {
    'A': 'ÁÀÂÃÄ',
    'E': 'ÉÈÊË',
    'I': 'ÍÌÎÏ',
    'O': 'ÓÒÔÕÖ',
    'U': 'ÚÙÛÜ',
    'C': 'Ç',
  };

  static String normalize(String value) {
    var normalized = value.toUpperCase();

    for (final entry in _accentGroups.entries) {
      for (final accent in entry.value.split('')) {
        normalized = normalized.replaceAll(accent, entry.key);
      }
    }

    return normalized;
  }

  static bool isLetter(String value) {
    return _letterPattern.hasMatch(normalize(value));
  }
}
