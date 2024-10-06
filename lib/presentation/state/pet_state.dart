import 'package:dartz/dartz.dart';
import 'package:fluffypawmobile/core/error/failures.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/domain/usecases/pet_account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Cập nhật PetState (nếu cần)
class PetState {
  final bool isLoading;
  final List<PetModel> pets;
  final String? errorMessage;

  PetState({
    required this.isLoading,
    required this.pets,
    this.errorMessage,
  });

  factory PetState.initial() {
    return PetState(
      isLoading: false,
      pets: [],
      errorMessage: null,
    );
  }

  PetState copyWith({
    bool? isLoading,
    List<PetModel>? pets,
    String? errorMessage,
  }) {
    return PetState(
      isLoading: isLoading ?? this.isLoading,
      pets: pets ?? this.pets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}