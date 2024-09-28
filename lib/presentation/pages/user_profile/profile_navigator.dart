import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:fluffypawmobile/presentation/pages/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileNavigator extends ConsumerStatefulWidget{
  @override
  _ProfileNavigatorState createState() => _ProfileNavigatorState();
  
}
class _ProfileNavigatorState extends ConsumerState<ProfileNavigator> {
  @override
  Widget build(BuildContext context) {
    final userProfileViewModel = ref.watch(userProfileViewModelProvider);

    if (userProfileViewModel.isLoading) {
      return LoadingScreen(); // Display loading screen while data is being fetched
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          // Handle back navigation
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: Image.network(userProfileViewModel.avatar),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userProfileViewModel.fullName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userProfileViewModel.email,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'My Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text(
                      'Personal information',
                      style: TextStyle(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Navigate to the UserProfileScreen when tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(), // Your target screen
                        ),
                      );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    trailing: Text('English (US)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined),
                    title: Text('Privacy Policy'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Setting'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SwitchListTile(
                    title: Text('Push Notifications'),
                    value: true,
                    onChanged: (bool value) {
                      // Handle push notifications toggle
                    },
                  ),
                  SwitchListTile(
                    title: Text('Promotional Notifications'),
                    value: false,
                    onChanged: (bool value) {
                      // Handle promotional notifications toggle
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'More',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Help Center'),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Log Out', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context));
  }
}

Widget _buildBottomNavBar(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFFFFFFF),
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
                  child: _buildNavItem(
                      'Service', 'assets/svg/service_icon.svg', false)),
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
        color: isActive ? Color(0xFF1B85F3) : Color(0xFF838383),
        width: 28,
        height: 28,
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: isActive ? Color(0xFF1B85F3) : Color(0xFF838383),
        ),
      ),
    ],
  );
}
