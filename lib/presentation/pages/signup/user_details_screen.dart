import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/presentation/viewmodels/signup_viewmodel.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'component/custom_header.dart';
import 'component/custom_input_field.dart';

final signupViewModelProvider = StateNotifierProvider<SignupViewmodel, AsyncValue<void>>((ref) {
  return SignupViewmodel(ref.read(registerAccountProvider));
});

class UserDetailsScreen extends ConsumerStatefulWidget {
  final String phone;

  UserDetailsScreen({required this.phone});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 17, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  title: 'User Detail',
                  onBackPress: () => Navigator.pop(context),
                ),
                CustomInputField(
                  label: 'Username',
                  hintText: 'Enter Your Username',
                  controller: _userNameController,
                ),
                CustomInputField(label: "Password",hintText: 'Enter Your Password', controller: _passwordController, isPassword: true),
                CustomInputField(label: 'Confirm Password',hintText: 'Enter Confirm Password',controller:  _confirmPasswordController, isPassword: true),
                CustomInputField(label: 'Full Name',hintText: 'Enter Your Full Name',controller:  _fullNameController),
                CustomInputField(label: 'Address',hintText:'Enter Your Address',controller:  _addressController),
                CustomInputField(label: 'Email',hintText: 'Enter Your Email' ,controller:  _emailController),
                _buildDatePicker(),
                _buildGenderPicker(),
                _buildTermsCheckbox(),
                SizedBox(height: 40),
                _buildCompleteButton(context),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select your date of birth'
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: _selectedDate == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPicker() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.all(15),
            ),
            hint: Text('Select your gender'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
            items: <String>['Male', 'Female', 'Other']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Checkbox(
            value: _agreeToTerms,
            onChanged: (bool? value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
          ),
          Expanded(
            child: Text(
              'I agree to the Terms and Conditions',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _agreeToTerms
            ? () {
          if (_validateInputs()) {
            _registerUser(context);
          }
        }
            : null,
        child: Text(
          'Complete',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0099FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    // Add validation logic here
    return _userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty;
  }

  void _registerUser(BuildContext context) {
    final signupViewModel = ref.read(signupViewModelProvider.notifier);

    // Gọi quá trình đăng ký và xử lý kết quả
    signupViewModel.register(
      widget.phone,
      _userNameController.text,
      _passwordController.text,
      _confirmPasswordController.text,
      _emailController.text,
      _fullNameController.text,
      _addressController.text,
      _selectedDate,
      _selectedGender,
    ).then((result) {
      result.fold(
            (failure) {
          // Nếu có lỗi xảy ra, hiển thị lỗi từ tầng Data
          print("Register failed: ${failure.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng ký thất bại: ${failure.message}')),
          );
        },
            (_) {
          // Đăng ký thành công, log ra console
          print("Register successful");
        },
      );
    });
  }



}