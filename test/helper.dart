// 📦 Package imports:
import 'package:mockito/mockito.dart';

class Listener<T> extends Mock {
  void call(T? previous, T value);
}
