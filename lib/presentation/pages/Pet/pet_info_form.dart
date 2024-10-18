import 'dart:io';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';

class PetInfoForm extends ConsumerStatefulWidget {
  final int petId;
  final String petCategory;

  PetInfoForm({required this.petId, required this.petCategory});

  @override
  _PetInfoFormState createState() => _PetInfoFormState();
}

class _PetInfoFormState extends ConsumerState<PetInfoForm> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  TextEditingController microchipController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isNeuter = false;
  bool isDogSelected = false;
  bool isCatSelected = false;

  int? selectedPetTypeId;
  int? selectedBehaviorCategoryId;

  File? _image;  // Store the selected image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPetInfo();  // Fetch pet information and set initial state
  }

  // Fetch pet information and pre-fill form
  Future<void> _loadPetInfo() async {
    final petInfoViewModel = ref.read(petInfoProvider(widget.petId).notifier);
    await petInfoViewModel.fetchPetInfo();

    final pet = petInfoViewModel.state.maybeWhen(
      data: (pet) => pet,
      orElse: () => null,
    );

    if (pet != null) {
      setState(() {
        nameController.text = pet.name ?? '';
        sexController.text = pet.sex ?? '';
        weightController.text = pet.weight?.toString() ?? '';
        dobController.text = pet.dob != null ? DateFormat('yyyy-MM-dd').format(pet.dob!) : '';
        allergyController.text = pet.allergy ?? '';
        microchipController.text = pet.microchipNumber ?? '';
        descriptionController.text = pet.description ?? '';
        isNeuter = pet.isNeuter ?? false;
        selectedPetTypeId = pet.petType?.id;
        selectedBehaviorCategoryId = pet.behaviorCategory?.id;

        // Load image from pet model (if available)
        if (pet.image != null && pet.image!.isNotEmpty) {
          _image = File(pet.image!); // Assuming image is a file path (adjust if needed)
        }

        // Automatically select the correct pet category and load types
        if (widget.petCategory == 'Cat') {
          isCatSelected = true;
          _loadPetTypes(2); // Load cat types
        } else if (widget.petCategory == 'Dog') {
          isDogSelected = true;
          _loadPetTypes(1); // Load dog types
        }
      });
    }
  }

  // Load pet types (Cat or Dog)
  Future<void> _loadPetTypes(int categoryId) async {
    final petCategoryViewModel = ref.read(petFormViewModelProvider.notifier);
    await petCategoryViewModel.getPetTypeWithId(categoryId);
    setState(() {}); // Trigger rebuild after loading pet types
  }

  // Load behavior categories
  Future<void> _loadBehaviorCategories() async {
    final behaviorCategoryViewModel = ref.read(petFormViewModelProvider.notifier);
    await behaviorCategoryViewModel.getBehaviorCategory(NoParams());
    setState(() {}); // Trigger rebuild after loading behavior categories
  }

  // Select an image using ImagePicker
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);  // Store the image file
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final petCategoryViewModel = ref.watch(petFormViewModelProvider);
    final petInfoState = ref.watch(petInfoProvider(widget.petId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin thú cưng'),
      ),
      body: petInfoState.when(
        data: (pet) {
          // Ensure pet data is pre-filled after loading
          if (pet != null) {
            selectedPetTypeId = pet.petType?.id;
            selectedBehaviorCategoryId = pet.behaviorCategory?.id;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image picker
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: _image == null
                            ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.camera_alt, size: 50),
                        )
                            : CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_image!),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Checkbox for Dog and Cat selection
                    Text("Bạn muốn thêm?"),
                    Row(
                      children: [
                        Checkbox(
                          value: isDogSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isDogSelected = value ?? false;
                              isCatSelected = !isDogSelected;
                              if (isDogSelected) {
                                _loadPetTypes(1); // Load dog types
                              }
                            });
                          },
                        ),
                        Text("Chó"),
                        Checkbox(
                          value: isCatSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isCatSelected = value ?? false;
                              isDogSelected = !isCatSelected;
                              if (isCatSelected) {
                                _loadPetTypes(2); // Load cat types
                              }
                            });
                          },
                        ),
                        Text("Mèo"),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Dropdown for Pet Type
                    petCategoryViewModel.when(
                      data: (_) {
                        final petTypes = ref.read(petFormViewModelProvider.notifier).petTypes;

                        if (selectedPetTypeId != null &&
                            !petTypes.any((type) => type.id == selectedPetTypeId)) {
                          selectedPetTypeId = null; // Reset if no valid pet type selected
                        }

                        return DropdownButtonFormField<int>(
                          value: selectedPetTypeId,
                          items: petTypes.map<DropdownMenuItem<int>>((type) {
                            return DropdownMenuItem<int>(
                              value: type.id,
                              child: Text(type.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPetTypeId = value;
                            });
                          },
                          decoration: InputDecoration(labelText: "Loại thú cưng"),
                          hint: Text(isCatSelected
                              ? 'Chọn giống mèo'
                              : 'Chọn giống chó'),
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn loại thú cưng';
                            }
                            return null;
                          },
                        );
                      },
                      loading: () => CircularProgressIndicator(),
                      error: (error, _) => Text('Không thể tải loại thú cưng'),
                    ),
                    SizedBox(height: 16),

                    // Dropdown for Behavior Category
                    petCategoryViewModel.when(
                      data: (_) {
                        final behaviorCategories = ref.read(petFormViewModelProvider.notifier).behaviorCategories;

                        if (selectedBehaviorCategoryId != null &&
                            !behaviorCategories.any((category) => category.id == selectedBehaviorCategoryId)) {
                          selectedBehaviorCategoryId = null; // Reset if no valid behavior category
                        }

                        return DropdownButtonFormField<int>(
                          value: selectedBehaviorCategoryId,
                          items: behaviorCategories.map<DropdownMenuItem<int>>((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBehaviorCategoryId = value;
                            });
                          },
                          decoration: InputDecoration(labelText: "Hành vi đặc biệt"),
                          hint: Text('Chọn hành vi đặc biệt'),
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn hành vi đặc biệt';
                            }
                            return null;
                          },
                        );
                      },
                      loading: () => CircularProgressIndicator(),
                      error: (error, _) => Text('Không thể tải hành vi đặc biệt'),
                    ),
                    SizedBox(height: 16),

                    // Pet Name Input
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Tên Pet"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Pet Weight Input
                    TextFormField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: "Cân nặng (kg)"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập cân nặng của pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Date of Birth Input
                    TextFormField(
                      controller: dobController,
                      decoration: InputDecoration(
                        labelText: "Ngày sinh (YYYY-MM-DD)",
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn ngày sinh của pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Allergy Input
                    TextFormField(
                      controller: allergyController,
                      decoration: InputDecoration(labelText: "Dị ứng"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập thông tin dị ứng của pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Microchip Number Input
                    TextFormField(
                      controller: microchipController,
                      decoration: InputDecoration(labelText: "Số chip"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số chip của pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Description Input
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Mô tả"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mô tả cho pet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Is Neutered Checkbox
                    Row(
                      children: [
                        Text("Đã triệt sản: "),
                        Checkbox(
                          value: isNeuter,
                          onChanged: (bool? value) {
                            setState(() {
                              isNeuter = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Prepare pet data to submit
                            final petData = {
                              "allergy": allergyController.text,
                              "sex": sexController.text,
                              "description": descriptionController.text,
                              "name": nameController.text,
                              "behaviorCategoryId": selectedBehaviorCategoryId ?? 0,
                              "isNeuter": isNeuter,
                              "petTypeId": selectedPetTypeId ?? 0,
                              "dob": dobController.text,
                              "weight": double.tryParse(weightController.text) ?? 0,
                              "microchipNumber": microchipController.text,
                              "image": _image?.path,  // Include image path if available
                            };

                            // Call updatePet
                            final updatePetViewModel = ref.read(updatePetViewModelProvider.notifier);
                            updatePetViewModel.updatePet(widget.petId, petData).then((result) {
                              // After updating, pop with a success result
                              Navigator.pop(context, true); // Returning 'true' as success
                            }).catchError((error) {
                              // Handle error (show error message if necessary)
                              print('Update failed: $error');
                            });
                          }
                        },
                        child: Text("Lưu thông tin"),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Có lỗi xảy ra khi tải dữ liệu')),
      ),
    );
  }
}
