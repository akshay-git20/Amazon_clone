import 'package:amazon/common/widgets/loader.dart';
import 'package:amazon/features/admin/models/sales.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:amazon/features/admin/widgets/category_products_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalEarnings;
  List<Sales>? sales;
  List<BarChartGroupData> barChartData = [];

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings() async {
    var earnigsData = await adminServices.getEarnings(context: context);
    totalEarnings = earnigsData['totalEarnings'];
    sales = earnigsData['sales'];
    barChartData = sales!.map(((e) {
      return BarChartGroupData(
        x: e.earnings,
        barsSpace: 2,
        barRods: [
          BarChartRodData(fromY: 0, color: Colors.blue, width: 16, toY: 20.0),
        ],
        groupVertically: true,
      );
    })).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return totalEarnings == null || sales == null
        ? const Loader()
        : Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Total Earnings:  \$$totalEarnings',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              BarChartSample1(
                sales: sales!,
              )
            ],
          );
  }
}
