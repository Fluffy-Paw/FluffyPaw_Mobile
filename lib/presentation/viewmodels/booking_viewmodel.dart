import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/domain/usecases/get_all_store_service_by_service_id.dart';
import 'package:fluffypawmobile/domain/usecases/create_booking.dart';
import 'package:fluffypawmobile/presentation/state/booking_state.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';

class BookingViewModel extends StateNotifier<BookingState> {
  final GetAllStoreServiceByServiceId getAllStoreServiceByServiceId;
  final CreateBooking createBooking;

  BookingViewModel(this.getAllStoreServiceByServiceId, this.createBooking, int serviceId)
      : super(BookingState(serviceId: serviceId, isLoading: false)) {
    _init(serviceId);
  }

  // Phương thức khởi tạo dữ liệu khi ViewModel được tạo
  void _init(int serviceId) async {
    await loadServicesByServiceId(serviceId);
  }

  // Phương thức lấy danh sách dịch vụ theo serviceId
  Future<void> loadServicesByServiceId(int serviceId) async {
    print("Loading services with service ID: $serviceId");

    state = state.copyWith(isLoading: true, errorMessage: null);

    final Either<Failures, List<ServiceModel>> result = await getAllStoreServiceByServiceId(serviceId);

    result.fold(
          (failure) {
        print("Failed to load services: ${failure.message}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load services: ${failure.message}',
        );
      },
          (serviceList) {
        print("Services loaded successfully");
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          serviceList: serviceList,
        );
      },
    );
  }

  // Phương thức tạo booking từ view
  Future<bool> createBookingForUser({
    required List<int> petIds, // Update petId to petIds as List<int>
    required int storeServiceId,
    required String paymentMethod,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final bookingParams = CreateBookingParams(
      petIds: petIds, // Pass the list of pet IDs
      storeServiceId: storeServiceId,
      paymentMethod: paymentMethod,
      description: description,
    );

    final result = await createBooking(bookingParams);

    return result.fold(
          (failure) {
        print("Failed to create booking: ${failure.message}");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to create booking: ${failure.message}',
        );
        return false; // Trả về false khi thất bại
      },
          (_) {
        print("Booking created successfully");
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
        return true; // Trả về true khi thành công
      },
    );
  }


}
