import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.wifi_off,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "You Are Offline , Some Features Will Be Limitied ",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            );
  }
}