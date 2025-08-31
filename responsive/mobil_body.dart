import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/my_box.dart';
import '../utils/my_tile.dart';


class MobileBody extends StatelessWidget {
    const MobieScaffold({Key? key}) : super(key: key); 

    @override
    State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: defaultBackgroundColor,
            appBar: myAppBar,
            drawer: myDrawer,
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: [

                        aspectRatio(
                            aspectRatio: 1,
                            child: SizedBox(
                                width: double.infinity,
                                child: GridView.builder(
                                    itemCount: 4,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                        return const MyBox();
                                    },
                                ), // GridView.builder
                            ), // SizedBox
                        ), // aspectRatio


                        // List of previous days
                        Expanded(
                            child: ListView.builder(
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                    return const MyTile();
                                },   
                            ), // ListView.builder
                        ), // Expanded
                    ],
                ), // Column
            ), // Padding
        ); // Scaffold
    }
}