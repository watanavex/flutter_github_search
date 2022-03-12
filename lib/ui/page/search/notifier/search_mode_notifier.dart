import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchModeStateNotifier =
    StateNotifierProvider<SearchModeStateNotifier, bool>(
        (ref) => SearchModeStateNotifier());

class SearchModeStateNotifier extends StateNotifier<bool> {
  SearchModeStateNotifier() : super(false);

  void toggle() => state = !state;
}
