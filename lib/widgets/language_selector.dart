import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/language/language_bloc.dart';
import '../blocs/language/language_event.dart';
import '../blocs/language/language_state.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        if (languageState is LanguageLoaded) {
          return PopupMenuButton<String>(
            onSelected: (languageCode) {
              context.read<LanguageBloc>().add(ChangeLanguage(languageCode));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en',
                child: Text(
                  languageState.currentLanguage == 'en'
                      ? '🇺🇸 English'
                      : 'English',
                ),
              ),
              PopupMenuItem(
                value: 'vi',
                child: Text(
                  languageState.currentLanguage == 'vi'
                      ? '🇻🇳 Tiếng Việt'
                      : 'Tiếng Việt',
                ),
              ),
              PopupMenuItem(
                value: 'ms',
                child: Text(
                  languageState.currentLanguage == 'ms'
                      ? '🇲🇾 Bahasa Malaysia'
                      : 'Bahasa Malaysia',
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.language),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
