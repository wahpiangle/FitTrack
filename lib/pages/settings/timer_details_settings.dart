import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/layout/top_nav_bar.dart';
import 'package:group_project/pages/workout/components/timer/components/time_picker.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:provider/provider.dart';

class TimerDetailsSettings extends StatelessWidget {
  const TimerDetailsSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(
        pageIndex: 0,
        title: 'Timer Details',
        user: null,
        showBackButton: true,
      ),
      body: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<RestTimerProvider, CustomTimerProvider>(
          builder: (context, restTimerProvider, customTimerProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                buildMiniTitle('Rest Timer'),
                const SizedBox(height: 16.0),
                buildContainerWithSwitch(
                  context: context,
                  title: 'Rest Timer',
                  value: restTimerProvider.isRestTimerEnabled,
                  onChanged: (value) {
                    if (value) {
                      restTimerProvider.startRestTimer(context);
                    } else {
                      restTimerProvider.stopRestTimer();
                    }
                    restTimerProvider.toggleRestTimer(value);
                  },
                ),
                const SizedBox(height: 16.0),
                buildContainerWithDuration(
                  context: context,
                  title: 'Rest Duration',
                  durationText: '${restTimerProvider.restTimerMinutes} min ${restTimerProvider.restTimerSeconds} sec',
                  onTap: () async {
                    await _showScrollRestPicker(context, restTimerProvider);
                  },
                ),
                const SizedBox(height: 16.0),
                buildContainerWithDropdown(
                  context: context,
                  title: 'Rest Interval',
                  value: restTimerProvider.selectedTimeInterval,
                  onChanged: (value) async {
                    if (value != null) {
                      restTimerProvider.setSelectedTimeInterval(value);
                      restTimerProvider.notifySelectedIntervalChanged();
                    }
                  },
                ),
                const SizedBox(height: 40.0),
                buildMiniTitle('Custom Timer'),
                const SizedBox(height: 16.0),
                buildContainerWithDropdown(
                  context: context,
                  title: 'Custom Interval',
                  value: customTimerProvider.selectedTimeInterval,
                  onChanged: (value) async {
                    if (value != null) {
                      customTimerProvider.setSelectedTimeInterval(value);
                      customTimerProvider.notifySelectedIntervalChanged();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMiniTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Add left padding
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildContainerWithSwitch({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColours.secondaryDark,
            activeColor: const Color(0xFFE1F0CF),
            inactiveThumbColor: const Color(0xFFC1C1C1),
            inactiveTrackColor: const Color(0xFF4D4D4D),
          ),
        ],
      ),
    );
  }

  //Rest Duration Item
  Widget buildContainerWithDuration({
    required BuildContext context,
    required String title,
    required String durationText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              durationText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerWithDropdown({
    required BuildContext context,
    required String title,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<int>(
            value: value,
            onChanged: onChanged,
            items: const [
              DropdownMenuItem<int>(
                value: 5,
                child: Text('5 sec'),
              ),
              DropdownMenuItem<int>(
                value: 10,
                child: Text('10 sec'),
              ),
              DropdownMenuItem<int>(
                value: 30,
                child: Text('30 sec'),
              ),
              DropdownMenuItem<int>(
                value: 60,
                child: Text('1 min'),
              ),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            underline: Container(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            elevation: 8,
            dropdownColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }

  Future<void> _showScrollRestPicker(
      BuildContext context, RestTimerProvider restTimerProvider) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: TimePicker(restTimerProvider: restTimerProvider),
        );
      },
    );
  }
}
