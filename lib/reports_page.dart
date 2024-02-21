import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TruckiveReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for reports
    final List<Map<String, dynamic>> reports = [
      {
        'title': 'Fuel Efficiency',
        'description': 'Monthly analysis of fuel efficiency across all routes.',
        'icon': Icons.local_gas_station,
      },
      {
        'title': 'Distance Covered',
        'description':
            'Weekly report on the total distance covered by the fleet.',
        'icon': Icons.map,
      },
      {
        'title': 'Delivery Timelines',
        'description':
            'Overview of delivery timelines adherence for the past month.',
        'icon': Icons.access_time,
      },
      {
        'title': 'Vehicle Maintenance',
        'description': 'Quarterly maintenance report of all vehicles.',
        'icon': Icons.build_circle,
      },
      {
        'title': 'Expense Tracking',
        'description':
            'Detailed report on expenses for the current fiscal quarter.',
        'icon': Icons.attach_money,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Truckive Reports', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(report['icon'],
                  color: Theme.of(context).colorScheme.primary),
              title: Text(report['title'],
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
              subtitle: Text(report['description'], style: GoogleFonts.lato()),
              onTap: () {
                // Placeholder for onTap event. You can navigate to detailed report page or perform other actions.
              },
            ),
          );
        },
      ),
    );
  }
}
