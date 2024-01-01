import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifer, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(RestaurantRepositoryProvider);

    final notifier = RestaurantStateNotifer(repository: repository);

    return notifier;
  },
);

class RestaurantStateNotifer extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifer({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  paginate() async {
    final resp = await repository.paginate();

    state = resp;
  }
}
