import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/domain/entities/store.dart';
import 'package:fluffypawmobile/presentation/pages/booking/booking_screen.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:fluffypawmobile/presentation/state/store_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreDetail extends ConsumerStatefulWidget {
  final int storeId;
  StoreDetail({required this.storeId});
  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends ConsumerState<StoreDetail> {
  int? selectedServiceId;
  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(storeDetailViewModelProvider(widget.storeId));
    if(storeState.isLoading){
      return LoadingScreen();
    }
    if (storeState.errorMessage != null) {
      return Center(child: Text(storeState.errorMessage!)); // Error state
    }
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 30), // Add some space for the overlapping box
                  _buildContent(storeState),
                  _buildBottomSheet(storeState),
                ],
              ),
              Positioned(
                top: 170, // Adjust this value to control how much the box overlaps
                left: 20,
                right: 20,
                child: _buildSalonInfoBox(storeState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://cdn-icons-png.freepik.com/512/3028/3028549.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(); // Navigates back to the previous screen
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7), // Semi-transparent background for better visibility
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back, // Back arrow icon
                size: 24,
                color: Colors.black, // Color of the icon
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildSalonInfoBox(StoreDetailState store) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            store.storeModel.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 24),
              SizedBox(width: 4),
              Text(
                store.storeModel.totalRating.toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              SizedBox(width: 4),
              Text(
                '(230 reviews)',
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
    );
  }

  Widget _buildContent(StoreDetailState store) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          _buildInfoSection('Contact', _buildContactInfo(store)),
          _buildDivider(),
          _buildInfoSection('Location', _buildLocationInfo(store)),
          _buildDivider(),
         // _buildInfoSection('Availability', _buildAvailabilityInfo()),
         // _buildDivider(),
          _buildInfoSection('Services', _buildServicesList(store)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF1B1B1B),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF606873)),
          ],
        ),
        SizedBox(height: 17),
        content,
      ],
    );
  }

  Widget _buildContactInfo(StoreDetailState store) {
    return Column(
      children: [
        _buildContactRow('Phone:', store.storeModel.phone, 'assets/png/phoneicon.png'),
        SizedBox(height: 16),
        _buildContactRow('Brand:', store.storeModel.brandName, 'assets/png/brand-image.png'),
      ],
    );
  }

  Widget _buildContactRow(String label, String value, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF4F8FB)),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x338B9EB8),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14), // Match the container's border radius
            child: Image.asset(
              iconPath,
              width: 50,
              height: 50,
              fit: BoxFit.cover, // Ensure the icon fits the container properly
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLocationInfo(StoreDetailState store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationRow('Address:', store.storeModel.address),
        SizedBox(height: 8),
        // _buildLocationRow('City:', 'London'),
        // SizedBox(height: 8),
        // _buildLocationRow('Country:', 'United Kingdom'),
        // SizedBox(height: 16),
        SvgPicture.asset('assets/svg/map.svg', width: double.infinity, height: 150),
      ],
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF838383),
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWeekdayButtons(),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Hours:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF838383),
              ),
            ),
            SizedBox(width: 5),
            Text(
              '10:00 - 20:00',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayButtons() {
    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays.map((day) => _buildWeekdayButton(day, day != 'S')).toList(),
    );
  }

  Widget _buildWeekdayButton(String day, bool isActive) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: isActive ? Color(0xFFD1E6FF) : Color(0xFFECEFF2)),
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Color(0x80D1E6FF) : Color(0xFFF7FAFC),
        ),
        child: Center(
          child: Text(
            day,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: isActive ? Color(0xFF1B85F3) : Color(0xFFA0AEC0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList(StoreDetailState store) {
    final services = store.storeServiceList;

    // Show localized message if no services are available
    if (services.isEmpty) {
      return Center(
        child: Text(
          'Store này không có dịch vụ nào',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Render the list of services if available
    return Column(
      children: services.map((service) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedServiceId = service.id; // Update selected service ID
            });
          },
          child: _buildServiceItem(
            service.name,
            service.cost,
            isSelected: selectedServiceId == service.id,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServiceItem(String name, int price, {required bool isSelected}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? Color(0xFF1B85F3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A323247),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0x140C1A4B),
            offset: Offset(0, 0),
            blurRadius: 2.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF1B1B1B),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '\$',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF202326),
                  ),
                ),
                TextSpan(
                  text: price.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color(0xFF202326),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(StoreDetailState store) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F494D5A),
            offset: Offset(0, -5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Book a date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B85F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: selectedServiceId != null
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(serviceId: selectedServiceId!),
                      ),
                    );
                  }
                      : null,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  child: Text('Chat with Shop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B85F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButton.icon(
            icon: SvgPicture.asset('assets/vectors/vector_64_x2.svg', width: 20, height: 20),
            label: Text('Add to contacts'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1B85F3),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 1,
      color: Color(0xFFECEFF2),
    );
  }
}
