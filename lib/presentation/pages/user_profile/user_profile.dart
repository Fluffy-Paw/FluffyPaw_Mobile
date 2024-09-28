import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/loading_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  @override
  _UserProfileDetailState createState() => _UserProfileDetailState();
}

class _UserProfileDetailState extends ConsumerState<UserProfileScreen> {
  // This state variable will track which form to show
  bool isPersonalSelected = false;

  @override
  Widget build(BuildContext context) {
    final userProfileViewModel = ref.watch(userProfileViewModelProvider);
    if (userProfileViewModel.isLoading) {
      return LoadingScreen(); // Display loading screen while data is being fetched
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle back button press
          },
        ),
        title: Text('User Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Image.network(userProfileViewModel.avatar),
              // You can add a profile image here
            ),
            SizedBox(height: 10),
            Text(
              userProfileViewModel.fullName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              userProfileViewModel.email,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add other stats or buttons here if needed
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLocationChip('Thú Cưng', false),
                _buildLocationChip('Cá Nhân', true),
              ],
            ),
            SizedBox(height: 20),
            // Conditionally render form based on the selected tab
            isPersonalSelected ? _buildPersonalForm(userProfileViewModel.userName, userProfileViewModel.phone, userProfileViewModel.email, userProfileViewModel.address) : _buildPetForm(),
          ],
        ),
      ),
    );
  }

  // Widget to build the personal form
  Widget _buildPersonalForm(String userName, String phone, String email, String address) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align labels to the start
        children: [
          // Label for the username field
          Text(
            'Tài khoản',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: userName,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          // Label for the phone number field
          Text(
            'Số điện thoại',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: phone,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),

          // Label for the email field
          Text(
            'Email',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: email,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),

          // Label for the address field
          Text(
            'Địa chỉ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: address,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }


  // Widget to build the pet form (original form or view)
  Widget _buildPetForm() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(4, (index) {
        return Card(
          color: Colors.grey[300],
          margin: EdgeInsets.all(8),
        );
      }),
    );
  }

  // Function to toggle between personal and pet form
  Widget _buildLocationChip(String location, bool isPersonal) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPersonalSelected = isPersonal;
        });
      },
      child: Chip(
        label: Text(location),
        backgroundColor: isPersonalSelected == isPersonal
            ? Colors.pink[200]
            : Colors.grey[200],
      ),
    );
  }
}
