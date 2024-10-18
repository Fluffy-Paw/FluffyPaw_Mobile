import 'package:fluffypawmobile/data/models/store_model.dart';
import 'package:fluffypawmobile/data/models/store_service_model.dart';

class StoreDetailState {
  final int? storeId;
  final bool isLoading;
  final String? errorMessage;
  final StoreModel storeModel;
  final List<StoreServiceModel> storeServiceList;

  StoreDetailState({
    required this.isLoading,
    this.errorMessage,
    this.storeId,
    required this.storeModel,
    required this.storeServiceList,
  });

  factory StoreDetailState.initial() {
    return StoreDetailState(
      isLoading: false,
      errorMessage: null,
      storeId: 0,
      storeModel: StoreModel.initial(),
      storeServiceList: [],
    );
  }

  StoreDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? storeId,
    StoreModel? storeModel,
    List<StoreServiceModel>? storeServiceList,
  }) {
    return StoreDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      storeId: storeId ?? this.storeId,
      storeModel: storeModel ?? this.storeModel,
      storeServiceList: storeServiceList ?? this.storeServiceList,
    );
  }
}
