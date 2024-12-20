import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/custom_timer/custom_timer_countdown_bloc.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  final CustomTimerCountdownBloc timerBloc =
      CustomTimerCountdownBloc(ticker: const Ticker());
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  void _pauseTimer() {
    timerBloc.add(const TimerCountdownPaused());
  }

  void _resumeTimer() {
    timerBloc.add(const TimerCountdownResumed());
  }

  void _resetTimer() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final totalDuration = (minutes * 60) + seconds;

    timerBloc.add(TimerCountdownReset(duration: totalDuration));
  }

  void _stopTimer() {
    timerBloc.add(const TimerCountdownStopped());
  }

  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    timerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => timerBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Countdown Timer'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer Display Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: BlocBuilder<CustomTimerCountdownBloc, CustomTimerCountdownState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Text(
                                state is TimerRunInProgress
                                    ? 'TIME REMAINING'
                                    : state is TimerRunPause
                                        ? 'PAUSED'
                                        : state is TimerRunComplete
                                            ? 'COMPLETED'
                                            : 'SET TIMER',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state is TimerRunInProgress
                                    ? formatDuration(state.duration)
                                    : state is TimerRunPause
                                        ? formatDuration(state.duration)
                                        : state is TimerRunComplete
                                            ? '00:00'
                                            : '--:--',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: state is TimerRunComplete
                                      ? Colors.green
                                      : state is TimerRunPause
                                          ? Colors.orange
                                          : Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Input Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Set Duration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeInput(
                                controller: _minutesController,
                                label: 'Minutes',
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildTimeInput(
                                controller: _secondsController,
                                label: 'Seconds',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Controls Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            icon: Icons.play_circle_filled,
                            color: Colors.green,
                            label: 'Start',
                            onPressed: () {
                              final minutes = int.tryParse(_minutesController.text) ?? 0;
                              final seconds = int.tryParse(_secondsController.text) ?? 0;
                              final totalDuration = (minutes * 60) + seconds;

                              if (totalDuration > 0) {
                                timerBloc.add(TimerCountdownStarted(duration: totalDuration));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a valid duration'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                          _buildControlButton(
                            icon: Icons.pause,
                            color: Colors.orange,
                            label: 'Pause',
                            onPressed: _pauseTimer,
                          ),
                          _buildControlButton(
                            icon: Icons.play_arrow,
                            color: Colors.blue,
                            label: 'Resume',
                            onPressed: _resumeTimer,
                          ),
                          _buildControlButton(
                            icon: Icons.replay,
                            color: Colors.purple,
                            label: 'Reset',
                            onPressed: _resetTimer,
                          ),
                          _buildControlButton(
                            icon: Icons.stop_circle_outlined,
                            color: Colors.red,
                            label: 'Stop',
                            onPressed: _stopTimer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInput({
    required TextEditingController controller,
    required String label,
  }) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}