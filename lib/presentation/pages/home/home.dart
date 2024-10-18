import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/Pet/pet_form.dart';
import 'package:fluffypawmobile/presentation/pages/Pet/pet_profile.dart';
import 'package:fluffypawmobile/presentation/pages/booking/store_detail.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:fluffypawmobile/presentation/pages/user_profile/profile_navigator.dart';
import 'package:fluffypawmobile/presentation/state/pet_state.dart';
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
    // Lấy HomeState và PetState từ ViewModel thông qua Provider
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final petState = ref.watch(petViewModelProvider);  // Theo dõi trạng thái thú cưng

    if (homeState.isLoading || petState.isLoading) {
      return LoadingScreen(); // Hiển thị màn hình loading khi dữ liệu đang được tải
    }

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
                      _buildPetCard(context, petState),  
                      _buildQuickActions(context, homeState),
                      Text(
                        'Dịch vụ được sử dụng nhiều nhất!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF000000),
                        ),
                      ),
                      _buildSpecialistSection(homeState, context),
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

  // Cập nhật phương thức _buildPetCard
  Widget _buildPetCard(BuildContext context, PetState petState) {
    if (petState.pets.isEmpty) {
      // Nếu không có thú cưng nào, hiển thị thẻ "Thêm thú cưng mới"
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
        height: 150,
        child: _buildAddNewPetCard(context),
      );
    }

    // Nếu có thú cưng, hiển thị danh sách thú cưng
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 150,
      child: PageView(
        children: petState.pets.map((pet) {
          return _buildPetCardItem(pet);  // Tạo thẻ cho mỗi thú cưng
        }).toList()
          ..add(_buildAddNewPetCard(context)),  // Thêm thẻ "Thêm thú cưng mới" vào cuối
      ),
    );
  }

  // Phương thức tạo thẻ "Thêm thú cưng mới"
  // Modify _buildAddNewPetCard to handle result from PetForm
  Widget _buildAddNewPetCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to PetForm and await the result
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetForm()),
        );

        // If the result is true (pet was added), reload the pet data
        if (result == true) {
          ref.read(petViewModelProvider.notifier).loadPetList(); // Assuming loadPets() is the method to fetch pet data
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(19.5, 14.5, 19.5, 14.5),
        decoration: BoxDecoration(
          color: Color(0xFFECEFF2),
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
              Icons.add,
              color: Color(0xFF333333),
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Thêm thú cưng mới',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Phương thức tạo thẻ cho mỗi thú cưng
  Widget _buildPetCardItem(PetModel pet) {
    return GestureDetector(
      onTap: () {
        // Navigate to PetProfile and pass the pet ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetProfile(petId: pet.id), // Pass the pet ID to the profile page
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(19.5, 14.5, 19.5, 14.5),
        decoration: BoxDecoration(
          color: Color(0xFFF6C8E1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
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
            // Expanded widget to prevent text overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet name
                  Text(
                    pet.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 1.5,
                      color: Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis, // Handle long text gracefully
                  ),
                  // Pet category
                  Text(
                    pet.petType?.petCategory.name ?? "meo",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                  ),
                ],
              ),
            ),
            // Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: pet.image != null
                    ? Image.network(
                  pet.image ?? "https://logowik.com/content/uploads/images/cat8600.jpg",  // Use image from the pet object
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://logowik.com/content/uploads/images/cat8600.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Image.network(
                  'https://logowik.com/content/uploads/images/cat8600.jpg',  // Fallback image
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
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
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Color(0xFF838383),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Tìm kiếm',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF838383),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, HomeState state) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: state.serviceTypeNames.length,
        itemBuilder: (context, index) {
          return _buildActionItem(
            context,
            state.serviceTypeNames[index],
            'assets/svg/service_type.svg',
          );
        },
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String title, String assetPath) {
    return Container(
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
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 70,
              height: 70,
            ),
            SizedBox(width: 8),
            Flexible( // Sử dụng Flexible để đảm bảo Text xuống dòng khi cần thiết
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1B1B1B),
                ),
                maxLines: 2, // Giới hạn tối đa 2 dòng
                overflow: TextOverflow.ellipsis, // Cắt văn bản nếu vượt quá
                softWrap: true, // Cho phép xuống dòng nếu cần thiết
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildSpecialistSection(HomeState state, BuildContext context) {
    // Nếu danh sách cửa hàng rỗng, hiển thị thông báo
    if (state.storeList == null || state.storeList!.isEmpty) {
      return Center(
        child: Text(
          'No stores available',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF000000),
          ),
        ),
      );
    }

    // Hiển thị danh sách cửa hàng
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          // Hiển thị mỗi cửa hàng trong danh sách storeList
          ...state.storeList!.map((store) {
            return GestureDetector(
              onTap: () {
                // Điều hướng đến trang Service khi nhấn vào cửa hàng
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoreDetail(storeId: store.id,)), // Điều hướng đến trang Service
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
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
                    // Hình ảnh của cửa hàng
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          store.file?.file ?? "https://png.pngtree.com/png-clipart/20190903/original/pngtree-store-icon-png-image_4419850.jpg",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://cdn-icons-png.freepik.com/512/3028/3028549.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Thông tin của cửa hàng
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên cửa hàng
                          Text(
                            store.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF1B1B1B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Brand name của cửa hàng
                          Text(
                            store.brandName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF838383),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          // Đánh giá của cửa hàng
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              SizedBox(width: 5.3),
                              Text(
                                store.totalRating?.toStringAsFixed(1) ?? '0.0',
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
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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
                        'Home', 'assets/svg/home_icon.svg', true),
                  ),
                ),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: _buildNavItem(
                          'Service', 'assets/svg/service_icon.svg', false),
                    )),
                Expanded(
                    child: _buildNavItem('Message',
                        'assets/svg/message.svg', false)),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProfileNavigator()));
                      },
                      child: _buildNavItem(
                          'Account', 'assets/svg/account_icon.svg', false),
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
}
