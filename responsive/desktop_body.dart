import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/my_box.dart';
import '../utils/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
    const DesktopScaffold({Key? key}) : super(key: key);

    @override
    State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: defaultBackgroundColor,
            appBar: myAppBar,
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // open drawer
                        my_Drawer,

                        // First hal
                        Expanded(
                            flex: 2,
                            child: column(
                                aspectRatio: 4,
                                child: SizedBox(
                                    width: double.infinity,
                                    child: GridView.builder(
                                        itemCount: 4,
                                        gridDelegate:
                                           const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4),
                                        itemBuilder: (context, index) {
                                            return const MyBox();
                                        },
                                    ), // GridView.builder
                                ), // SizedBox
                            ), // aspectRatio

                            // List of previous days    
                            Expanded(
                                child: ListView.builder(
                                    itemCount: 7,
                                    itemBuilder: (context, index) {
                                        return const MyTile();
                                    },   
                                ), // ListView.builder
                            ), // Expanded
                        ),
                    ],
                
                ), // Column
            ), // Padding
        ); // Scaffold
    }
}