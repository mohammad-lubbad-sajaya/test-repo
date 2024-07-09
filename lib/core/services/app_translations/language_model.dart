class LanguageModel {
  final String? language;
  final String languageCode;

  LanguageModel({this.language, required this.languageCode});

  @override
  bool operator ==(other) {
    return (other is LanguageModel) && other.languageCode == languageCode;
  }

  @override
  int get hashCode => languageCode.hashCode + language.hashCode;
}
