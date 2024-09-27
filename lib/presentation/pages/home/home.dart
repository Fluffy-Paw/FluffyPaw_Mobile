import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/viewmodels/home_viewmodel.dart';
import 'package:fluffypawmobile/ui/appTheme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    // Lấy HomeState từ HomeViewModel thông qua Provider
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, homeState, homeViewModel),
                      _buildSearchBar(),
                      _buildPetCard(context),
                      _buildQuickActions(context),
                      _buildSpecialistSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomNavBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.lightTheme.primaryColor,
                child: ClipOval(child: Image.network(state.avatarUrl)),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, ${state.userName}',
                    style: AppTheme.lightTheme.textTheme.displayMedium,
                  ),
                  Text(
                    state.greeting,
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
          // IconButton(
          //   icon: Icon(Icons.notifications),
          //   onPressed: () {
          //     viewModel.goToNotifications(context); // Gọi hàm từ HomeViewModel
          //   },
          //),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: EdgeInsets.symmetric(horizontal: 13.9),
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF), // Đổi màu nền sang trắng để nổi bật hơn
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Màu bóng nhạt
            blurRadius: 6, // Độ mờ của bóng
            offset: Offset(0, 3), // Đổ bóng nhẹ xuống dưới
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search, // Thay bằng icon tìm kiếm mặc định của Flutter
            color: Color(0xFF838383),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Tìm kiếm',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14, // Điều chỉnh kích thước text cho vừa vặn hơn
              color: Color(0xFF838383),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPetCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 150, // Chiều cao tương ứng với thẻ ban đầu
      child: PageView(
        children: [
          // Thẻ Pet hiện tại
          Container(
            padding: EdgeInsets.fromLTRB(19.5, 14.5, 19.5, 14.5),
            decoration: BoxDecoration(
              color: Color(0xFFF6C8E1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Color(0x05323247),
                  offset: Offset(0, 3),
                  blurRadius: 7.5,
                ),
                BoxShadow(
                  color: Color(0x0D0C1A4B),
                  offset: Offset(0, 0),
                  blurRadius: 1.875,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mận',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.5,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      'Mèo | Mèo Mướp',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.4,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Đảm bảo Container có hình tròn
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Màu bóng
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Đổ bóng xuống và sang bên
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/cat.jpeg',
                      width: 80, // Điều chỉnh kích thước hình ảnh
                      height: 80,
                      fit: BoxFit.cover, // Cắt hình ảnh phù hợp
                    ),
                  ),
                ),

              ],
            ),
          ),
          // Thẻ thêm thú cưng mới
          Container(
            padding: EdgeInsets.fromLTRB(19.5, 14.5, 19.5, 14.5),
            decoration: BoxDecoration(
              color: Color(0xFFECEFF2), // Màu nền khác biệt cho thẻ thêm mới
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Color(0x05323247),
                  offset: Offset(0, 3),
                  blurRadius: 7.5,
                ),
                BoxShadow(
                  color: Color(0x0D0C1A4B),
                  offset: Offset(0, 0),
                  blurRadius: 1.875,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add, // Biểu tượng dấu cộng
                  color: Color(0xFF333333),
                  size: 30, // Điều chỉnh kích thước biểu tượng cho phù hợp
                ),
                SizedBox(width: 10), // Khoảng cách giữa biểu tượng và text
                Text(
                  'Thêm thú cưng mới',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16, // Điều chỉnh kích thước font chữ cho phù hợp
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(context, 'Dinh Dưỡng',
              'assets/vectors/pet_app_dashboard_cards_x2.svg'),
          _buildActionItem(
              context, 'Sức Khoẻ', 'assets/vectors/ellipse_fill_x2.svg'),
          _buildActionItem(
              context, 'Hoạt Động', 'assets/vectors/container_x2.svg'),
        ],
      ),
    );
  }
  Widget _buildActionItem(
      BuildContext context, String title, String assetPath) {
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 3,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFF7FAFC)),
        borderRadius: BorderRadius.circular(14),
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x05323247),
            offset: Offset(0, 3),
            blurRadius: 7.5,
          ),
          BoxShadow(
            color: Color(0x0D0C1A4B),
            offset: Offset(0, 0),
            blurRadius: 1.875,
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(assetPath),
          SizedBox(height: 17.5),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF1B1B1B),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSpecialistSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ được sử dụng nhiều nhất!',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF000000),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(0xFFC4C4C4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shinny Fur Saloon',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    Text(
                      'Veterinary Behavioral',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF838383),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset('assets/vectors/vector_62_x2.svg'),
                        SizedBox(width: 5.3),
                        Text(
                          '4.8',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF838383),
                          ),
                        ),
                        SizedBox(width: 16.4),
                        SvgPicture.asset('assets/vectors/fimap_pin_x2.svg'),
                        SizedBox(width: 4),
                        Text(
                          '1 km',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF838383),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9F5F6),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            offset: Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
            height: 90,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: _buildNavItem(
                        'Home', 'assets/vectors/vector_24_x2.svg', true),
                  ),
                ),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: _buildNavItem(
                          'Service', 'assets/vectors/vector_27_x2.svg', false),
                    )),
                Expanded(
                    child: _buildNavItem('Message',
                        'assets/vectors/comment_filled_1_x2.svg', false)),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Account()));
                      },
                      child: _buildNavItem('Account',
                          'assets/vectors/user_regular_x2.svg', false),
                    )),
              ],
            )),
      ),
    );
  }
  Widget _buildNavItem(String label, String iconPath, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          color: isActive ? Color(0xFFF6C8E1) : Color(0xFF838383),
          width: 28,
          height: 28,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: isActive ? Color(0xFFF6C8E1) : Color(0xFF838383),
          ),
        ),
      ],
    );
  }



// Các hàm còn lại tương tự nhưng sẽ gọi từ viewModel
}
