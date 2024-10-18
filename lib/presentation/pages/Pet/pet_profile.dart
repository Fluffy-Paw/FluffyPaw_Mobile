import 'dart:io';


import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';

import 'package:fluffypawmobile/presentation/pages/Pet/pet_info_form.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:fluffypawmobile/ui/component/vaccine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class PetProfile extends ConsumerStatefulWidget{
  final int petId; // Accept petId as a parameter

  PetProfile({required this.petId});
  @override
  _PetProfileState createState() => _PetProfileState();

}

class _PetProfileState extends ConsumerState<PetProfile>{
  int _selectedTabIndex = 0;

  //static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petProfileViewModelProvider(widget.petId));

    if (petState.isLoading) {
      return LoadingScreen(); // Loading state
    }

    if (petState.errorMessage != null) {
      return Center(child: Text(petState.errorMessage!)); // Error state
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 17, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, petState),
                SizedBox(height: 22),
                _buildTabs(),
                SizedBox(height: 24),
                _buildTabContent(petState),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedTabIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          // Action to create a new vaccine
          _createNewVaccine();
        },
        backgroundColor: Color(0xFFFFC0CB), // Replace with your desired color
        child: Icon(Icons.add),
      )
          : null, // No button on other tabs

    );
  }

  Widget _buildHeader(BuildContext context, PetInfoState pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/svg/auth_back_icon.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Hồ sơ thú cưng',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0x99D9DFE6)),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFECEFF2),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 4.2),
              Text(
                pet.name, // Pet's name
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              SizedBox(width: 12.7),
              SvgPicture.asset('assets/vectors/vector_98_x2.svg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTab('About', isActive: _selectedTabIndex == 0, index: 0),
        _buildTab('Hồ sơ bệnh lý', isActive: _selectedTabIndex == 1, index: 1),
        _buildTab('Nhắc nhở', isActive: _selectedTabIndex == 2, index: 2),
      ],
    );
  }

  Widget _buildTab(String text, {bool isActive = false, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: isActive ? Color(0xFFFFD67B) : Color(0xFFD9DFE6)),
            borderRadius: BorderRadius.circular(10),
            color: isActive ? Color(0xFFFFC542) : Color(0xFFECEFF2),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isActive ? Color(0xFFFFFFFF) : Color(0xFF838383),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTabContent(PetInfoState pet) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildPetInfo(pet); // Tab "About"
      case 1:
        return _buildMedicalRecordTab(pet); // Tab "Hồ sơ bệnh lý"
      case 2:
        return _buildRemindersTab(); // Tab "Nhắc nhở"
      default:
        return _buildPetInfo(pet); // Mặc định là tab "About"
    }
  }
  Widget _buildMedicalRecordTab(PetInfoState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle the case when there's an error, and display it only in this tab
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vaccines_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chưa có thông tin về vaccine',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thêm vaccine đầu tiên cho thú cưng của bạn',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // If the vaccine list is null or empty, show a friendly message indicating no vaccines
    if (state.vaccineList!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vaccines_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chưa có thông tin về vaccine',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thêm vaccine đầu tiên cho thú cưng của bạn',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }


    // Display the list of vaccines if available
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: state.vaccineList!.length,
      itemBuilder: (context, index) {
        final vaccine = state.vaccineList![index];
        return GestureDetector(
          onTap: () => _showVaccineDetailDialog(vaccine.id), // Handle tapping on a vaccine card
          child: VaccineCard(
            name: vaccine.name,
            image: vaccine.image,
            vaccineDate: vaccine.vaccineDate,
            description: vaccine.description,
            status: vaccine.status ?? 'Unknown',
          ),
        );
      },
    );
  }
  // Show a dialog with detailed vaccine information
  Future<void> _showVaccineDetailDialog(int vaccineId) async {
    await ref.read(petProfileViewModelProvider(widget.petId).notifier).getVaccineDetailById(vaccineId);

    final vaccineDetail = ref.read(petProfileViewModelProvider(widget.petId)).selectedVaccine;

    if (vaccineDetail == null) {
      return;
    }

    final TextEditingController nameController = TextEditingController(text: vaccineDetail.name);
    final TextEditingController weightController = TextEditingController(text: vaccineDetail.petCurrentWeight?.toString());
    final TextEditingController descriptionController = TextEditingController(text: vaccineDetail.description);
    final TextEditingController vaccineDateController = TextEditingController(
      text: vaccineDetail.vaccineDate != null ? DateFormat('yyyy-MM-dd').format(vaccineDetail.vaccineDate!) : '',
    );
    final TextEditingController nextVaccineDateController = TextEditingController(
      text: vaccineDetail.nextVaccineDate != null ? DateFormat('yyyy-MM-dd').format(vaccineDetail.nextVaccineDate!) : '',
    );

    String? selectedImagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cập nhật vắc-xin'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await _pickImage();
                        if (pickedFile != null) {
                          setState(() {
                            selectedImagePath = pickedFile.path;
                          });
                        }
                      },
                      child: selectedImagePath != null
                          ? Image.file(
                        File(selectedImagePath!),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        vaccineDetail.image ?? 'https://example.com/default-vaccine.jpg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network('https://example.com/default-vaccine.jpg', height: 150, width: 150);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTextField('Tên vắc-xin', nameController),
                    _buildTextField('Cân nặng', weightController),
                    _buildDateField('Ngày tiêm', vaccineDateController),
                    _buildDateField('Ngày tiêm nhắc', nextVaccineDateController),
                    _buildTextField('Mô tả', descriptionController),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Đóng'),
                ),
                TextButton(
                  onPressed: () async {
                    final updatedVaccineData = {
                      'petId': vaccineDetail.petId,
                      'name': nameController.text,
                      'petCurrentWeight': double.tryParse(weightController.text),
                      'vaccineDate': vaccineDateController.text,
                      'nextVaccineDate': nextVaccineDateController.text,
                      'description': descriptionController.text,
                      'image': selectedImagePath,
                    };

                    await ref.read(petProfileViewModelProvider(widget.petId).notifier)
                        .updateVaccineById(vaccineId, updatedVaccineData);

                    Navigator.pop(context);
                    // Refresh the vaccine list after update
                    ref.read(petProfileViewModelProvider(widget.petId).notifier).loadPetById(widget.petId);
                  },
                  child: Text('Cập nhật'),
                ),
                TextButton(
                  onPressed: () async {
                    await ref.read(petProfileViewModelProvider(widget.petId).notifier)
                        .deleteVaccineById(vaccineId);

                    Navigator.pop(context);
                    // Refresh the vaccine list after update
                    ref.read(petProfileViewModelProvider(widget.petId).notifier).loadPetById(widget.petId);
                  },
                  child: Text('Xoá'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _createNewVaccine() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController vaccineDateController = TextEditingController();
    final TextEditingController nextVaccineDateController = TextEditingController();

    String? selectedImagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tạo vắc-xin mới'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await _pickImage();
                        if (pickedFile != null) {
                          setState(() {
                            selectedImagePath = pickedFile.path;
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImagePath != null
                            ? Image.file(
                          File(selectedImagePath!),
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.add_a_photo, size: 50),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTextField('Tên vắc-xin', nameController),
                    _buildTextField('Cân nặng', weightController),
                    _buildDateField('Ngày tiêm', vaccineDateController),
                    _buildDateField('Ngày tiêm nhắc', nextVaccineDateController),
                    _buildTextField('Mô tả', descriptionController),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () async {
                    final newVaccineData = {
                      'petId': widget.petId,
                      'name': nameController.text,
                      'petCurrentWeight': double.tryParse(weightController.text),
                      'vaccineDate': vaccineDateController.text,
                      'nextVaccineDate': nextVaccineDateController.text,
                      'description': descriptionController.text,
                      'image': selectedImagePath,
                    };

                    // Call the method to create a new vaccine
                    await ref.read(petProfileViewModelProvider(widget.petId).notifier)
                        .addNewVaccine(newVaccineData);

                    Navigator.pop(context);
                    // Refresh the vaccine list after creation
                    ref.read(petProfileViewModelProvider(widget.petId).notifier).loadPetById(widget.petId);
                  },
                  child: Text('Tạo'),
                ),
              ],
            );
          },
        );
      },
    );
  }


// Helper to build a text field
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }


// Helper to build a date picker field
  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }
  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }



  Widget _buildRemindersTab() {
    return Center(
      child: Text("Nhắc nhở sẽ hiển thị ở đây."),
    );
  }



  Widget _buildPetInfo(PetInfoState pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.network(
                pet.image ?? "https://logowik.com/content/uploads/images/cat8600.jpg", // URL from pet object or fallback to default
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  // Display a default image if there's an error loading the image
                  return Image.network(
                    "https://logowik.com/content/uploads/images/cat8600.jpg", // Default fallback image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name, // Use pet's name
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetInfoForm(petId: widget.petId, petCategory: pet.petCategory),
                            ),
                          );

                          // If the result is true, reload the pet profile data
                          if (result == true) {
                            ref.read(petProfileViewModelProvider(widget.petId).notifier).loadPetById(widget.petId);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFF3CFD7)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SvgPicture.asset('assets/svg/edit_pet_button.svg'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        pet.petCategory ?? 'Unknown category',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF838383),
                        ),
                      ),
                      SizedBox(width: 6.7),
                      Container(
                        width: 10,
                        height: 1,
                        color: Color(0xFFC6CED9),
                      ),
                      SizedBox(width: 5),
                      Text(
                        pet.petTypeName ?? 'Unknown type',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF838383),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        _buildAppearanceSection(pet),
        SizedBox(height: 24),
        _buildImportantDatesSection(pet),
        SizedBox(height: 24),
        _buildEditButton(),
      ],
    );
  }



  Widget _buildAppearanceSection(PetInfoState pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngoại hình và dấu hiệu nhận biết',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF1B1B1B),
          ),
        ),
        SizedBox(height: 16),
        Text(
          pet.description,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF838383),
          ),
        ),
        SizedBox(height: 8),
        _buildInfoRow('Giới Tính', pet.sex),
        _buildInfoRow('Cân Nặng', pet.weight.toString()),
        _buildInfoRow('Mã số chip', pet.microchipNumber),
        _buildInfoRow('Đã triệt sản hay chưa', pet.isNeuter.toString()),
        _buildInfoRow('Chế độ ăn uống', pet.allergy),
        _buildInfoRow('Hành vi đặc biệt', pet.behaviorCategory),
        _buildInfoRow('Tính cách', 'Thân thiện'),

      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFECEFF2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF838383),
              ),
            ),
          ),
          SizedBox(width: 16), // Khoảng cách giữa label và value
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1B1B1B),
              ),
              softWrap: true,
              maxLines: 2, // Giới hạn tối đa số dòng (có thể thay đổi theo nhu cầu)
              overflow: TextOverflow.ellipsis, // Nếu quá dài thì sẽ hiển thị "..."
              textAlign: TextAlign.right, // Căn phải cho value
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantDatesSection(PetInfoState pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày đặc biệt',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF1B1B1B),
          ),
        ),
        SizedBox(height: 20),
        _buildDateRow('Sinh Nhật', pet.dob.toString(), '', 'assets/svg/pet_birthday.svg'),
        SizedBox(height: 15),
        // _buildDateRow('Ngày nhận nuôi', '6/1/2020', '', 'assets/svg/pet_home_icon.svg'),
      ],
    );
  }

  Widget _buildDateRow(String label, String date, String age, String iconPath) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Color(0xFFF3CFD7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(iconPath),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF838383),
                ),
              ),
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1B1B1B),
                ),
              ),
            ],
          ),
        ),
        if (age.isNotEmpty)
          Text(
            age,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF1B1B1B),
            ),
          ),
      ],
    );
  }

  Widget _buildCaretakersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Caretakers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF1B1B1B),
          ),
        ),
        SizedBox(height: 20),
        _buildCaretakerRow('Esther Howard', 'esther.howard@gmail.com'),
        SizedBox(height: 15),
        _buildCaretakerRow('Guy Hawkins', 'guyhawkins@gmail.com'),
      ],
    );
  }

  Widget _buildCaretakerRow(String name, String email) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1B1B1B),
              ),
            ),
            Text(
              email,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF838383),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Show a confirmation dialog before deleting
          final confirmDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Xác nhận'),
              content: Text('Bạn có chắc chắn muốn xoá thú cưng này không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Huỷ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Xoá'),
                ),
              ],
            ),
          );

          if (confirmDelete != true) {
            return;
          }

          // Call deletePetById from the ViewModel
          final result = await ref.read(petProfileViewModelProvider(widget.petId).notifier).deletePetById(widget.petId);

          // If the pet is deleted successfully, navigate to the home page
          result.fold(
                (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xoá thất bại: ${failure.message}')),
              );
            },
                (isDeleted) {
              if (isDeleted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()), // Navigate to Home screen
                      (Route<dynamic> route) => false, // Clear the navigation stack
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xoá thất bại')),
                );
              }
            },
          );
        },
        child: Text(
          'Xoá Thú Cưng',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFFFFFFFF),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF3CFD7)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

}