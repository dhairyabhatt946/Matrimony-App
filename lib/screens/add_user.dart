import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/api/matrimony_api.dart';
import 'package:matrimonial_app/constants/string_constants.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/database/matrimony_database.dart';
import 'package:matrimonial_app/screens/user_list.dart';
import 'package:sqflite/sqflite.dart';

class AddUser extends StatefulWidget {
  final List<Map<String, dynamic>> userList;
  final int? index;

  const AddUser({super.key, required this.userList, this.index});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? selectedDateOfBirth;
  String? selectedCity;
  String? selectedGender;
  bool showGenderError = false;
  bool isReading = false;
  bool isMusic = false;
  bool isMovies = false;
  bool isSports = false;
  bool isExecuted = true;

  // Colors
  final primaryColor = Color(0xFF6A1B9A); // Deep Purple
  final secondaryColor = Color(0xFF9C27B0); // Purple
  final accentColor = Color(0xFFE1BEE7); // Light Purple
  final textColor = Color(0xFF424242); // Dark Grey
  final errorColor = Color(0xFFD32F2F); // Red

  @override
  void initState() {
    super.initState();
    _populateFormIfEditing();
  }

  void _populateFormIfEditing() {
    if (widget.index != null && isExecuted) {
      nameController.text = widget.userList[widget.index!][NAME];
      passwordController.text = widget.userList[widget.index!][PASSWORD];
      addressController.text = widget.userList[widget.index!][ADDRESS];
      emailController.text = widget.userList[widget.index!][EMAIL];
      phoneController.text = widget.userList[widget.index!][PHONE];
      selectedDateOfBirth = DateTime.parse(widget.userList[widget.index!][DOB]);
      selectedCity = widget.userList[widget.index!][CITY];
      selectedGender = widget.userList[widget.index!][GENDER];

      final hobbies = widget.userList[widget.index!][HOBBIES];
      isReading = hobbies.contains('Reading');
      isMusic = hobbies.contains('Music');
      isMovies = hobbies.contains('Movies');
      isSports = hobbies.contains('Sports');

      isExecuted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.index != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          isEditMode ? 'Edit Profile' : 'Create Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, accentColor.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Personal Information'),
                _buildTextField(nameController, 'Full Name', Icons.person, 'Please enter a name'),
                _buildPasswordField(),
                _buildTextField(emailController, 'Email Address', Icons.email, 'Please enter a valid email', isEmail: true),
                _buildTextField(phoneController, 'Mobile Number', Icons.phone_android, 'Enter a valid 10-digit number', isPhone: true),
                _buildDatePicker(context),

                SizedBox(height: 16),
                _buildSectionHeader('Location Details'),
                _buildTextField(addressController, 'Address', Icons.home, 'Please enter your address'),
                _buildCityDropdown(),

                SizedBox(height: 16),
                _buildSectionHeader('Personal Preferences'),
                _buildGenderSelection(),
                _buildHobbiesSection(),

                SizedBox(height: 24),
                _buildSaveResetButtons(isEditMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Divider(color: accentColor, thickness: 1.5),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      String validationMsg,
      {bool isEmail = false, bool isPhone = false}
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
          controller: controller,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : (isPhone ? TextInputType.phone : TextInputType.text),
          inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: errorColor, width: 1),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(icon, color: primaryColor),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            else if (isEmail) {
              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              else {
                for (var map in widget.userList) {
                  if (map[EMAIL] == value) {
                    if (widget.index != null) {
                      if (map[EMAIL] != widget.userList[widget.index!][EMAIL]) {
                        return 'Email already exists';
                      }
                    }
                    else {
                      return 'Email already exists';
                    }
                  }
                }
              }
            }
            else if(isPhone) {
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Enter a valid 10-digit mobile number';
              }
              else {
                for (var map in widget.userList) {
                  if (map[PHONE] == value) {
                    if (widget.index != null) {
                      if (map[PHONE] != widget.userList[widget.index!][PHONE]) {
                        return 'Mobile number already exists';
                      }
                    }
                    else {
                      return 'Mobile number already exists';
                    }
                  }
                }
              }
            }
            return null;
          }
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: 'Enter your password',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.lock, color: primaryColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
        validator: (value) => value == null || value.isEmpty
            ? 'Please enter your password'
            : null,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    TextEditingController dateController = TextEditingController(
      text: selectedDateOfBirth != null
          ? DateFormat('dd/MM/yyyy').format(selectedDateOfBirth!)
          : '',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: 'Select your date of birth',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.calendar_today, color: primaryColor),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDateOfBirth ?? DateTime.now().subtract(Duration(days: 365 * 18)),
            firstDate: DateTime.now().subtract(Duration(days: 365 * 80)),
            lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    onSurface: textColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            setState(() {
              selectedDateOfBirth = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
              dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
        validator: (value) {
          if (selectedDateOfBirth == null) {
            return 'Please select your date of birth';
          }

          final today = DateTime.now();
          final age = today.year - selectedDateOfBirth!.year -
              ((today.month < selectedDateOfBirth!.month ||
                  (today.month == selectedDateOfBirth!.month && today.day < selectedDateOfBirth!.day)) ? 1 : 0);

          if (age < 18) {
            return 'You must be at least 18 years old to register';
          } else if (age > 80) {
            return 'The maximum age allowed is 80 years';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedCity,
        items: ['Ahmedabad', 'Rajkot', 'Junagadh', 'Vadodara', 'Surat', 'Jamnagar']
            .map((city) => DropdownMenuItem(value: city, child: Text(city)))
            .toList(),
        onChanged: (value) => setState(() => selectedCity = value),
        decoration: InputDecoration(
          labelText: 'City',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: 'Select your city',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.location_city, color: primaryColor),
          ),
        ),
        validator: (value) => value == null ? 'Please select a city' : null,
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: primaryColor),
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedGender = 'Male'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedGender == 'Male' ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedGender == 'Male' ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          color: selectedGender == 'Male' ? Colors.white : primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedGender == 'Male' ? Colors.white : textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedGender = 'Female'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedGender == 'Female' ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedGender == 'Female' ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          color: selectedGender == 'Female' ? Colors.white : primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedGender == 'Female' ? Colors.white : textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showGenderError)
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Please select a gender',
                style: TextStyle(color: errorColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHobbiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hobbies & Interests',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildHobbyChip('Reading', isReading, () => setState(() => isReading = !isReading)),
              _buildHobbyChip('Music', isMusic, () => setState(() => isMusic = !isMusic)),
              _buildHobbyChip('Movies', isMovies, () => setState(() => isMovies = !isMovies)),
              _buildHobbyChip('Sports', isSports, () => setState(() => isSports = !isSports)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHobbyChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? Icon(Icons.check_circle, color: Colors.white, size: 18)
                : Icon(Icons.circle_outlined, color: primaryColor, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveResetButtons(bool isEditMode) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                showGenderError = selectedGender == null;
              });

              if (_formKey.currentState!.validate() && !showGenderError) {
                Map<String, dynamic> map = {};
                final today = DateTime.now();
                final age = today.year -
                    selectedDateOfBirth!.year -
                    ((today.month < selectedDateOfBirth!.month ||
                        (today.month == selectedDateOfBirth!.month &&
                            today.day < selectedDateOfBirth!.day))
                        ? 1
                        : 0);

                map[NAME] = nameController.text.toString();
                map[PASSWORD] = passwordController.text.toString();
                map[ADDRESS] = addressController.text.toString();
                map[EMAIL] = emailController.text.toString();
                map[PHONE] = phoneController.text.toString();
                map[DOB] = selectedDateOfBirth?.toIso8601String().split('T')[0];
                map[AGE] = age;
                map[CITY] = selectedCity.toString();
                map[GENDER] = selectedGender.toString();
                map[HOBBIES] = '';

                if(widget.index != null) {
                  if(widget.userList[widget.index!][FAVOURITE] == 1) {
                    map[FAVOURITE] = 1;
                  }
                  else {
                    map[FAVOURITE] = 0;
                  }
                }
                else {
                  map[FAVOURITE] = 0;
                }

                if (isReading) map[HOBBIES] += 'Reading ';
                if (isMusic) map[HOBBIES] += 'Music ';
                if (isMovies) map[HOBBIES] += 'Movies ';
                if (isSports) map[HOBBIES] += 'Sports ';

                if(widget.index != null) {
                  // int? id = await MatrimonyDatabase().getId(widget.userList[widget.index!][EMAIL]);
                  // MatrimonyDatabase().updateUser(id, map);
                  await MatrimonyApi().updateUser(context: context, id: widget.userList[widget.index!][ID].toString(), map: map);
                  // widget.userList[widget.index!] = map;
                  widget.userList.clear();
                  widget.userList.addAll(await MatrimonyApi().fetchUsers());

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Profile updated successfully"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )
                  );

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserList(
                          userList: widget.userList,
                          isFavourite: false,
                        ),
                      )
                  );
                }
                else {
                  // MatrimonyDatabase().addUser(map);
                  await MatrimonyApi().addUser(context: context, map: map);
                  // widget.userList.add(map);
                  widget.userList.clear();
                  widget.userList.addAll(await MatrimonyApi().fetchUsers());

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Profile created successfully"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )
                  );

                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Text(
              isEditMode ? 'Update Profile' : 'Create Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                nameController.text = '';
                passwordController.text = '';
                addressController.text = '';
                emailController.text = '';
                phoneController.text = '';
                selectedDateOfBirth = null;
                selectedCity = null;
                selectedGender = null;
                isReading = false;
                isMusic = false;
                isMovies = false;
                isSports = false;
                showGenderError = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 0,
            ),
            child: Text(
              'Reset Form',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}