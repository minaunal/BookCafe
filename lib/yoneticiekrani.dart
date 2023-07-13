import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'moderator.dart';

class Yonetici extends StatefulWidget {
  const Yonetici({super.key});

  @override
  State<Yonetici> createState() => _YoneticiState();
}

class _YoneticiState extends State<Yonetici> {
  Map<String, double> dataMap = {
    "full": 20,
    "empty": 180,
  };

  List<Color> colorList = [
    const Color(0xff1fde25),
    const Color(0xff000000),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: new EdgeInsets.only(top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PieChart(
              dataMap: dataMap,
              colorList: colorList,
              chartRadius: MediaQuery.of(context).size.width / 2,
              centerText: "Occupancy",
              chartValuesOptions: ChartValuesOptions(
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValuesInPercentage: true,
                chartValueStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              legendOptions: LegendOptions(
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontSize:
                      15, // Veri isimlerinin boyutunu burada ayarlayabilirsiniz
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(thickness: 2.0,),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Moderator()),
                );
              },
              child: Icon(
                Icons.table_restaurant_sharp,
                size: 100,
                color: Colors.black,
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Divider(thickness: 2.0,),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.attach_money,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(thickness: 2.0,),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.receipt,
              size: 100,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
