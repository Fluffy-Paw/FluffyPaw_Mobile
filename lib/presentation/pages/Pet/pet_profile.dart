import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/Pet/pet_form.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:fluffypawmobile/presentation/state/pet_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class PetProfile extends ConsumerStatefulWidget{
  final int petId; // Accept petId as a parameter

  PetProfile({required this.petId});
  @override
  _PetProfileState createState() => _PetProfileState();

}

class _PetProfileState extends ConsumerState<PetProfile> {

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
                _buildPetInfo(petState),
                SizedBox(height: 24),
                _buildAppearanceSection(petState),
                SizedBox(height: 24),
                _buildImportantDatesSection(petState),
                // SizedBox(height: 24),
                // _buildCaretakersSection(),
                SizedBox(height: 24),
                _buildEditButton(),
              ],
            ),
          ),
        ),
      ),
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
        _buildTab('About', isActive: true),
        _buildTab('Hồ sơ bệnh lý'),
        _buildTab('Nhắc nhở'),
        //_buildTab('Activities'),
      ],
    );
  }

  Widget _buildTab(String text, {bool isActive = false}) {
    return Expanded(
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
    );
  }

  Widget _buildPetInfo(PetInfoState pet) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          child: SvgPicture.asset('assets/vectors/image_frame_x2.svg'),
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
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PetForm(petData: pet), // Pass existing pet data to PetForm
                      //   ),
                      // );
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
                    pet.petTypeName ?? 'Unknown type', // Show petTypeName if available, otherwise fallback
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
        _buildDateRow('Sinh Nhật', pet.dob.toString(), '3 y.o', 'assets/svg/pet_birthday.svg'),
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
        onPressed: () {},
        child: Text(
          'Chỉnh sửa',
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