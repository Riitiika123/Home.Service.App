import 'package:flutter/material.dart';

class ProviderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProviderDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fullName = data['fullName'] ?? 'No Name';
    final String service = data['service'] ?? 'Service';
    final String charges = data['charges']?.toString() ?? '--';
    final String phone = data['phone'] ?? 'N/A';
    final String email = data['email'] ?? 'N/A';
    final String about = data['about'] ?? 'No description available';
    final String profileImage = data['profileImageUrl'] ?? 'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(
        title: Text(fullName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Top Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(profileImage),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 4),
                      Text(service,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee, size: 18, color: Colors.green),
                          Text('$charges/hr',
                              style: TextStyle(fontSize: 14, color: Colors.black)),

                          SizedBox(width: 16),
                          Icon(Icons.phone, size: 18, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(phone, style: TextStyle(fontSize: 14)),

                          SizedBox(width: 16),
                          Icon(Icons.email, size: 18, color: Colors.deepOrange),
                          SizedBox(width: 4),
                          Expanded(
                              child: Text(email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14))),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Divider(),

          // About Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  Text('About',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(about,
                      style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                ],
              ),
            ),
          ),

          // Book Now Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add booking logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Book Now", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
