import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled1/model/shopping_item_model.dart';
import 'package:untitled1/riverpod/state_notifier_provider.dart';

final filteredShoppingListProvider = Provider<List<ShoppingItemModel>>((ref) {
  final filterState = ref.watch(filterProvider);
  final shoppingListState = ref.watch(shoppingListProvider);

  if (filterState == FilterState.all) {
    return shoppingListState;
  }

  return shoppingListState
      .where((element) =>
          filterState == FilterState.spicy ? element.isSpicy : !element.isSpicy)
      .toList();
});

enum FilterState {
  notSpicy,
  spicy,
  all,
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState.all);
