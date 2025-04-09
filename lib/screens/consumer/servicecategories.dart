import 'package:flutter/material.dart';
import 'package:home_service_app/screens/consumer/serviceproviderlistscreen.dart';
import 'package:home_service_app/utilities/ui.dart';

class ServiceCategoriesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Carpenter', 'icon': Icons.handyman},
    {'name': 'Painter', 'icon': Icons.format_paint},
    {'name': 'Gardening', 'icon': Icons.park_outlined},
    {'name': 'Vehicle Repair', 'icon': Icons.car_crash_rounded},
    {'name': 'Laundry', 'icon': Icons.local_laundry_service},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 3; // Responsive count

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.8,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceProviderListScreen(
                    serviceName: category['name'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      category['icon'],
                      size: 26,
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
