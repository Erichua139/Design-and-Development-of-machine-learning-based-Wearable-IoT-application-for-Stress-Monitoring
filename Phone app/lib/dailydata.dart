// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:intl/intl.dart';
// import 'firebase_options.dart';
// import 'package:mockito/mockito.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class DailyData extends StatefulWidget{
//
//   @override
//   _DailyData createState() => _DailyData();
// }
// class _DailyData extends State<DailyData> {
//   List<double> data = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dynamic Line Chart'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//
//             children: [
//               if(data.length >= 5)
//                 Row(
//                   children: [Container(
//                     width: 50, // Adjust the width as needed
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         // Add your y-axis labels here
//                         Text('100'),
//                         Text('75'),
//                         Text('50'),
//                         Text('25'),
//                         Text('0'),
//                       ],
//                     ),
//                   ),
//
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children:[
//
//                         SizedBox(
//                         height: MediaQuery.of(context).size.height /3,
//                         width: (data.length + 2) * 50,
//                         child: LineChart(
//
//                           LineChartData(
//                             minX: 0, // Minimum value for the x-axis
//                             maxX: data.length.toDouble() - 1, // Maximum value for the x-axis
//                             minY: 0, // Minimum value for the y-axis
//                             maxY: 100, // Maximum value for the y-axis
//                             titlesData: FlTitlesData(
//                               bottomTitles: AxisTitles(
//                                 sideTitles: SideTitles(
//                                   showTitles: true,
//                                   reservedSize: 30,
//                                   interval: 1,
//                                   getTitlesWidget: bottomTitleWidgets,
//                                 ),
//                               )
//                             ),
//                             /////////////////////
//                             lineBarsData: [
//                               LineChartBarData(
//                                 spots: data.asMap().entries.map((entry) {
//                                   return FlSpot(entry.key.toDouble(), entry.value);
//                                 }).toList(),
//                                 isCurved: true,
//                                 // color: [Colors.blue],
//                                 barWidth: 4,
//                                 belowBarData: BarAreaData(show: false),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                       ), ],
//                     ),
//                   ),
//                 ),]
//                 ),
//             if(data.length < 5)
//               SizedBox(
//                 height: MediaQuery.of(context).size.height / 3, // Adjust height as needed
//                 // width: (data.length + 2) * 50,
//                 child: LineChart(
//                   LineChartData(
//                     minX: 0, // Minimum value for the x-axis
//                     maxX: data.length.toDouble() - 1, // Maximum value for the x-axis
//                     minY: 0, // Minimum value for the y-axis
//                     maxY: 100, // Maximum value for the y-axis
//                     titlesData: FlTitlesData(
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 30,
//                             interval: 1,
//                             getTitlesWidget: bottomTitleWidgets,
//                           ),
//                         )
//                     ),
//
//
//
//
//                     /////////////////////
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: data.asMap().entries.map((entry) {
//                           return FlSpot(entry.key.toDouble(), entry.value);
//                         }).toList(),
//                         isCurved: true,
//                         // color: [Colors.blue],
//                         barWidth: 4,
//                         belowBarData: BarAreaData(show: false),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ]
//         ),
//       ),
//     );
//   }
//   @override
//   void initState() {
//     super.initState();
//     // Start receiving data at intervals
//     startDataUpdate();
//   }
//   void startDataUpdate() {
//     // Simulating data updates every 5 minutes
//     // You can replace this with your actual data fetching logic
//     // where you receive data every 5 minutes and update the chart
//     // accordingly.
//     const updateInterval = Duration(seconds: 5);
//     Timer.periodic(updateInterval, (timer) {
//       // Generate random data for demonstration
//       final newData = Random().nextDouble() * 100;
//       setState(() {
//         data.add(newData);
//       });
//     });
//   }
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     String text;
//     final index = value.toInt();
//     final currentTime = DateTime.now();
//     // Subtract minutes based on the index to simulate past time
//     final time = currentTime.subtract(Duration(minutes: data.length - 1 - index));
//     // Assuming your data is a list of DateTime objects
//     // You can format the time according to your preference
//     text =  DateFormat('HH:mm').format(time);
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child:  Text(
//           text,style: style,
//       ),
//     );
//   }
//
// }
