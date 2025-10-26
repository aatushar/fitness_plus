import 'package:fitness_plus/presentation/registration_from/pages/registration_member.dart';
import 'package:flutter/material.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  // Color Constants
  static const Color _backgroundColor = Color(0xFF1A1A2E);
  static const Color _primaryColor = Color(0xFFE94560);
  static const Color _secondaryColor = Color(0xFF16213E);

  // Sample member data
  final List<Member> _allMembers = [
    Member(
      name: 'John Doe',
      phoneNumber: '1234567890',
      email: 'john.doe@example.com',
      membershipType: 'Premium',
      joinDate: DateTime(2023, 5, 15),
    ),
    Member(
      name: 'Jane Smith',
      phoneNumber: '9876543210',
      email: 'jane.smith@example.com',
      membershipType: 'Standard',
      joinDate: DateTime(2023, 6, 20),
    ),
    Member(
      name: 'Mike Johnson',
      phoneNumber: '5555555555',
      email: 'mike.johnson@example.com',
      membershipType: 'Basic',
      joinDate: DateTime(2023, 7, 10),
    ),
    // Add more sample members as needed
  ];

  List<Member> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMembers = _allMembers;
  }

  void _filterMembers(String query) {
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        // Search by name or phone number (case-insensitive)
        return member.name.toLowerCase().contains(query.toLowerCase()) ||
            member.phoneNumber.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _secondaryColor,
        title: const Text(
          'Member List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: _secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by Name or Phone Number',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: _filterMembers,
              ),
            ),
          ),

          // Member List
          Expanded(
            child: _filteredMembers.isEmpty
                ? Center(
              child: Text(
                'No members found',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                return _buildMemberCard(_filteredMembers[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () {
          // Navigate to Add New Member Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationMemberPage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMemberCard(Member member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Membership Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  member.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getMembershipColor(member.membershipType),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  member.membershipType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Contact Details
          _buildDetailRow(Icons.phone, member.phoneNumber),
          const SizedBox(height: 5),
          _buildDetailRow(Icons.email, member.email),
          const SizedBox(height: 10),

          // Join Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[400], size: 16),
              const SizedBox(width: 8),
              Text(
                'Joined: ${_formatDate(member.joinDate)}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getMembershipColor(String membershipType) {
    switch (membershipType) {
      case 'Premium':
        return Colors.purple;
      case 'Standard':
        return Colors.blue;
      case 'Basic':
        return Colors.green;
      default:
        return _primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Member {
  final String name;
  final String phoneNumber;
  final String email;
  final String membershipType;
  final DateTime joinDate;

  Member({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.membershipType,
    required this.joinDate,
  });
}