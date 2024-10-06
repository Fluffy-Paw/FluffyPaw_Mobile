import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/core/usecases/usecase.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// PetForm Widget Implementation
class PetForm extends ConsumerStatefulWidget {
  final PetModel? petData; // Optional parameter to handle editing

  PetForm({this.petData});
  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends ConsumerState<PetForm> {
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
  File? _image;

  bool isDogSelected = false;
  bool isCatSelected = false;

  int? selectedPetTypeId;
  int? selectedBehaviorCategoryId;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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

  Future<void> _loadPetTypes(int id) async {
    final petCategoryViewModel = ref.read(petFormViewModelProvider.notifier);
    await petCategoryViewModel.getPetTypeWithId(id);
  }

  Future<void> _loadBehaviorCategories() async {
    final petCategoryViewModel = ref.read(petFormViewModelProvider.notifier);
    await petCategoryViewModel.getBehaviorCategory(NoParams());
  }

  @override
  Widget build(BuildContext context) {
    final petCategoryViewModel = ref.watch(petFormViewModelProvider);
    final addPetViewModel = ref.read(addPetViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Form"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker for pet image
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _image == null
                        ? CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.add_a_photo, size: 50),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_image!),
                          ),
                  ),
                ),
                SizedBox(height: 20),

                // Checkbox for Dog and Cat selection
                Text("Bạn muốn thêm?"),
                Row(
                  children: [
                    Checkbox(
                      value: isDogSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isDogSelected = value ?? false;
                          isCatSelected = false;
                          if (isDogSelected) {
                            _loadPetTypes(1);
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
                          isDogSelected = false;
                          if (isCatSelected) {
                            _loadPetTypes(2);
                          }
                        });
                      },
                    ),
                    Text("Mèo"),
                  ],
                ),
                SizedBox(height: 10),

                // Dropdown for Pet Type
                if (isDogSelected || isCatSelected)
                  petCategoryViewModel.when(
                    data: (_) {
                      final petTypes =
                          ref.read(petFormViewModelProvider.notifier).petTypes;

                      // Đảm bảo giá trị được chọn hợp lệ
                      if (selectedPetTypeId != null &&
                          petTypes
                              .every((type) => type.id != selectedPetTypeId)) {
                        selectedPetTypeId = null;
                      }

                      return DropdownButtonFormField<int>(
                        value: selectedPetTypeId,
                        items:
                            petTypes.toSet().map<DropdownMenuItem<int>>((type) {
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
                        decoration: InputDecoration(labelText: "Pet Type"),
                        hint: Text(petTypes.isEmpty
                            ? "No pet types available"
                            : "Select a pet type"),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a pet type';
                          }
                          return null;
                        },
                      );
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, _) => Text("Failed to load pet types"),
                  ),

                SizedBox(height: 10),

                // Dropdown for Behavior Category
                // Dropdown for Behavior Category
                petCategoryViewModel.when(
                  data: (_) {
                    final behaviorCategories = ref
                        .read(petFormViewModelProvider.notifier)
                        .behaviorCategories;

                    // Đảm bảo giá trị được chọn phải khớp với một trong các giá trị trong dropdown
                    if (selectedBehaviorCategoryId != null &&
                        behaviorCategories.every((category) =>
                            category.id != selectedBehaviorCategoryId)) {
                      selectedBehaviorCategoryId =
                          null; // Nếu không tìm thấy giá trị hợp lệ, đặt về null
                    }

                    return DropdownButtonFormField<int>(
                      value: selectedBehaviorCategoryId,
                      items: behaviorCategories
                          .map<DropdownMenuItem<int>>((category) {
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
                      decoration:
                          InputDecoration(labelText: "Behavior Category"),
                      hint: Text(behaviorCategories.isEmpty
                          ? "No behavior categories available"
                          : "Select a behavior category"),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a behavior category';
                        }
                        return null;
                      },
                    );
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, _) =>
                      Text("Failed to load behavior categories"),
                ),

                SizedBox(height: 10),

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
                SizedBox(height: 10),

                // Pet Sex Input
                TextFormField(
                  controller: sexController,
                  decoration: InputDecoration(labelText: "Giới tính"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giới tính của pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Weight Input
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
                SizedBox(height: 10),

                // Date of Birth Input (DateTimePicker)
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
                SizedBox(height: 10),

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
                SizedBox(height: 10),

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
                SizedBox(height: 10),

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
                SizedBox(height: 10),

                // Is Neutered Checkbox
                Row(
                  children: [
                    Text("Đã triệt sản: "),
                    Checkbox(
                      value: isNeuter,
                      onChanged: (bool? value) {
                        setState(() {
                          isNeuter = value!;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final petData = {
                          "image": _image != null ? _image!.path : "",
                          "petTypeId": selectedPetTypeId ?? 0,
                          "behaviorCategoryId": selectedBehaviorCategoryId ?? 0,
                          "name": nameController.text.isNotEmpty
                              ? nameController.text
                              : "",
                          "sex": sexController.text.isNotEmpty
                              ? sexController.text
                              : "",
                          "weight": double.tryParse(weightController.text) ?? 0,
                          "dob": dobController.text.isNotEmpty
                              ? dobController.text
                              : "",
                          "allergy": allergyController.text.isNotEmpty
                              ? allergyController.text
                              : "",
                          "microchipNumber": microchipController.text.isNotEmpty
                              ? microchipController.text
                              : "",
                          "description": descriptionController.text.isNotEmpty
                              ? descriptionController.text
                              : "",
                          "isNeuter": isNeuter,
                        };

                        addPetViewModel.submitForm(petData).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Pet added successfully!')));
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => Home()),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error adding pet: $error')));
                        });
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
