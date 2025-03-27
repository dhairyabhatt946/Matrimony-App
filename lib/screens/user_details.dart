import 'package:flutter/material.dart';
import 'package:matrimonial_app/constants/string_constants.dart';
import 'package:matrimonial_app/screens/add_user.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatelessWidget {
  final Map<String, dynamic> userDetails;
  final List<Map<String, dynamic>> userList;
  final int index;
  UserDetails({super.key, required this.userDetails, required this.userList, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.deepPurple),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.deepPurple),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUser(userList: userList, index: index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProfileHeader(context),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: _buildDetailsSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.purple.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.deepPurple.shade300,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  userDetails[NAME],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${userDetails[CITY] ?? "N/A"}, India',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildSectionCard(
            'Personal Information',
            [
              _buildDetailItem(Icons.person, 'Name', userDetails[NAME]),
              _buildDetailItem(Icons.wc, 'Gender', userDetails[GENDER] ?? 'N/A'),
              _buildDetailItem(
                Icons.calendar_today,
                'Date of Birth',
                userDetails[DOB] != null
                    ? DateFormat('dd-MM-yyyy').format(userDetails[DOB] is String
                    ? DateTime.parse(userDetails[DOB])
                    : userDetails[DOB])
                    : 'N/A',
              ),
              _buildDetailItem(Icons.favorite, 'Marital Status', 'Unmarried'),
            ],
          ),
          SizedBox(height: 20),
          _buildSectionCard(
            'Location',
            [
              _buildDetailItem(Icons.flag, 'Country', 'India'),
              _buildDetailItem(Icons.map, 'State', 'Gujarat'),
              _buildDetailItem(Icons.location_city, 'City', userDetails[CITY] ?? 'N/A'),
              _buildDetailItem(Icons.church, 'Religion', 'Hindu'),
            ],
          ),
          SizedBox(height: 20),
          _buildSectionCard(
            'Career',
            [
              _buildDetailItem(Icons.school, 'Education', 'M.Tech'),
              _buildDetailItem(Icons.work, 'Occupation', 'Software Engineer'),
            ],
          ),
          SizedBox(height: 20),
          _buildSectionCard(
            'Interests',
            [
              _buildDetailItem(Icons.interests, 'Hobbies', userDetails[HOBBIES] ?? 'N/A'),
            ],
          ),
          SizedBox(height: 20),
          _buildSectionCard(
            'Contact',
            [
              _buildDetailItem(Icons.email, 'Email', userDetails[EMAIL]),
              _buildDetailItem(Icons.phone, 'Phone', userDetails[PHONE]),
              _buildDetailItem(Icons.home, 'Address', userDetails[ADDRESS] ?? 'N/A'),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.deepPurple.shade700,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}