import 'package:fluffypawmobile/data/models/service_model.dart';

class BookingState {
  final int? serviceId;
  final bool isLoading;
  final String? errorMessage;
  final List<ServiceModel> serviceList;

  BookingState({
    this.serviceId,
    this.isLoading = false,
    this.errorMessage,
    this.serviceList = const [],
  });

  // Copy với các thuộc tính được cập nhật để không phải tạo lại từ đầu
  BookingState copyWith({
    int? serviceId,
    bool? isLoading,
    String? errorMessage,
    List<ServiceModel>? serviceList,
  }) {
    return BookingState(
      serviceId: serviceId ?? this.serviceId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      serviceList: serviceList ?? this.serviceList,
    );
  }
}
