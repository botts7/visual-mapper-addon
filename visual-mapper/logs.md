[2026-01-10 06:37:18] INFO - [FlowScheduler] Pausing periodic scheduling
[2026-01-10 06:37:18] INFO - [FlowScheduler] Periodic scheduling paused
INFO:     192.168.86.150:53447 - "POST /api/scheduler/pause HTTP/1.1" 200 OK
INFO:     192.168.86.150:53285 - "GET /api/flows/192.168.86.2%3A46747/flow_192_168_86_2_46747_1768026314718 HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO -   Executing: Launch com.byd.bydautolink
[2026-01-10 06:37:18] INFO -   App already on correct screen: com.bydautolink.module_homepage.HomeTabActivity
[2026-01-10 06:37:18] INFO -   Executing: Capture sensor: Cabin Temperature
INFO:     192.168.86.150:53285 - "GET /api/adb/devices HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO - [FlowScheduler] Cancelled 1 queued flows for 192.168.86.2:46747 (wizard opened)
[2026-01-10 06:37:18] INFO - [API] Wizard active for device(s): ['192.168.86.2:46747'] (cancelled 1 queued flows)
INFO:     192.168.86.150:53285 - "POST /api/wizard/active/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:53285 - "GET /api/device/192.168.86.2%3A46747/unlock-status HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:53285 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO - [API] Checking lock status for 192.168.86.2:46747
INFO:     192.168.86.150:53285 - "GET /api/adb/lock-status/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:18] WARNING - [FlowScheduler] Already paused
INFO:     192.168.86.150:53285 - "POST /api/scheduler/pause HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO - [API] Getting current screen info for 192.168.86.2:46747
[2026-01-10 06:37:18] INFO - [IconBackgroundFetcher] Queued: com.byd.bydautolink (queue size: 1)
INFO:     192.168.86.150:53038 - "GET /api/adb/app-icon/192.168.86.2%3A46747/com.byd.bydautolink HTTP/1.1" 200 OK
[2026-01-10 06:37:18] INFO - [SensorUpdater] Paused sensor updates for 192.168.86.2:46747
[2026-01-10 06:37:18] INFO - [API] Paused sensor updates for 192.168.86.2:46747
INFO:     192.168.86.150:53285 - "POST /api/sensors/pause/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     ('192.168.86.150', 56396) - "WebSocket /api/ws/stream-mjpeg/192.168.86.2%3A46747?quality=medium" [accepted]
[2026-01-10 06:37:18] INFO - [WS-MJPEG] Client connected for device: 192.168.86.2:46747, quality: medium (target 12 FPS)
INFO:     connection open
[2026-01-10 06:37:18] INFO - [WS-MJPEG] Sent initial config with default dimensions: 1080x1920
[2026-01-10 06:37:18] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:18] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:53285 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
INFO:     192.168.86.150:53447 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:19] INFO - [API] Capturing full screenshot from 192.168.86.2:46747
[2026-01-10 06:37:20] INFO - [WS-MJPEG] Frame 1: 24623 bytes JPEG, 1493ms capture, quality=medium
[2026-01-10 06:37:22] INFO - [API] Got 115 elements
INFO:     192.168.86.150:53038 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:23] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:53038 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:23] WARNING - [WS-MJPEG] Frame 2: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:23] INFO - [API] Full screenshot captured: 800448 bytes, 115 UI elements
INFO:     192.168.86.150:62352 - "POST /api/adb/screenshot HTTP/1.1" 200 OK
[2026-01-10 06:37:23] INFO - [API] Getting current screen info for 192.168.86.2:46747
[2026-01-10 06:37:23] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:53038 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:24] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:26] INFO -   Smart detection for Cabin Temperature: resource_id (confidence: 100%)
[2026-01-10 06:37:26] INFO - [SensorManager] Saved 6 sensors for 192.168.86.2:46747
[2026-01-10 06:37:26] INFO - [SensorManager] Updated sensor 192_168_86_2_46747_sensor_71a9626c
[2026-01-10 06:37:26] INFO -   Sensors captured: 1
[2026-01-10 06:37:26] INFO -   Executing: Tap content_group
[2026-01-10 06:37:26] INFO -   [Tap] Resolved element via path (confidence=0.95) -> (308, 1612)
[2026-01-10 06:37:26] WARNING - [WS-MJPEG] Frame 3: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:27] INFO -   Activity com.bydautolink.module_car_air.airconditioner.AirConditionerActivity detected after tap
[2026-01-10 06:37:27] INFO -   Executing: Capture sensor: Cabin Temp
[2026-01-10 06:37:28] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:53038 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:29] WARNING - [WS-MJPEG] Frame 4: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:30] INFO - [API] Got 53 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:30] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:30] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:30] INFO - [API] Got 53 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:31] INFO - [API] Getting current screen info for 192.168.86.2:46747
[2026-01-10 06:37:31] INFO -   Smart detection for Cabin Temp: resource_id (confidence: 100%)
[2026-01-10 06:37:31] INFO - [SensorManager] Saved 6 sensors for 192.168.86.2:46747
[2026-01-10 06:37:31] INFO - [SensorManager] Updated sensor 192_168_86_2_46747_sensor_35cd8a80
[2026-01-10 06:37:31] INFO -   Sensors captured: 1
[2026-01-10 06:37:31] INFO - [FlowExecutor] Flow flow_192_168_86_2_46747_1768003064520 completed successfully
[2026-01-10 06:37:31] INFO -   [Backtrack] Navigating back 1 screen(s) to starting position
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:32] INFO -   [Backtrack] Successfully returned to starting screen
[2026-01-10 06:37:32] INFO - [FlowManager] Saved 3 flows to /config/visual_mapper/flows/flows_192_168_86_2_46747.json
[2026-01-10 06:37:32] INFO - [FlowManager] Updated flow flow_192_168_86_2_46747_1768003064520
[2026-01-10 06:37:32] INFO -   [Headless] Skipping auto-sleep - wizard active on device 192.168.86.2:46747
[2026-01-10 06:37:32] INFO - [FlowExecutionHistory] Logged execution 51ca502c-299a-4f75-b781-2056378cb9ae: SUCCESS (4/4 steps, 14657ms)
[2026-01-10 06:37:32] INFO - [FlowExecutor] Flow flow_192_168_86_2_46747_1768003064520 finished in 14657ms
[2026-01-10 06:37:32] INFO -   Steps executed: 4/4
[2026-01-10 06:37:32] INFO -   Sensors captured: 2
[2026-01-10 06:37:33] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:33] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:53038 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:37] INFO - [API] Got 115 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:37] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:37] WARNING - [WS-MJPEG] Frame 9: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:38] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:39] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:42] INFO - [API] Got 115 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:42] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:42] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:42] INFO - [API] Got 115 elements
[2026-01-10 06:37:43] WARNING - [WS-MJPEG] Frame 12: Capture timeout (>3.0s), skipping
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:43] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:43] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:43] INFO - [API] Swipe (1188,1769) -> (1175,1373) on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/swipe HTTP/1.1" 200 OK
[2026-01-10 06:37:43] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:44] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:47] INFO - [API] Got 131 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:47] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:47] WARNING - [WS-MJPEG] Frame 15: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:48] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:53] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:37:53] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:54] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:54] INFO - [API] Tap at (1155, 1357) on 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/adb/tap HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "GET /api/device/192.168.86.2%3A46747/unlock-status HTTP/1.1" 200 OK
[2026-01-10 06:37:55] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:37:55] INFO - [API] Checking lock status for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/lock-status/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:37:56] INFO - [API] Capturing full screenshot from 192.168.86.2:46747
[2026-01-10 06:37:57] WARNING - [WS-MJPEG] Frame 24: Capture timeout (>3.0s), skipping
[2026-01-10 06:37:58] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62368 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:38:00] INFO - [API] Got 46 elements
[2026-01-10 06:38:00] WARNING - [WS-MJPEG] Frame 25: Capture timeout (>3.0s), skipping
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:00] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:00] INFO - [API] Full screenshot captured: 287390 bytes, 46 UI elements
INFO:     192.168.86.150:52490 - "POST /api/adb/screenshot HTTP/1.1" 200 OK
[2026-01-10 06:38:00] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:00] INFO - [API] Got 46 elements
INFO:     192.168.86.150:52490 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:01] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:01] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:03] INFO - [API] Got 46 elements
INFO:     192.168.86.150:52490 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:03] INFO - [API] Getting current screen info for 192.168.86.2:46747
[2026-01-10 06:38:03] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:38:06] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:08] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:38:09] INFO - [API] Got 46 elements
INFO:     192.168.86.150:52490 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:09] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:09] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:09] INFO - [API] Got 46 elements
INFO:     192.168.86.150:52490 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:10] INFO - [API] Analyzing UI elements for sensor suggestions on 192.168.86.2:46747
[2026-01-10 06:38:10] INFO - [SensorSuggester] Analyzing 46 UI elements
[2026-01-10 06:38:10] INFO - [SensorSuggester] Generated 11 sensor suggestions from 46 elements
[2026-01-10 06:38:10] INFO - [SensorSuggester] Stats: analyzed=43, skipped_no_text=3, skipped_duplicate=0
[2026-01-10 06:38:10] INFO - [API] Generated 11 sensor suggestions for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/devices/suggest-sensors HTTP/1.1" 200 OK
[2026-01-10 06:38:10] INFO - [API] Getting current screen info for 192.168.86.2:46747
[2026-01-10 06:38:10] INFO - [API] Analyzing UI elements for action suggestions on 192.168.86.2:46747
[2026-01-10 06:38:10] INFO - [ActionSuggester] Analyzing 46 UI elements
[2026-01-10 06:38:10] INFO - [ActionSuggester] Generated 1 action suggestions from 46 elements
[2026-01-10 06:38:10] INFO - [ActionSuggester] Stats: analyzed=16, skipped_non_interactive=5, skipped_duplicate=0, skipped_sensor_like=8, skipped_wrapper=17
[2026-01-10 06:38:10] INFO - [API] Generated 1 action suggestions for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/devices/suggest-actions HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "POST /api/test/extract HTTP/1.1" 200 OK
[2026-01-10 06:38:13] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:14] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "POST /api/test/extract HTTP/1.1" 200 OK
[2026-01-10 06:38:16] INFO - [API] Got 46 elements
INFO:     192.168.86.150:62352 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "POST /api/test/extract HTTP/1.1" 200 OK
[2026-01-10 06:38:16] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/test/extract HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "POST /api/test/extract HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "POST /api/test/extract HTTP/1.1" 200 OK
[2026-01-10 06:38:18] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:18] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "POST /api/test/extract HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "POST /api/test/extract HTTP/1.1" 200 OK
[2026-01-10 06:38:21] INFO - [API] Got 46 elements
INFO:     192.168.86.150:52490 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:22] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:52490 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:52490 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:23] ERROR - ================================================================================
[2026-01-10 06:38:23] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:23] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:23] ERROR - [VALIDATION ERROR] Method: POST
[2026-01-10 06:38:23] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:62352 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
INFO:     192.168.86.150:62352 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:24] ERROR - ================================================================================
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] Method: POST
INFO:     192.168.86.150:57168 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:24] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:24] ERROR - ================================================================================
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:24] ERROR - [VALIDATION ERROR] Method: POST
INFO:     192.168.86.150:50862 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:25] ERROR - ================================================================================
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] Method: POST
INFO:     192.168.86.150:51278 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:25] ERROR - ================================================================================
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:25] ERROR - [VALIDATION ERROR] Method: POST
[2026-01-10 06:38:27] INFO - [API] Got 46 elements
INFO:     192.168.86.150:65152 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:27] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:65152 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:28] INFO - [API] Key event 224 on 192.168.86.2:46747
INFO:     192.168.86.150:65152 - "POST /api/adb/keyevent HTTP/1.1" 200 OK
[2026-01-10 06:38:30] INFO - [API] Getting elements only from 192.168.86.2:46747
[2026-01-10 06:38:33] INFO - [API] Got 46 elements
INFO:     192.168.86.150:65152 - "GET /api/adb/elements/192.168.86.2%3A46747 HTTP/1.1" 200 OK
INFO:     192.168.86.150:65152 - "POST /api/dedup/sensors/check HTTP/1.1" 200 OK
[2026-01-10 06:38:33] INFO - [API] Getting current screen info for 192.168.86.2:46747
INFO:     192.168.86.150:65152 - "GET /api/adb/screen/current/192.168.86.2%3A46747 HTTP/1.1" 200 OK
[2026-01-10 06:38:33] ERROR - ================================================================================
[2026-01-10 06:38:33] ERROR - [VALIDATION ERROR] Request validation failed
[2026-01-10 06:38:33] ERROR - [VALIDATION ERROR] URL: http://192.168.86.68:8080/api/sensors
[2026-01-10 06:38:33] ERROR - [VALIDATION ERROR] Method: POST
[2026-01-10 06:38:38] INFO - [WS-MJPEG] Frame 60: 16640 bytes JPEG, 571ms capture, quality=medium
INFO:     connection closed
[2026-01-10 06:38:55] WARNING - [WS-MJPEG] Capture error: received 1005 (no status received [internal]); then sent 1005 (no status received [internal])
[2026-01-10 06:38:55] ERROR - [WS-MJPEG] Connection error: received 1005 (no status received [internal]); then sent 1005 (no status received [internal])
[2026-01-10 06:38:55] INFO - [WS-MJPEG] Stream ended for device: 192.168.86.2:46747, frames sent: 87