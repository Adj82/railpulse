# RailPulse - Dynamic ETA for Indian Railways

RailPulse is the passenger client for SIH 2026 PS 26028. It presents dynamic, station-by-station arrival **ranges** (p10/p50/p90), live position updates, congestion and weather factors, and a forecast cone that widens naturally farther along a journey.

## Run now

The app opens in a polished replay/demo mode by default, so it works without any API keys or a backend:

```powershell
flutter run
```

For a real gateway, switch off demo mode and provide its public base URL:

```powershell
flutter run --dart-define=RAILPULSE_DEMO_MODE=false --dart-define=RAILPULSE_API_URL=https://api.your-domain.in
```

For Android emulators the default URL is `http://10.0.2.2:8080`. Use a LAN/HTTPS URL for physical devices and release builds.

## Integration contract

The API gateway owns authentication, rate limits, caching, and public contracts; the ML service stays private. The app expects:

| Purpose | Gateway contract |
| --- | --- |
| ETA snapshot | `GET /api/v1/trains/{trainNumber}/eta` |
| Live update stream | `WS /ws/live/{trainNumber}` |

`GET /api/v1/trains/12345/eta` response:

```json
{
  "trainNumber": "12345",
  "livePosition": {"lat": 25.44, "lng": 81.85, "lastStationCode": "PRYJ", "lastUpdated": "2026-08-24T14:10:00Z", "currentDelayMinutes": 18},
  "stations": [{"stationCode": "CNB", "stationName": "Kanpur Central", "scheduledArrival": "2026-08-24T16:10:00Z", "p10": "2026-08-24T16:18:00Z", "p50": "2026-08-24T16:28:00Z", "p90": "2026-08-24T16:44:00Z", "congestionIndex": 62, "bottleneckReason": "Preceding train delay in section", "weatherImpact": "Light rain forecast", "sectionalSpeedLimit": 110}]
}
```

Each WebSocket message is a `livePosition` JSON object. A position event should trigger the backend to recompute every remaining station forecast and broadcast the new position. The mobile app reconnects with exponential backoff.

## Production architecture

`Feed adapters (RailRadar today / RTIS-COA tomorrow) -> canonical TrainEvent -> PostgreSQL + TimescaleDB -> shared feature builder -> LightGBM p10/p50/p90 -> gateway + Redis -> Flutter, station board, control-room dashboard`

Keep the same feature builder for training and serving. Model the segment deviation, use chronological evaluation, and retain the schedule-plus-current-delay baseline. Never put source API credentials in this Flutter client.

## Before a live demo

- Register and configure the gateway and WebSocket origin/CORS rules.
- Run the collector, raw-payload archive, dead-man check, and replay harness separately from this app.
- Serve OpenStreetMap tiles with a compliant production tile provider if traffic grows.
- Validate p10 <= p50 <= p90 and show an 80% coverage metric from held-out, chronologically split data.
