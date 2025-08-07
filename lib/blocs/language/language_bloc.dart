import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguage = 'en';

  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentLanguage = prefs.getString(_languageKey) ?? _defaultLanguage;

      emit(
        LanguageLoaded(
          currentLanguage: currentLanguage,
          supportedLanguages: ['en', 'vi'],
        ),
      );
    } catch (e) {
      emit(
        LanguageLoaded(
          currentLanguage: _defaultLanguage,
          supportedLanguages: ['en', 'vi'],
        ),
      );
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, event.languageCode);

      emit(LanguageChanged(event.languageCode));

      // Reload language state
      emit(
        LanguageLoaded(
          currentLanguage: event.languageCode,
          supportedLanguages: ['en', 'vi'],
        ),
      );
    } catch (e) {
      // Handle error silently
    }
  }
}
