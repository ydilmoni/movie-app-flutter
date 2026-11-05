import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends Notifier<String> {
  @override
  String build() => 'he-IL';

  void toggleLanguage() {
    state = state == 'he-IL' ? 'en-US' : 'he-IL';
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);