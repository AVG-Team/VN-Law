// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/dashboard_screen.dart';

import '../../../utils/nav_utail.dart';
import '../screens/app_flow/navigation_bar/custom_bottom_navBar.dart';
import '../utils/app_color.dart';

class AppPermissionPage extends StatelessWidget {
  final String? appThemeId;
  const AppPermissionPage({super.key,this.appThemeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.colorPrimary.withOpacity(0.7),
              AppColors.colorPrimary
            ])),
        child: ListView(
          children: [
            const SizedBox(

              height: 32.0,
            ),
            const Text(
              'HRM App collects location data to enable below features even '
                  'when the app is closed or not in use',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            const SizedBox(

              height: 32.0,
            ),
            const ListTile(
              leading: Icon(
                Icons.add_location,
                color: Colors.white,
                size: 30.0,
              ),
              title: Text(
                '1.Location data to enable  employee attendance and visit '
                    'feature',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const ListTile(
              leading: Icon(
                Icons.local_gas_station_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              title: Text(
                '2.Find distance between employee and office position for '
                    'accurate daily attendance',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const ListTile(
              leading: Icon(
                Icons.local_gas_station_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              title: Text(
                '3.Allows the employer to track employee, when his/her '
                    'employee is on the way to field job',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(

              height: 16.0,
            ),
            const ListTile(
              leading: Icon(
                Icons.local_gas_station_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              title: Text(
                '4.Increase the efficiency and smoothness of the attendance',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(

              height: 16.0,
            ),
            const ListTile(
              title: Text(
                'You can change this later in the settings app',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                NavUtil.replaceScreen(context,  const DashboardScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text("next",
                  style: TextStyle(
                    color: AppColors.colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}