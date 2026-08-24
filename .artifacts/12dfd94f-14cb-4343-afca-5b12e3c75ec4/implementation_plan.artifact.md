# Implementation Plan: Functional RailPulse Application

Transitioning RailPulse from a high-fidelity prototype to a fully functional application with real logic, state management, and simulated real-time data services.

## User Review Required

> [!IMPORTANT]
> This update introduces `flutter_map` for the Interactive Network Map. Ensure you have an active internet connection for map tiles to load.

> [!NOTE]
> All data (Train Status, Delays, Tracking) is currently simulated using internal services, as real-time API keys for Indian Railways are not available in this environment. However, the architecture is "API-ready."

## Proposed Changes

### Core Services Layer
- [NEW] `TrainService`: Handles train search, schedules, and live telemetry simulation.
- [NEW] `BookingService`: Manages NCMC balance and digital ticket persistence using `SharedPreferences`.
- [NEW] `AiInsightService`: Generates predictive delay data based on simulated congestion and historical factors.

### State Management (BLoC)
- [NEW] `BookingBloc`: Manages wallet balance and ticket lifecycle.
- [NEW] `TrackingBloc`: Drives the live movement of the train on the timeline and map.
- [NEW] `SearchBloc`: Handles the origin/destination search logic.

### Features Enhancement
#### Interactive Network Map
- [MODIFY] `MapScreen`: Replace placeholder with `flutter_map`, adding station markers and route polylines.

#### Home Dashboard
- [MODIFY] `RouteSearchCard`: Connect to `SearchBloc` to navigate to real search results.
- [MODIFY] `ActiveTripWidget`: Connect to `TrackingBloc` for live speed and position updates.

#### Digital Pass & Booking
- [MODIFY] `BookingScreen`: Implement "Top Up" and "Fare Payment" logic that updates the NCMC balance.
- [MODIFY] `DigitalQrTicket`: Generate unique ticket IDs using `Uuid`.

#### Live Tracking
- [MODIFY] `LiveTimeline`: Update train position dynamically based on the `TrackingBloc` stream.

## Verification Plan

### Automated Tests
- Run `flutter pub get` to verify new dependencies.
- Unit tests for `BookingService` logic.

### Manual Verification
- Verify NCMC balance updates after a simulated payment.
- Observe the train icon moving smoothly on the `LiveTimeline` in real-time.
- Test the Interactive Map zooming and marker interaction.
