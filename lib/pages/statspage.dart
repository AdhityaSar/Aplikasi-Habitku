// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class StatsPage extends StatefulWidget {
//   const StatsPage({super.key});

//   @override
//   State<StatsPage> createState() => _StatsPageState();
// }

// class _StatsPageState extends State<StatsPage> {
//   late TooltipBehavior _tooltipBehavior;

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'YOUR STATS',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Center(
//                 child: Wrap(
//                   spacing: 16.0,
//                   runSpacing: 16.0,
//                   alignment: WrapAlignment.center,
//                   children: [
//                     _buildStatsCard(
//                       title: '12 Days',
//                       subtitle: 'Total Perfect Days',
//                       color: Colors.blue,
//                       icon: Icons.calendar_today,
//                     ),
//                     _buildStatsCard(
//                       title: '12 Days',
//                       subtitle: 'Total Times Completed',
//                       color: Colors.red,
//                       icon: Icons.check_circle_outline,
//                     ),
//                     _buildStatsCard(
//                       title: '100%',
//                       subtitle: 'Habit Completion Rate',
//                       color: Colors.orange,
//                       icon: Icons.auto_graph,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'STATISTICS',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Container(
//                 height: 300,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   title: ChartTitle(text: 'Half yearly sales analysis'),
//                   legend: Legend(isVisible: true),
//                   tooltipBehavior: _tooltipBehavior,
//                   series: <LineSeries<SalesData, String>>[
//                     LineSeries<SalesData, String>(
//                       dataSource: <SalesData>[
//                         SalesData('Jan', 35),
//                         SalesData('Feb', 28),
//                         SalesData('Mar', 34),
//                         SalesData('Apr', 32),
//                         SalesData('May', 40),
//                       ],
//                       xValueMapper: (SalesData sales, _) => sales.year,
//                       yValueMapper: (SalesData sales, _) => sales.sales,
//                       dataLabelSettings: DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsCard({
//     required String title,
//     required String subtitle,
//     required Color color,
//     required IconData icon,
//   }) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white, size: 32),
//           SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SalesData {
//   SalesData(this.year, this.sales);
//   final String year;
//   final double sales;
// }

import 'package:flutter/material.dart';

class Statspage extends StatefulWidget {
  const Statspage({super.key});

  @override
  State<Statspage> createState() => _StatspageState();
}

class _StatspageState extends State<Statspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YOUR STATS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Stats Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
