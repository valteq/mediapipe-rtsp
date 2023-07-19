# mediapipe_rtsp

## Diagram
![AI Data Flow@2x (2)](https://github.com/neilvaltec/mediapipe-rtsp/assets/133841195/fcab5ab2-6fa7-49b9-982f-2e2ee9f80930)

## Steps
1. First, run container no.1
```
docker run -p 8554:8554 neilvaltec/drone_camera_rtsp_simulator:0.0.2
```

2. Open another terminal, run container no.2
```
docker run -it --network=container:${container_no1_id} neilvaltec/mediapipe_rtsp:0.0.3 bash
```

3. Inside container no.2, run
```
python /mediapipe_rtsp/object_detection/object_detector_rtsp_input/detect.py --model=/mediapipe_rtsp/object_detection/models/efficientdet_lite2_light.tflite
```

4. Finally, on your mac/windows/ubuntu, open another terminal (third one), check the objection result
```
vlc rtsp://localhost:8554/mediapipe_output
```

5. You can check the the rtsp input of mediapipe as well
```
vlc rtsp://localhost:8554/drone_camera
```

## Notes
1. Live stream mediapipe is running using async. So if mediapipe is not able to catch up with the original FPS, it'll drop/skip the inference for that time. From the link "To lower the overall latency, object detector may drop the input images if needed. In other words, it's not guaranteed to have output per input image."
2. Disabling detector makes the RTSP smoother.
