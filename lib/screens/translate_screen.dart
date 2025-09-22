import 'package:flutter/material.dart';
import '../widgets/navigator.dart';
import '../widgets/screen_title.dart';
import '../services/translate_service.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _src = TextEditingController();
  final TextEditingController _dst = TextEditingController();
  final TranslateService _translateService = TranslateService();

  //언어 => TODO: 나중에 한번에 관리!
  final Map<String, String> languageMap = {
    'auto': 'auto',
    'en': 'english',
    'ko': 'korean', 
    'ja': 'japanese',
    'zh-CN': 'chinese',
  };
  
  final List<String> fromOptions = ['auto', 'en', 'ko', 'ja', 'zh-CN'];
  final List<String> toOptions = ['en', 'ko', 'ja', 'zh-CN'];

  String fromLang = 'auto';
  String toLang = 'en';
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ScreenTitle('Translator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              //from 입력칸칸
              _RoundedCard(
                child: TextField(
                  controller: _src,
                  maxLines: 5,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter text here',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              //언어 선택 toggle
              _LanguageBar(
                fromOptions: fromOptions,
                toOptions: toOptions,
                fromValue: fromLang,
                toValue: toLang,
                languageMap: languageMap,
                onChangedFrom: (v) => setState(() => fromLang = v),
                onChangedTo: (v) => setState(() => toLang = v),
                onSwap: () {
                  setState(() {
                    if (fromLang != 'auto') {
                      final temp = fromLang;
                      fromLang = toLang;
                      toLang = temp;
                    }
                  });
                },
              ),
              const SizedBox(height: 14),

              //to 출력칸
              Expanded(
                child: _RoundedCard(
                  child: TextField(
                    controller: _dst,
                    readOnly: true,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //번역 버튼 -> 좀 구린가? TODO:디자인 개선
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _translateText,
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Translate'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  ///번역 실행행
  Future<void> _translateText() async {
    if (_src.text.trim().isEmpty) {
      setState(() {
        _dst.text = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _dst.text = '';
    });

    try {
      final translatedText = await _translateService.translate(
        sourceText: _src.text.trim(),
        sourceLang: fromLang,
        targetLang: toLang,
      );

      setState(() {
        _dst.text = translatedText;
      });
    } catch (e) {
      setState(() {
        _dst.text = 'Translation error: ${e.toString().replaceFirst('Exception: ', '')}';
      });
      
      //에러 메시지 -> 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

////////////////////////위젯
class _RoundedCard extends StatelessWidget {
  final Widget child;

  const _RoundedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: child,
    );
  }
}

class _LanguageBar extends StatelessWidget {
  final List<String> fromOptions;
  final List<String> toOptions;
  final String fromValue;
  final String toValue;
  final Map<String, String> languageMap;
  final ValueChanged<String> onChangedFrom;
  final ValueChanged<String> onChangedTo;
  final VoidCallback onSwap;

  const _LanguageBar({
    required this.fromOptions,
    required this.toOptions,
    required this.fromValue,
    required this.toValue,
    required this.languageMap,
    required this.onChangedFrom,
    required this.onChangedTo,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSecondary;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: _LangDropdown(
              value: fromValue,
              items: fromOptions,
              languageMap: languageMap,
              textColor: textColor,
              onChanged: onChangedFrom,
            ),
          ),
          IconButton(
            onPressed: onSwap,
            icon: Icon(Icons.swap_horiz, color: textColor),
          ),
          Expanded(
            child: _LangDropdown(
              value: toValue,
              items: toOptions,
              languageMap: languageMap,
              textColor: textColor,
              onChanged: onChangedTo,
            ),
          ),
        ],
      ),
    );
  }
}

class _LangDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Map<String, String> languageMap;
  final Color textColor;
  final ValueChanged<String> onChanged;

  const _LangDropdown({
    required this.value,
    required this.items,
    required this.languageMap,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    languageMap[e] ?? e,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
