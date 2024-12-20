# Countdown Timer App

## Overview

The **Countdown Timer App** is a Flutter application that provides a customizable countdown timer with essential features such as starting, pausing, resuming, resetting, and stopping the timer. Users can specify the timer duration in minutes and seconds and interact with the timer using an intuitive UI. This app is built using the **Bloc (Business Logic Component)** architecture, ensuring clean separation of concerns and scalability.

---

## Features

1. **Customizable Timer Duration**:
   - Users can enter the desired duration in the format MM:SS.
2. **Countdown Timer Display**:
   - The remaining time is displayed dynamically in MM:SS format.
3. **Pause and Resume**:
   - Users can pause and resume the timer.
4. **Reset Timer**:
   - Reset the timer to a new duration or the original input.
5. **Stop Timer**:
   - Immediately stop the timer.
6. **Responsive UI**:
   - Buttons and inputs are laid out dynamically to adjust to different screen sizes.

---

## Architecture

The app is built using the **Bloc Architecture**, which follows the principles of reactive programming. This ensures a clean separation of UI, business logic, and state management.

### Key Components

1. **Bloc**:
   - `CustomTimerCountdownBloc` manages the state and logic of the countdown timer.
2. **Events**:
   - Define user actions and system triggers for the timer.
3. **States**:
   - Represent the various states of the timer (e.g., initial, running, paused, complete).

---

## File Structure

```text
lib/
├── blocs
│   └── custom_timer
│       ├── custom_timer_countdown_bloc.dart    # Main Bloc class and Ticker logic
│       ├── custom_timer_countdown_event.dart   # Timer event definitions
│       └── custom_timer_countdown_state.dart   # Timer state definitions
├── main.dart
└── widgets
        └── timer_widget.dart  # UI implementation
```

---

## How It Works

### Timer Logic

The timer logic is encapsulated in the `CustomTimerCountdownBloc` class. It uses a `Ticker` class to emit a stream of tick events, which drive the countdown behavior.

#### Ticker

The `Ticker` class emits a stream of integers at 1-second intervals, counting down from the given duration to 0:

```dart
Stream<int> tick({required int ticks}) {
  return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
      .take(ticks);
}
```

#### Bloc

The `CustomTimerCountdownBloc` listens to user actions and updates the state accordingly:

1. **Start Timer**:
   - Begins the countdown and listens for ticks.
   - Example:

     ```dart
     void _onStarted(TimerCountdownStarted event, Emitter<CustomTimerCountdownState> emit) {
       emit(TimerRunInProgress(event.duration));
       _tickerSubscription?.cancel();
       _tickerSubscription = _ticker
           .tick(ticks: event.duration)
           .listen((duration) => add(_TimerCountdownTicked(duration: duration)));
     }
     ```

2. **Pause Timer**:
   - Pauses the stream of ticks.

3. **Resume Timer**:
   - Resumes the stream of ticks.

4. **Reset Timer**:
   - Cancels the current timer and sets a new duration.

5. **Stop Timer**:
   - Cancels the timer and transitions to the `TimerRunComplete` state.

### States

The timer has the following states:

- `TimerInitial`: Represents the initial state with no active timer.
- `TimerRunInProgress`: Represents the active countdown state.
- `TimerRunPause`: Represents a paused timer.
- `TimerRunComplete`: Represents a completed timer.

### Events

User actions are represented as events:

- `TimerCountdownStarted`: Starts the timer with a specified duration.
- `TimerCountdownPaused`: Pauses the timer.
- `TimerCountdownResumed`: Resumes a paused timer.
- `TimerCountdownReset`: Resets the timer to a specified duration.
- `TimerCountdownStopped`: Stops the timer completely.

---

## UI Details

The UI is implemented in `timer_widget.dart` and includes:

1. **Input Fields**:
   - Two text fields for entering the timer duration in minutes and seconds.

2. **Countdown Display**:
   - Dynamically shows the remaining time in MM:SS format.

3. **Control Buttons**:
   - **Start Timer**: Starts the countdown.
   - **Pause**: Pauses the countdown.
   - **Resume**: Resumes a paused countdown.
   - **Reset**: Resets the countdown to the input duration.
   - **Stop**: Stops the timer.

4. **Responsive Layout**:
   - Buttons are arranged dynamically for flexibility.

---

## Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:

   ```bash
   cd countdown_timer_app
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

---

## Usage

1. Enter the desired duration in the **MM** and **SS** fields.
2. Click **Start Timer** to begin the countdown.
3. Use the **Pause**, **Resume**, **Reset**, and **Stop** buttons to control the timer.

---

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch and create a pull request.

---
