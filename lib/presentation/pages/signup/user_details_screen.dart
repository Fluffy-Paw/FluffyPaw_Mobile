import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/presentation/viewmodels/signup_viewmodel.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';

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
    final signupState = ref.watch(signupViewModelProvider);

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
                _buildHeader(context),
                _buildInputField('Username', _userNameController),
                _buildInputField('Password', _passwordController, isPassword: true),
                _buildInputField('Confirm Password', _confirmPasswordController, isPassword: true),
                _buildInputField('Full Name', _fullNameController),
                _buildInputField('Address', _addressController),
                _buildInputField('Email', _emailController),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.8, 0, 5.8, 75),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 230,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/auth_back_icon.svg'),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'User Details',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF1B1B1B),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Enter your $label',
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ],
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
    );
  }
}