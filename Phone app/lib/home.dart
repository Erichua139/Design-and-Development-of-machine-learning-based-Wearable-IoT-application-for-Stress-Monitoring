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
//
// import 'package:fl_chart/fl_chart.dart';
//
// class Home extends StatefulWidget {
//   // final FirebaseFirestore firestore;
//
//
//   const Home({super.key});
//
//
//   @override
//   State<Home> createState() => _HomeState();
//
//
// }
//
//  class _HomeState extends State<Home> {
//    _HomeState() : super();
//
//
//   double averageHR = 0;
//   double averageTemp = 0;
//   String lastMeasurementTime = '';
//   int lastHR = 0;
//   int lastTemp = 0;
//   bool lastStress = false;
//    String errorMessage = '';
//    String errorMessage2 = '';
//    bool showAvg = false;
//    List<dynamic> dataArray =[] ;
//    String formattedDateTime = '';
//    // List<FlSpot> chartData = [];
//    List<dynamic> lastdataArray =[] ;
//    int stressed = 0;
//    int calm = 0;
//    String finalstatus = '' ;
//    @override
//   void initState() {
//     super.initState();
//     fetchMeasurements();
//     fetchLastMeasurement();
//   }
// /////////// daily fetchMeasurements
//    List<FlSpot> chartData = [];
//    List<FlSpot> lastTenData = [];
//
//   @override
//
//   Future<void> fetchMeasurements() async {
//     final CollectionReference collectionReference =
//     FirebaseFirestore.instance.collection("monitoring_data");
//
//     try {
//
// // Get the current date and time
//       DateTime now = DateTime.now();
//
// // Get the start of the current day
//       DateTime startOfDay = DateTime(now.year, now.month, now.day);
//
// // Get the start of the next day
//       DateTime endOfDay = startOfDay.add(Duration(days: 1));
//
// // Query the documents for the current day
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('monitoring_data')
//
//           // .where('date', isGreaterThanOrEqualTo: startOfDay)
//           // .where('date', isLessThan: endOfDay)
//           .get();
//
//       chartData.clear();
//       double i =0;
//       if(querySnapshot.docs.isEmpty)
//         {
//           setState((){
//             errorMessage = 'No measurements recorded for today.';
//           });
//           return;
//         }
//       // Process each document in the querySnapshot
//       querySnapshot.docs.forEach((doc) {
//          dataArray = doc['data'] as List<dynamic>;
//         // Extract the necessary data from the document
//         // For example, if 'rmssd' is the value you want to add to the chart data
//
//         dataArray.forEach((dataElement) {
//           // Extract rmssd and timestamp from the data element
//           int rmssd = (dataElement['rmssd'] as num).toInt();
//           Timestamp timestamp = dataElement['timestamp'] as Timestamp;
//           DateTime dateTime = timestamp.toDate();
//           // double totalHours = dateTime.hour + (dateTime.minute / 60);
//           formattedDateTime = dateTime.toString();
//           // Add the data point to the chart data list
//           chartData.add(FlSpot(i++, rmssd.toDouble()/10));
//           bool status = dataElement['ml_output'] ;
//           if(status)
//             {
//               calm++;
//             }else{
//             stressed++;
//           }
//         });
//
//         if(calm > stressed)
//           {
//             finalstatus = "Calm" ;
//           }else{
//           finalstatus = "Stressed" ;
//         }
//       });
//       // Rest of your code for processing querySnapshot...
//     } catch (e) {
//       print('Error fetching measurements: $e');
//       // Handle error
//     }
//   }
//
//
//
//   /////////////fetchLastMeasurement
//
//
//    Future<List<FlSpot>> fetchLastMeasurement() async {
//      try {
//        // Get today's date
//        DateTime now = DateTime.now();
// // Get the start of the current day
//        DateTime startOfDay = DateTime(now.year, now.month, now.day);
// // Get the start of the next day
//        DateTime endOfDay = startOfDay.add(Duration(days: 1));
//
//
//        // Query documents for today's date
//        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//            .collection('monitoring_data')
//            .where('date', isGreaterThanOrEqualTo: startOfDay)
//            .where('date', isLessThan: endOfDay)
//            .get();
//
//        if(querySnapshot.docs.isEmpty)
//        {
//          setState((){
//            errorMessage2 = 'No measurements recorded for today.';
//          });
//          return [];
//        }
//        lastTenData.clear();
//        // Process each document in the querySnapshot
//        int cntr =0;
//       double i =0;
//        querySnapshot.docs.forEach((doc) {
//        lastdataArray = doc['data'] as List<dynamic>;
//          // Iterate through the data array to get the last ten entries
//          print("leeeength "+ lastdataArray.length.toString());
//        int startIndex =  lastdataArray.length - 1 ;
//
//          while ( cntr < 10 && startIndex >= 0) {
//            int rmssd = (lastdataArray[startIndex]['rmssd'] as num).toInt();
//            Timestamp timestamp = lastdataArray[startIndex]['timestamp'] as Timestamp;
//            DateTime dateTime = timestamp.toDate();
//            double xValue = dateTime.hour.toDouble() + (dateTime.minute.toDouble() / 60);
//            lastTenData.add(FlSpot(i++, rmssd.toDouble()/10));
//            cntr++;
//            startIndex--;
//          }
//        });
//        // lastTenData = lastTenData.reversed.toList();
//
//
//        // Sort the data based on X value if necessary
//        // lastTenData.sort((a, b) => a.x.compareTo(b.x));
//
//        // Do something with the last ten data points
//        print('Last ten data points: $lastTenData');
//
//        return lastTenData;
//      } catch (e) {
//        print('Error fetching last ten measurements: $e');
//        return []; // Return an empty list in case of error
//      }
//    }
//
//
// /////////////////////////widget
//    Widget build(BuildContext context) {
//      return Scaffold(
//        backgroundColor: Colors.grey[300],
//        appBar: AppBar(
//          backgroundColor: Colors.cyan[700],
//          title: Text(
//            'Stress Check',
//            style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 24.0,
//              letterSpacing: 2.0,
//            ),
//          ),
//          centerTitle: true,
//          elevation: 0,
//          automaticallyImplyLeading: false,
//          actions: [
//            IconButton(
//              onPressed: () {
//                fetchMeasurements();
//                fetchLastMeasurement();
//              },
//              icon: Icon(Icons.refresh),
//            )
//          ],
//        ),
//        body: RefreshIndicator(
//          onRefresh: () async {
//            await Future.delayed(
//              const Duration(seconds: 2),
//            );
//            // fetchMeasurements();
//            fetchMeasurements();
//            fetchLastMeasurement();
//
//          },
//          child: ListView(
//            children: [
//              Padding(
//                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
//
//                child: Container(
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
//                    child: Column(
//                      children: [
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
//                              child: Text(
//                                'RMSSD values',
//                                style: TextStyle(
//                                  letterSpacing: 2.0,
//                                  color: Colors.grey[800],
//                                  fontSize: 22.0,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                        Divider(
//                          color: Colors.grey[800],
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
//                          child: errorMessage != ''
//                              ? Padding(
//                            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
//                            child: Text(
//                              errorMessage, // Display the error message if it exists
//                              style: TextStyle(
//                                color: Colors.red,
//                                fontSize: 16.0,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          )
//                              : Stack(
//                            children: <Widget>[
//                              AspectRatio(
//                                aspectRatio: 1.70,
//                                child: Padding(
//                                  padding: const EdgeInsets.only(
//                                    right: 1,
//                                    left: 1,
//                                    top: 24,
//                                    bottom: 12,
//                                  ),
//                                  child: LineChart(
//                                    showAvg ? avgData() : mainData(chartData, dataArray),
//                                  ),
//                                ),
//                              ),
//                              SizedBox(
//                                width: 80,
//                                height: 34,
//                                child: TextButton(
//                                  onPressed: () {
//                                    setState(() {
//                                      showAvg = !showAvg;
//                                    });
//                                  },
//                                  child: Text(
//                                    'avg',
//                                    style: TextStyle(
//                                      fontSize: 12,
//                                      color: showAvg ? Colors.grey.withOpacity(0.5) : Colors.white,
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        Divider(
//                          color: Colors.grey[800],
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 15.0, 0.0),
//                          child: Column(
//                            children: [Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                Text(
//                                  'Last Measurement',
//                                  style: TextStyle(
//                                    letterSpacing: 2.0,
//                                    color: Colors.grey[800],
//                                    fontSize: 24.0,
//
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//
//                              ],
//                            ),
//                              Text(
//                                finalstatus,
//                                style: TextStyle(
//                                  letterSpacing: 2.0,
//                                  color: Colors.grey[800],
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              Text(
//                                formattedDateTime,
//                                style: TextStyle(
//                                  letterSpacing: 2.0,
//                                  color: Colors.grey[800],
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ],
//                          ),
//
//                        ),
//                        Text(
//                          lastMeasurementTime,
//                          style: TextStyle(
//                            letterSpacing: 2.0,
//                            color: Colors.grey[850],
//                            fontSize: 22.0,
//                          ),
//                        ),
//
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      );
//    }
//
//
//
//
//
//    Widget leftTitleWidgets(double value) {
//      const style = TextStyle(
//        fontWeight: FontWeight.bold,
//        fontSize: 15,
//      );
//      final labels = ['0', '10','20','30','40','50'];
//      if (value.toInt() < labels.length) {
//        return Text(labels[value.toInt()], style: style);
//      } else {
//        return Container();
//      }
//    }
//    Widget bottomTitleWidgets(double value) {
//      const style = TextStyle(
//        fontWeight: FontWeight.bold,
//        fontSize: 16,
//      );
//      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//
//
//        String text =DateFormat.Hm().format(dateTime);
//
//        return
//           Text(
//            text,
//            style: style,
//
//        );
//      }
//    }
//
//    LineChartData mainData(List<FlSpot> chartData, List<dynamic> data) {
//   print("hellooo "+chartData.toString());
//      List<dynamic> timestamps = data.map((element) => element['timestamp'].toDate()).toList();
//
//      double minX = timestamps.isNotEmpty ? timestamps.first.millisecondsSinceEpoch.toDouble() : 0;
//      double maxX = timestamps.isNotEmpty ? timestamps.last.millisecondsSinceEpoch.toDouble() : 0;
//
//      return LineChartData(
//        gridData: FlGridData(
//          show: true,
//
//          horizontalInterval: 1,
//
//          getDrawingHorizontalLine: (value) {
//            return const FlLine(
//              color: Colors.grey,
//              strokeWidth: 1,
//            );
//          },
//
//        ),
//        titlesData: FlTitlesData(
//          show: true,
//          rightTitles: const AxisTitles(
//            sideTitles: SideTitles(showTitles: false),
//          ),
//          topTitles: const AxisTitles(
//            sideTitles: SideTitles(showTitles: false),
//          ),
//          bottomTitles: AxisTitles(
//            sideTitles: SideTitles(
//              showTitles: false,
//              reservedSize: 30,
//              interval: (maxX - minX) / 5, // Adjust interval as needed
//              // getTitlesWidget: (timestamps.) => bottomTitleWidgets(timestamps),
//            ),
//
//          ),
//          leftTitles: AxisTitles(
//            sideTitles: SideTitles(
//              showTitles: false,
//              interval: 10,
//              // getTitlesWidget: leftTitleWidgets,
//              reservedSize: 42,
//
//            ),
//          ),
//        ),
//        borderData: FlBorderData(
//          show: true,
//          border: Border.all(color: const Color(0xff37434d)),
//        ),
//        minX: 0,
//        maxX: 10,
//        minY: 0,
//        maxY: 10,
//        lineBarsData: [
//          LineChartBarData(
//            spots: chartData,
//            // isCurved: true,
//
//            barWidth: 3,
//            isStrokeCapRound: true,
//            dotData: const FlDotData(
//              show: false,
//             ),
//            belowBarData: BarAreaData(
//              show: false,
//
//            ),
//          ),
//        ],
//      );
//    }
//
//    LineChartData avgData() {
//      return LineChartData(
//        lineTouchData: const LineTouchData(enabled: false),
//        gridData: FlGridData(
//          show: true,
//          drawHorizontalLine: true,
//          verticalInterval: 1,
//          horizontalInterval: 1,
//          getDrawingVerticalLine: (value) {
//            return const FlLine(
//              color: Color(0xff37434d),
//              strokeWidth: 1,
//            );
//          },
//          getDrawingHorizontalLine: (value) {
//            return const FlLine(
//              color: Color(0xff37434d),
//              strokeWidth: 4,
//            );
//          },
//        ),
//        titlesData: FlTitlesData(
//          show: true,
//          bottomTitles: AxisTitles(
//            sideTitles: SideTitles(
//              showTitles: true,
//              reservedSize: 30,
//              // getTitlesWidget: bottomTitleWidgets,
//              interval: 1,
//            ),
//          ),
//          leftTitles: AxisTitles(
//            sideTitles: SideTitles(
//              showTitles: true,
//              // getTitlesWidget: leftTitleWidgets,
//              reservedSize: 42,
//              interval: 1,
//            ),
//          ),
//          topTitles: const AxisTitles(
//            sideTitles: SideTitles(showTitles: false),
//          ),
//          rightTitles: const AxisTitles(
//            sideTitles: SideTitles(showTitles: false),
//          ),
//        ),
//        borderData: FlBorderData(
//          show: true,
//          border: Border.all(color: const Color(0xff37434d)),
//        ),
//        minX: 0,
//        maxX: 11,
//        minY: 0,
//        maxY: 6,
//        lineBarsData: [
//          LineChartBarData(
//            spots: const [
//              FlSpot(0, 3.44),
//              FlSpot(2.6, 3.44),
//              FlSpot(4.9, 3.44),
//              FlSpot(6.8, 3.44),
//              FlSpot(8, 3.44),
//              FlSpot(9.5, 3.44),
//              FlSpot(11, 3.44),
//            ],
//            isCurved: true,
//            gradient: LinearGradient(
//              colors: [
//                ColorTween(begin: Colors.cyan, end: Colors.cyan)
//                    .lerp(0.2)!,
//                ColorTween(begin: Colors.cyan, end: Colors.cyan)
//                    .lerp(0.2)!,
//              ],
//            ),
//            barWidth: 5,
//            isStrokeCapRound: true,
//            dotData: const FlDotData(
//              show: false,
//            ),
//            belowBarData: BarAreaData(
//              show: true,
//              gradient: LinearGradient(
//                colors: [
//                  ColorTween(begin: Colors.cyan, end: Colors.cyan)
//                      .lerp(0.2)!
//                      .withOpacity(0.1),
//                  ColorTween(begin: Colors.cyan, end: Colors.cyan)
//                      .lerp(0.2)!
//                      .withOpacity(0.1),
//                ],
//              ),
//            ),
//          ),
//        ],
//      );
//    }
//
// LineChartData mainLastData(List<FlSpot> lastchart) {
//   print("hellooo "+lastchart.toString());
//   // List<dynamic> timestamps = data.map((element) => element['timestamp'].toDate()).toList();
//   //
//   // double minX = timestamps.isNotEmpty ? timestamps.first.millisecondsSinceEpoch.toDouble() : 0;
//   // double maxX = timestamps.isNotEmpty ? timestamps.last.millisecondsSinceEpoch.toDouble() : 0;
//   List<FlSpot> lastdata2 = lastchart.reversed.toList();
//
//   return LineChartData(
//     gridData: FlGridData(
//       show: true,
//
//       horizontalInterval: 1,
//
//       getDrawingHorizontalLine: (value) {
//         return const FlLine(
//           color: Colors.cyan,
//           strokeWidth: 1,
//         );
//       },
//
//     ),
//     titlesData: FlTitlesData(
//       show: true,
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           // interval: (maxX - minX) / 5, // Adjust interval as needed
//           // getTitlesWidget: (timestamps.) => bottomTitleWidgets(timestamps),
//         ),
//
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           // getTitlesWidget: leftTitleWidgets,
//           reservedSize: 42,
//         ),
//       ),
//     ),
//     borderData: FlBorderData(
//       show: true,
//       border: Border.all(color: const Color(0xff37434d)),
//     ),
//     minX: 1,
//     maxX: 9,
//     minY: 1,
//     maxY: 10,
//     lineBarsData: [
//       LineChartBarData(
//         spots: lastdata2,
//         isCurved: true,
//
//         barWidth: 1,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//             colors: [
//               Colors.red,
//               Colors.green,
//               Colors.blue,
//
//
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//     ],
//   );
// }
//
// // Modify the getHomeState function to accept a GlobalKey<Home>
