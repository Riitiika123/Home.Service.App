import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_service_app/screens/consumer/providerdetailscreen.dart';
import 'package:home_service_app/utilities/ui.dart';

class ServiceProviderListScreen extends StatelessWidget {
  final String serviceName;

  const ServiceProviderListScreen({required this.serviceName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providersRef = FirebaseFirestore.instance.collection('providers');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$serviceName Providers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.background,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            providersRef.where('service', isEqualTo: serviceName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(
                child: Text('No providers available for $serviceName'));

          final providers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final data = providers[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['fullName'] ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              data['service'] ?? 'Service',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Text(
                            '₹${data['charges'] ?? '--'} / hr',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProviderDetailScreen(data: data),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              backgroundColor: AppColors.background,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'View',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.star_border, color: AppColors.rating),
                          SizedBox(width: 4),
                          Text("Rating", style: TextStyle(fontSize: 23)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
