import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_locator/blocs/language/language_bloc.dart';
import 'package:geofence_locator/blocs/language/language_event.dart';
import 'package:geofence_locator/blocs/language/language_state.dart';

void main() {
  group('LanguageBloc', () {
    late LanguageBloc languageBloc;

    setUp(() {
      languageBloc = LanguageBloc();
    });

    tearDown(() {
      languageBloc.close();
    });

    test('initial state should be LanguageInitial', () {
      expect(languageBloc.state, isA<LanguageInitial>());
    });

    test('should emit LanguageLoaded when LoadLanguage is added', () async {
      final expectedStates = [isA<LanguageInitial>(), isA<LanguageLoaded>()];

      expectLater(languageBloc.stream, emitsInOrder(expectedStates));

      languageBloc.add(const LoadLanguage());
    });

    test('should emit LanguageChanged when ChangeLanguage is added', () async {
      // First load language
      languageBloc.add(const LoadLanguage());
      await Future.delayed(const Duration(milliseconds: 100));

      final expectedStates = [isA<LanguageLoaded>(), isA<LanguageChanged>()];

      expectLater(languageBloc.stream, emitsInOrder(expectedStates));

      languageBloc.add(const ChangeLanguage('vi'));
    });

    test('should change language to Vietnamese', () async {
      languageBloc.add(const LoadLanguage());
      await Future.delayed(const Duration(milliseconds: 100));

      languageBloc.add(const ChangeLanguage('vi'));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = languageBloc.state;
      expect(state, isA<LanguageChanged>());
      if (state is LanguageChanged) {
        expect(state.newLanguage, equals('vi'));
      }
    });

    test('should change language to Malaysian', () async {
      languageBloc.add(const LoadLanguage());
      await Future.delayed(const Duration(milliseconds: 100));

      languageBloc.add(const ChangeLanguage('ms'));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = languageBloc.state;
      expect(state, isA<LanguageChanged>());
      if (state is LanguageChanged) {
        expect(state.newLanguage, equals('ms'));
      }
    });

    test('should persist language changes', () async {
      languageBloc.add(const LoadLanguage());
      await Future.delayed(const Duration(milliseconds: 100));

      languageBloc.add(const ChangeLanguage('vi'));
      await Future.delayed(const Duration(milliseconds: 100));

      // Create new bloc instance to test persistence
      final newLanguageBloc = LanguageBloc();
      newLanguageBloc.add(const LoadLanguage());
      await Future.delayed(const Duration(milliseconds: 100));

      final state = newLanguageBloc.state;
      expect(state, isA<LanguageLoaded>());
      if (state is LanguageLoaded) {
        expect(state.currentLanguage, equals('vi'));
      }

      await newLanguageBloc.close();
    });
  });
}
