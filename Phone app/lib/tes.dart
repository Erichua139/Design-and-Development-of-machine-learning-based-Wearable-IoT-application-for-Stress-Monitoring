import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
class MyApp extends StatefulWidget {

  const MyApp({super.key});
  @override
  State<MyApp> createState() => ScrollableChart();

  // late ZoomPanBehavior _zoomPanBehavior;

}

class ScrollableChart extends State<MyApp> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  String errorMessage = '';
  String errorMessage2 = '';
  List<dynamic> dataArray =[] ;
  List<dynamic> dataArray_hr =[] ;
  List<dynamic> dataArray_last =[] ;
  late ChartSeriesController _chartSeriesController;
  late ChartSeriesController _candlechartSeriesController;
  List<CandleChartData> _hr =[];
  int stress_value = 0;
  String lastdatetime = "";
  String lastrmssd = "";
  String lasthr = "" ;
  String laststatus = "";


  List<ChartData> _data = [];
  // final GlobalKey<ChartSeries> _chartKey = GlobalKey<ChartSeries>();

  @override
  void initState(){
    super.initState();
    fetchDailyMeasurement();
    calculateHR();
    lastmeasurement();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,

    );
    _tooltipBehavior = TooltipBehavior(
        enable: true,

      header: "",

        format: "point.y\npoint.x",

        tooltipPosition: TooltipPosition.pointer,
        color: Colors.lightBlue
    );

  }
  // Example data for the chart
  // final List<double> data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];


  bool _isZoomedIn = false;

  Future<void> fetchDailyMeasurement() async{
    try{
      DateTime now = DateTime.now();
// Get the start of the current day
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
// Get the start of the next day
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('monitoring_data')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      if(querySnapshot.docs.isEmpty)
      {
        setState((){
          errorMessage = 'No measurements recorded for today.';
          _data.clear();
        });
        return;
      }
      _data.clear();
      // Process each document in the querySnapshot
      querySnapshot.docs.forEach((doc) {
        dataArray = doc['data'] as List<dynamic>;

        dataArray.forEach((dataElement) {
          // Extract rmssd and timestamp from the data element
          double rmssd = (dataElement['rmssd'] as num).toDouble();
          Timestamp timestamp = dataElement['timestamp'] as Timestamp;
          DateTime dateTime = timestamp.toDate();
          // double totalHours = dateTime.hour + (dateTime.minute / 60);
          // formattedDateTime = dateTime.toString();
          // Add the data point to the chart data list
          _data.add(ChartData(dateTime, rmssd));

        });
      });
      setState(() {});
    }catch(e){
      print('Error fetching measurements: $e');

    }

  }

  Future<void> calculateHR () async{
  double hr1 = 0, hr2 = 0, hr3 = 0, hr4 = 0;
  int count1 = 0, count2 = 0, count3 = 0, count4 = 0;
  double avg1 =0 , avg2 =0, avg3 =0, avg4 = 0;
  bool status = false;
  try{
    DateTime now = DateTime.now();
// Get the start of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
// Get the start of the next day
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('monitoring_data') // Replace 'your_collection_name' with your actual collection name
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    _hr.clear();
    stress_value=0;
    querySnapshot.docs.forEach((doc) {

      dataArray_hr = doc['data'] as List<dynamic>;
      dataArray_hr.forEach((dataElement) {
        var hr = (dataElement['sdnn']);
        Timestamp timestamp = dataElement['timestamp'] as Timestamp;
        status = dataElement['ml_output'] as bool;
        DateTime dateTime = timestamp.toDate();
        if(hr is num){
        int hour = dateTime.hour;
        print('hour $hour');
        if (hour >= 0 && hour < 6) {
          hr1 += hr;
          count1++;
        } else if (hour >= 6 && hour < 12) {
          hr2 += hr;
          count2++;
        } else if (hour >= 12 && hour < 18) {
          hr3 += hr;
          count3++;
        } else {
          hr4 += hr;
          count4++;
        }}else{
          print('invalid type data');
        }

        if(status)
          {
            stress_value++;
            if(stress_value > 10)
              {
                stress_value = 10;
              }
          }
      });

      // Calculate hourly averages

      if(count1 > 0 ){
        avg1 = hr1 / count1;
      }
      if(count2 > 0)
      { avg2 = hr2 / count2;}
      if(count3 >0)
      {avg3 = hr3 / count3;}
      if(count4 >0 )
      {avg4 = hr4 / count4;}

      _hr.add(CandleChartData("0-6",avg1.toInt()));
      _hr.add(CandleChartData("6-12",avg2.toInt()));
      _hr.add(CandleChartData("12-18",avg3.toInt()));
      _hr.add(CandleChartData("18-24",avg4.toInt()));
      setState(() {});
    });



    setState(() {});
  }catch(e)
    {
      print('error in hr fetching + $e');
    }
  }

  Future<void> lastmeasurement()async{
    Map<List<dynamic>,Timestamp> all_measurements = {};
    List<dynamic> times =[];

    try{
      DateTime now = DateTime.now();
// Get the start of the current day
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
// Get the start of the next day
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('monitoring_data') // Replace 'your_collection_name' with your actual collection name
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

       lastdatetime = "";
       lastrmssd = "";
       lasthr = "" ;
       laststatus = "";
      querySnapshot.docs.forEach((doc) {

        dataArray_last = doc['data'] as List<dynamic>;
        dataArray_last.forEach((dataElement) {
          double hr = (dataElement['sdnn'] as num).toDouble();
          double rmssd = (dataElement['rmssd'] as num).toDouble();
          bool status = dataElement['ml_output'] as bool;
          Timestamp timestamp = dataElement['timestamp'] as Timestamp;

          times.add(hr);
          times.add(rmssd);
          times.add(status);

          all_measurements[times] = timestamp;
          
          times.clear();

          DateTime dateTime = timestamp.toDate();
          String formattedDateTime = DateFormat('MMMM dd, yyyy HH:mm').format(dateTime);

          lastdatetime = formattedDateTime;
          lastrmssd = rmssd.toString();
          lasthr = hr.toString() ;
          if(status)
            {
              laststatus = "Stressed";
            }else{
            laststatus = "Calm" ;
          }


        });

        // Calculate hourly averages
        setState(() {});
      });
      print('lets see ' + lastdatetime + ' ' + lastrmssd+ ' '+ lasthr+' '+laststatus);


    }
        catch(e)
    {
      print('error in lastmeasurement $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 37, 66, 1),

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            errorMessage = ''; // Clear any previous error messages

          });
          await fetchDailyMeasurement();
          await calculateHR();
          await lastmeasurement();
          _chartSeriesController.updateDataSource(
              addedDataIndex: _data.length );
          _candlechartSeriesController.updateDataSource(
            addedDataIndex: _hr.length);

        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),

          children:[ SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20),

              child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children:[
                    Row(
                      children:[

                        Text('Health Record Overview', style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(254, 254, 255,1),
                        fontWeight: FontWeight.bold,
                      ),),
                      ]
                    ),
////////////////////RMSSD Chart/////////////////////////////
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),

                      child: Container(

                      // height: MediaQuery.of(context).size.height /1,
                      width: MediaQuery.of(context).size.width /1.1,
                      decoration: BoxDecoration(
                        color:Color.fromRGBO(57, 64, 95, 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Color.fromRGBO(57, 64, 95, 0.5), width: 2.0)),
                      child: Column(
                        children:[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text('RMSSD',
                              style: TextStyle(color:Color.fromRGBO(254, 254, 255,1),
                              fontSize: 20,

                              ),),
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: Duration(milliseconds: 5000),
                                  message: 'The root mean square of successive differences between normal heartbeats',

                                 decoration: BoxDecoration(
                                   color: Color.fromRGBO(57, 64, 95,1),


                                 ),
                                  child: Icon(
                                    Icons.help_outline,
                                    color: Color.fromRGBO(254, 254, 255,0.8),
                                  ),
                                )

                              ]
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height /4,
                            child: SfCartesianChart(



                            // key: _chartKey,
                            onZooming:(ZoomPanArgs args) {

                              // Detect zoom level and update granularity
                              final visibleRange = args.currentZoomFactor * args.currentZoomPosition;
                              if (visibleRange < 2) {
                                setState(() {
                                  _isZoomedIn = true;
                                });
                              } else {
                                setState(() {
                                  _isZoomedIn = false;
                                });
                              }

                            },
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true,
                              zoomMode: ZoomMode.x,
                              enableDoubleTapZooming: true,
                              enablePanning: true,

                            ),

                            primaryXAxis: DateTimeAxis(

                                majorGridLines: MajorGridLines(width: 0),
                                dateFormat: DateFormat.Hm(),
                                intervalType: DateTimeIntervalType.auto,
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(254, 254, 255,1),
                                  fontSize: 14,
                                ),
                                // interval: 2,
                              enableAutoIntervalOnZooming: true,
                            ),
                              primaryYAxis: NumericAxis(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(254, 254, 255,1),
                                  fontSize: 14,
                                ),
                              ),

                            tooltipBehavior:  _tooltipBehavior,

                            series: <CartesianSeries>[
                              // Initialize line series
                              LineSeries<ChartData, DateTime>(
                                onRendererCreated: (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                dataSource: _data,
                                enableTooltip: true,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                              ),
                            ],
                                                    ),
                          ),],
                      ),
                                        ),
                    ),

                  ////////////////////////BAR CHART FOR SDNN///////////////////////////
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),

                    child:

                    Container(
                      // height:MediaQuery.of(context).size.height /2,
                      decoration: BoxDecoration(
                          color:Color.fromRGBO(57, 64, 95, 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Color.fromRGBO(57, 64, 95, 0.5), width: 2.0)),

                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[

                              Text('SDNN', style: TextStyle(
                                color:Color.fromRGBO(254, 254, 255,1),
                                fontSize: 20,
                              ),),

                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: Duration(milliseconds: 5000),
                                  message: 'The standard deviation of the IBI of normal sinus beats',

                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(57, 64, 95,1),


                                  ),
                                  child: Icon(
                                    Icons.help_outline,
                                    color: Color.fromRGBO(254, 254, 255,0.8),
                                  ),
                                )

                            ],),
                          ),
                          
                          SizedBox(
                            height:MediaQuery.of(context).size.height /5,
                            child: SfCartesianChart(

                              plotAreaBorderWidth: 0,
                                primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(254, 254, 255,1),
                                  fontSize: 14
                                  ),
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                isVisible: false,
                              ),
                              series: <CartesianSeries>[
                                // Renders column chart
                                ColumnSeries<CandleChartData, String>(

                                    dataLabelSettings: DataLabelSettings(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(254, 254, 255,1),
                                        fontSize: 14
                                      ),
                                      isVisible: true,
                                      labelPosition: ChartDataLabelPosition.outside,
                                        labelAlignment: ChartDataLabelAlignment.top                                    // labelPadding: EdgeInsets.symmetric(vertical: 4),
                                      // offset: Offset(0, 30),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  width: 0.5,
                                  onRendererCreated: (ChartSeriesController controllerr) {
                                                    _candlechartSeriesController = controllerr;
                                                    },enableTooltip: true,
                                    dataSource: _hr,
                                    xValueMapper: (CandleChartData d, _) => d.z,
                                    yValueMapper: (CandleChartData d, _) => d.g
                                )
                              ]
                                                    ),
                          ),],
                      ),
                    ),

                  ),

           /////////////////// CHART FOR STRESS////////////////////////////////////
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),

                      child: Container(
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(57, 64, 95, 0.5),
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Color.fromRGBO(57, 64, 95, 0.5), width: 2.0)),

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                Text('Stress Level', style: TextStyle(
                                  color:Color.fromRGBO(254, 254, 255,1),
                                  fontSize: 20,
                                ),),

                                    Tooltip(
                                      triggerMode: TooltipTriggerMode.tap,
                                      showDuration: Duration(milliseconds: 5000),
                                      message: 'This range represents the times you were stressed during today.',

                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(57, 64, 95,1),


                                      ),
                                      child: Icon(
                                        Icons.help_outline,
                                        color: Color.fromRGBO(254, 254, 255,0.8),
                                      ),
                                    )

                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 15.0),

                              child: SizedBox(
                              // height: MediaQuery.of(context).size.height /3,
                              width: MediaQuery.of(context).size.width /0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text('Low ',
                                  style: TextStyle(
                                    color:Color.fromRGBO(254, 254, 255,1),
                                    fontSize: 14,
                                  ),),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /1.7,

                                    child: SfLinearGauge(

                                    showLabels: false,
                                    minimum: 0,
                                      maximum: 10,
                                      barPointers:[
                                        LinearBarPointer(

                                            value: 10,
                                            thickness: 10,
                                            shaderCallback: (bounds) => LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [ Colors.blueAccent, Colors.redAccent])
                                                .createShader(bounds)
                                        )
                                      ],
                                    markerPointers: [
                                    LinearWidgetPointer(

                                    value: stress_value.toDouble(),
                                    child: Container(height: 14, width: 14, color: Color.fromRGBO(
                                        17, 23, 66, 1.0)),
                                                                    ),


                                                    ]),
                                  ),
                                  Text('High', style: TextStyle(
                                    color:Color.fromRGBO(254, 254, 255,1),
                                    fontSize: 14,
                                  ),),
                              ]
                              ),
                                                        ),
                            ),],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),

                      child: Container(
                        width: MediaQuery.of(context).size.width /1,

                        decoration: BoxDecoration(
                            color:Color.fromRGBO(57, 64, 95, 0.5),
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Color.fromRGBO(57, 64, 95, 0.5), width: 2.0)),

                        child: SizedBox(
                          child:Column(
                            children: [
                              Text('Last Measurements',style: TextStyle(
                                color:Color.fromRGBO(254, 254, 255,1),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),

                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text(lastdatetime,style: TextStyle(
                                        color:Color.fromRGBO(254, 254, 255,1),
                                        fontSize: 18,
                                      ),),
                                      Text(lastrmssd,style: TextStyle(
                                        color:Color.fromRGBO(254, 254, 255,1),
                                        fontSize: 18,
                                      ),),
                                      Text(lasthr,style: TextStyle(
                                        color:Color.fromRGBO(254, 254, 255,1),
                                        fontSize: 18,
                                      ),),
                                      Text(laststatus,style: TextStyle(
                                        color:Color.fromRGBO(254, 254, 255,1),
                                        fontSize: 18,
                                      ),),
                                    ],
                                  ),],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ),

                ///////////////heart rate chart////////////

              ),
            ),
          ),]
        ),
      ),
    );
  }
}

  class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double? y;
}
class CandleChartData {
  CandleChartData(this.z, this.g);
  final String z;
  final int g;
}
