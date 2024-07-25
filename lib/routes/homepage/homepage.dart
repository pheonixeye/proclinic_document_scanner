import 'package:flutter/material.dart';
import 'package:proclinic_document_scanner/routes/homepage/pages/find_patients.dart';
import 'package:proclinic_document_scanner/routes/homepage/pages/today_patients.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final n = DateTime.now();
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProClinic Scanner"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Today\n${n.day}-${n.month}-${n.year}',
                textAlign: TextAlign.center,
              ),
            ),
            const Tab(
              text: 'Find',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TodayPatients(),
          FindPatients(),
        ],
      ),
    );
  }
}
