import 'package:flutter/material.dart';
import 'package:matrimonial_app/api/matrimony_api.dart';
import 'package:matrimonial_app/constants/string_constants.dart';
import 'package:matrimonial_app/database/matrimony_database.dart';
import 'package:matrimonial_app/screens/add_user.dart';
import 'package:matrimonial_app/screens/user_details.dart';

class UserList extends StatefulWidget {
  final List<Map<String, dynamic>> userList;
  bool isFavourite;
  UserList({super.key, required this.userList, required this.isFavourite});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final searchController = TextEditingController();
  String searchQuery = '';
  String selectedSort = 'Sort by';

  void sortUsers(String criteria) {
    setState(() {
      selectedSort = criteria;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> filteredUsers = widget.userList.where((user) {
      return (widget.isFavourite ? user[FAVOURITE] == 1 : true) &&
          (user[NAME].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              user[CITY].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              user[EMAIL].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              user[PHONE].toString().toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    if(selectedSort != 'Sort by') {
      filteredUsers.sort((a, b) {
        switch (selectedSort) {
          case 'Name A-Z':
            return a[NAME].compareTo(b[NAME]);
          case 'Name Z-A':
            return b[NAME].compareTo(a[NAME]);
          case 'Age Ascending':
            return a[AGE].compareTo(b[AGE]);
          case 'Age Descending':
            return b[AGE].compareTo(a[AGE]);
          case 'Email A-Z':
            return a[EMAIL].compareTo(b[EMAIL]);
          case 'Email Z-A':
            return b[EMAIL].compareTo(a[EMAIL]);
          default:
            return 0;
        }
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6A3093), // Deep purple
                Color(0xFFA044FF), // Vibrant purple
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isFavourite ? Icons.favorite : Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  widget.isFavourite ? 'Favourite Users' : 'User List',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: widget.isFavourite
            ? Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
          child: Material(
            elevation: 4,
            color: Colors.transparent,
            shadowColor: Colors.black38,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              splashColor: Colors.white24,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFA044FF), Color(0xFF6A3093)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
            child: Material(
              elevation: 6,
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(15),
              color: Colors.transparent,
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                  ),
                ),
                child: PopupMenuButton<String>(
                  tooltip: "Sort options",
                  offset: Offset(0, 55),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF8008), // Warm orange
                          Color(0xFFFFC837), // Golden yellow
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white30, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF8008).withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sort',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    'Sort by',
                    'Name A-Z',
                    'Name Z-A',
                    'Age Ascending',
                    'Age Descending',
                    'Email A-Z',
                    'Email Z-A',
                  ].map((String value) {
                    bool isSelected = value == selectedSort;
                    bool isHeader = value == 'Sort by';

                    return PopupMenuItem<String>(
                      enabled: !isHeader,
                      value: value,
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: isHeader
                          ? Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Color(0xFF6A3093),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFFFFF8E1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Color(0xFFFF8008) : Colors.grey.shade200,
                              ),
                              child: Center(
                                child: isSelected
                                    ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              value,
                              style: TextStyle(
                                color: isSelected ? Color(0xFFFF8008) : Colors.grey.shade800,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onSelected: (String newValue) {
                    if(newValue == selectedSort) {
                      sortUsers('Sort by');
                    }
                    else {
                      sortUsers(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade100,
              Colors.purple.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                // Enhanced Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade600, size: 26),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                        onPressed: () {
                          searchController.clear();
                          searchUser('');
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search by name, city, email or phone...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    ),
                    onChanged: searchUser,
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 20),

                // User Count Indicator with better styling
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_alt,
                        color: Colors.deepPurple.shade600,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${filteredUsers.length} ${filteredUsers.length == 1 ? 'User' : 'Users'} found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Empty State
                filteredUsers.isEmpty
                    ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No Users Found',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            int idx = widget.userList.indexOf(filteredUsers[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserDetails(userDetails: filteredUsers[index], userList: widget.userList, index: idx),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(
                                color: filteredUsers[index][FAVOURITE] == 1
                                    ? Colors.red.shade200
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            elevation: 5,
                            shadowColor: Colors.purple.withOpacity(0.2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  colors: filteredUsers[index][FAVOURITE] == 1
                                      ? [Colors.white, Colors.red.shade50]
                                      : [Colors.white, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Horizontal layout with avatar on left and details on right
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Avatar on left
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.deepPurple.withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundColor: Colors.deepPurple.shade100,
                                            child: Text(
                                              '${filteredUsers[index][NAME].toString().isNotEmpty ? filteredUsers[index][NAME].substring(0, 1).toUpperCase() : "?"}',
                                              style: TextStyle(
                                                color: Colors.deepPurple.shade700,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 20),

                                        // User details on right
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Name and Age
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${filteredUsers[index][NAME]}',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepPurple.shade800,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  // Age Badge
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.deepPurple.shade100,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      '${filteredUsers[index][AGE]} yrs',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepPurple.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 12),

                                              // Location
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, size: 20, color: Colors.deepPurple.shade400),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      '${filteredUsers[index][CITY]}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8),

                                              // Phone
                                              Row(
                                                children: [
                                                  Icon(Icons.phone, size: 20, color: Colors.green.shade600),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      '${filteredUsers[index][PHONE]}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8),

                                              // Email
                                              Row(
                                                children: [
                                                  Icon(Icons.email, size: 20, color: Colors.orange.shade600),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      '${filteredUsers[index][EMAIL]}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16),
                                    Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                                    SizedBox(height: 16),

                                    // Compact Action Buttons (No Scrolling Needed)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildActionButton(
                                          index: index,
                                          filteredUsers: filteredUsers,
                                          type: 'favorite',
                                        ),
                                        _buildActionButton(
                                          index: index,
                                          filteredUsers: filteredUsers,
                                          type: 'edit',
                                        ),
                                        _buildActionButton(
                                          index: index,
                                          filteredUsers: filteredUsers,
                                          type: 'delete',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // FAB for adding new users
      floatingActionButton: !widget.isFavourite ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(userList: widget.userList),
            ),
          );
        },
        label: Text(
          'Add User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: Icon(Icons.person_add),
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 8,
      ) : null,
    );
  }

  // Compact action button builder
  Widget _buildActionButton({
    required int index,
    required List<Map<String, dynamic>> filteredUsers,
    required String type,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData iconData;
    String tooltip;
    Function()? onPressed;

    switch (type) {
      case 'favorite':
        backgroundColor = filteredUsers[index][FAVOURITE] == 1 ? Colors.red.shade50 : Colors.grey.shade100;
        textColor = filteredUsers[index][FAVOURITE] == 1 ? Colors.red : Colors.grey.shade700;
        iconData = filteredUsers[index][FAVOURITE] == 1 ? Icons.favorite : Icons.favorite_border;
        tooltip = filteredUsers[index][FAVOURITE] == 1 ? 'Remove from Favorites' : 'Add to Favorites';
        onPressed = () async {
          int idx = widget.userList.indexOf(filteredUsers[index]);
          // int? id = await MatrimonyDatabase().getId(widget.userList[idx][EMAIL]);

          // Create a mutable copy of the user data
          Map<String, dynamic> updatedUser = Map<String, dynamic>.from(widget.userList[idx]);

          // Toggle the favourite status
          if (updatedUser[FAVOURITE] == 1) {
            await MatrimonyApi().updateFavourite(updatedUser[ID], 0);
            // await MatrimonyDatabase().setFavourite(id, false);
            updatedUser[FAVOURITE] = 0;
          } else {
            await MatrimonyApi().updateFavourite(updatedUser[ID], 1);
            // await MatrimonyDatabase().setFavourite(id, true);
            updatedUser[FAVOURITE] = 1;
          }

          widget.userList.clear();
          widget.userList.addAll(await MatrimonyApi().fetchUsers());

          setState(() {
            // widget.userList[idx] = updatedUser;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: updatedUser[FAVOURITE] == 1
                    ? Colors.red.shade800
                    : Colors.grey.shade800,
                content: Row(
                  children: [
                    Icon(
                      updatedUser[FAVOURITE] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      updatedUser[FAVOURITE] == 1
                          ? "Added to Favourites"
                          : "Removed from Favourites",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          });
        };
        break;

      case 'edit':
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        iconData = Icons.edit;
        tooltip = 'Edit';
        onPressed = () {
          int idx = widget.userList.indexOf(filteredUsers[index]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(userList: widget.userList, index: idx),
            ),
          );
        };
        break;

      case 'delete':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        iconData = Icons.delete;
        tooltip = 'Delete';
        onPressed = () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Delete User', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                content: Text(
                  'Are you sure you want to delete this user? This action cannot be undone.',
                  style: TextStyle(fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      int idx = widget.userList.indexOf(filteredUsers[index]);
                      // int? id = await MatrimonyDatabase().getId(widget.userList[idx][EMAIL]);
                      // MatrimonyDatabase().deleteUser(id);
                      await MatrimonyApi().deleteUser(context: context, id: widget.userList[idx][ID].toString());
                      // widget.userList.removeAt(idx);
                      widget.userList.clear();
                      widget.userList.addAll(await MatrimonyApi().fetchUsers());

                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.red.shade800,
                            content: Row(
                              children: [
                                Icon(Icons.delete_forever, color: Colors.white),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "User Deleted Successfully",
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        };
        break;

      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        iconData = Icons.more_horiz;
        tooltip = 'Action';
        onPressed = () {};
    }

    // Return a compact icon button with tooltip instead of a button with text
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 50,
        height: 50,
        child: Material(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(25),
            child: Center(
              child: Icon(
                iconData,
                color: textColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void searchUser(String query) {
    setState(() {
      searchQuery = query;
    });
  }
}