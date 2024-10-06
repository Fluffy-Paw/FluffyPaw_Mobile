class PetInfoState {
  final bool isLoading;
  final String? errorMessage;
  final String petCategory;
  final String behaviorCategory;
  final String petTypeName;
  final String name;
  final String image;
  final String sex;
  final double weight;
  final DateTime dob;
  final String allergy;
  final String microchipNumber;
  final String description;
  final bool isNeuter;

  PetInfoState({
    required this.isLoading,
    this.errorMessage,
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
  });

  factory PetInfoState.initial() {
    return PetInfoState(
      isLoading: false,
      errorMessage: null,
      petCategory: '',
      behaviorCategory: '',
      petTypeName: '',
      name: '',
      image: '',
      sex: '',
      weight: 0.0,
      dob: DateTime.now(),
      allergy: '',
      microchipNumber: '',
      description: '',
      isNeuter: false,
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
    );
  }
}
