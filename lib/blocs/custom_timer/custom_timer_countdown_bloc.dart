// custom_timer_countdown_bloc.dart
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_timer_countdown_event.dart';
part 'custom_timer_countdown_state.dart';

class CustomTimerCountdownBloc
    extends Bloc<CustomTimerCountdownEvent, CustomTimerCountdownState> {
  CustomTimerCountdownBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(0)) {
    on<TimerCountdownStarted>(_onStarted);
    on<TimerCountdownPaused>(_onPaused);
    on<TimerCountdownResumed>(_onResumed);
    on<TimerCountdownReset>(_onReset);
    on<TimerCountdownStopped>(_onStopped);
    on<_TimerCountdownTicked>(_onTicked);
  }

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(
      TimerCountdownStarted event, Emitter<CustomTimerCountdownState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerCountdownTicked(duration: duration)));
  }

  void _onPaused(
      TimerCountdownPaused event, Emitter<CustomTimerCountdownState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(
      TimerCountdownResumed event, Emitter<CustomTimerCountdownState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(
      TimerCountdownReset event, Emitter<CustomTimerCountdownState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(event.duration));
  }

  void _onStopped(
      TimerCountdownStopped event, Emitter<CustomTimerCountdownState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerRunComplete());
  }

  void _onTicked(
      _TimerCountdownTicked event, Emitter<CustomTimerCountdownState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }
}

class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}