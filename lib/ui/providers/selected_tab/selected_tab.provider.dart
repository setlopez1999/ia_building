import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_tab.provider.g.dart';

@riverpod
class SelectedTab extends _$SelectedTab {
  @override
  int build() {
    return 0;
  }

  /// Set selected tab
  // ignore: use_setters_to_change_properties
  void value(int value) {
    state = value;
  }
}
