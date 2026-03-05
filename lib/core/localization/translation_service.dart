import 'package:get/get.dart';
import 'en_US.dart';
import 'it_it.dart';


class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'it_IT': itIT,
  };
}
