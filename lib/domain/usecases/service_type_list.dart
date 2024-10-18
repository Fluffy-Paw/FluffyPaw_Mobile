import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/service_type_model.dart';
import 'package:fluffypawmobile/domain/repositories/service_repository.dart';

class ServiceTypeList implements UseCase<List<ServiceTypeModel>, NoParams>{
  final ServiceRepository serviceRepository;

  ServiceTypeList(this.serviceRepository);
  @override
  Future<Either<Failures, List<ServiceTypeModel>>> call(NoParams params) async {
    final result = await serviceRepository.getServiceTypeList(); // Await the Future
    return result.fold(
          (failure) => Left(failure),
          (apiResponse) => Right(apiResponse.data!),
    );
  }

}