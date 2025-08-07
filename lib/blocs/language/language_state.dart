import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final String currentLanguage;
  final List<String> supportedLanguages;

  const LanguageLoaded({
    required this.currentLanguage,
    required this.supportedLanguages,
  });

  @override
  List<Object?> get props => [currentLanguage, supportedLanguages];
}

class LanguageChanged extends LanguageState {
  final String newLanguage;

  const LanguageChanged(this.newLanguage);

  @override
  List<Object?> get props => [newLanguage];
}
