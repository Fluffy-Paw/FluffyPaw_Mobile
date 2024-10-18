import 'package:fluffypawmobile/data/models/vaccine_model.dart';

class PetInfoState {
  final int? petId;
  final bool isLoading;
  final String? errorMessage;
  final String petCategory;
  final String behaviorCategory;
  final String petTypeName;
  final String name;
  final String? image;
  final String sex;
  final double weight;
  final DateTime dob;
  final String allergy;
  final String microchipNumber;
  final String description;
  final bool isNeuter;
  final List<VaccineModel>? vaccineList;
  final VaccineModel? selectedVaccine;

  PetInfoState({
    required this.isLoading,
    this.errorMessage,
    this.petId,
    required this.petCategory,
    required this.behaviorCategory,
    required this.petTypeName,
    required this.name,
    required this.image,
    required this.sex,
    required this.weight,
    required this.dob,
    required this.allergy,
    required this.microchipNumber,
    required this.description,
    required this.isNeuter,
    this.vaccineList,
    this.selectedVaccine
  });

  factory PetInfoState.initial() {
    return PetInfoState(
      isLoading: false,
      errorMessage: null,
      petCategory: '',
      behaviorCategory: '',
      petTypeName: '',
      name: '',
      image: 'https://logowik.com/content/uploads/images/cat8600.jpg',
      sex: '',
      weight: 0.0,
      dob: DateTime.now(),
      allergy: '',
      microchipNumber: '',
      description: '',
      isNeuter: false,
      vaccineList: [],
      selectedVaccine: null,
      petId: 0
    );
  }

  PetInfoState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? petCategory,
    String? behaviorCategory,
    String? petTypeName,
    String? name,
    String? image,
    String? sex,
    double? weight,
    DateTime? dob,
    String? allergy,
    String? microchipNumber,
    String? description,
    bool? isNeuter,
    List<VaccineModel>? vaccineList,
    VaccineModel? selectedVaccine,
    int? petId
  }) {
    return PetInfoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      petCategory: petCategory ?? this.petCategory,
      behaviorCategory: behaviorCategory ?? this.behaviorCategory,
      petTypeName: petTypeName ?? this.petTypeName,
      name: name ?? this.name,
      image: image ?? this.image,
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
      dob: dob ?? this.dob,
      allergy: allergy ?? this.allergy,
      microchipNumber: microchipNumber ?? this.microchipNumber,
      description: description ?? this.description,
      isNeuter: isNeuter ?? this.isNeuter,
      vaccineList: vaccineList ?? this.vaccineList,
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      petId: petId ?? this.petId
    );
  }
}
