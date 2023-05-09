import 'package:flutter/material.dart';

import '../environment.dart';
import '../partials/invoice_datatable_part.dart';
import '../constants/colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String title1 = 'En cours';
    String title2 = 'Déchargées';

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.red,
            child: TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                    child: Center(
                      child: Text(
                        title1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )),
                Tab(
                    child: Center(
                      child: Text(
                        title2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(child: TabBarView(
            children: [InvoiceDataTablePart(uri: Environment.uri1, received: false), InvoiceDataTablePart(uri: Environment.uri2, received: true)],
          )),
        ],
      ),
    );
  }
}
