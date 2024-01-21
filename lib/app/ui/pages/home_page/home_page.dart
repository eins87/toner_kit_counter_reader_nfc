import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/main/main_layout.dart';

import '../../../controllers/home/home_controller.dart';
import '../../utils/utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = Utils.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Get.toNamed('about'),
              icon: const Icon(Icons.info))
        ],
      ),
      body: MainLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: screenWidth / 2,
                  height: screenWidth / 2,
                  child: Obx(
                    () => Center(
                      child: SfRadialGauge(
                        animationDuration: 2000,
                        title: const GaugeTitle(text: 'Toner Capasity'),
                        axes: [
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: [
                              GaugeRange(
                                startValue: 0,
                                endValue: controller.percentage.value,
                                color: controller.colorTypeBackground.value,
                              ),
                            ],
                            pointers: [
                              MarkerPointer(
                                value: controller.percentage.value,
                                enableAnimation: true,
                                color: const Color.fromRGBO(255, 224, 130, 1),
                                elevation: 10,
                              ),
                            ],
                            annotations: [
                              GaugeAnnotation(
                                widget: Text(
                                  '${controller.percentage.value}',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => Container(
                        width: screenWidth / 2.3,
                        height: screenWidth / 2.3,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: controller.colorTypeBackground.value,
                          border: Border.all(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            width: 5,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8)),
                            Text(
                              controller.catridTypeLetter.value,
                              style: TextStyle(
                                fontSize: (screenWidth / 2.3) * 0.12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 8.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              controller.colorTypeLetter.value,
                              style: TextStyle(
                                fontSize: (screenWidth / 2.3) * 0.58,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 20.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // label
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chip ID'),
                          Text('Type'),
                          Text('Serial Number'),
                          Text('Capasity'),
                          Text('Used'),
                        ],
                      ),
                      const VerticalDivider(),
                      // value
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.chipID.value),
                            Text(controller.tonerType.value),
                            Text(controller.serialNumber.value),
                            Text('${controller.capacity.value}'),
                            Text('${controller.used.value}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ElevatedButton.icon(
                //   onPressed: () => {print('write button is clicked')},
                //   icon: const Icon(Icons.app_registration_outlined),
                //   label: const Text('Write'),
                //   style: ElevatedButton.styleFrom(
                //     elevation: 5,
                //     shape: const RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(20),
                //       ),
                //     ),
                //   ),
                // ),
                ElevatedButton.icon(
                  onPressed: () => {controller.startSession(context: context)},
                  icon: const Icon(Icons.read_more_outlined),
                  label: const Text('Read'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.clearAdditionalData(),
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clea'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => Text('${controller.getAdditionalData()}')),
          ],
        ),
      ),
    );
  }
}

class TagReadModel {}
