# mediapipe_rtsp

## 

First, run container no.1
```
docker run -p 8554:8554 neilvaltec/drone_camera_rtsp_simulator:0.0.2
```

Open another terminal, run container no.2
```
docker run -it --network=container:${container_no1_id} neilvaltec/mediapipe_rtsp:0.0.1 bash
```

Inside container no.2, run
```
python /mediapipe_rtsp/object_detection/object_detector_rtsp_input/detect.py --model=/mediapipe_rtsp/object_detection/models/efficientdet_lite2_light.tflite
```

Finally, on your mac/windows/ubuntu, open another terminal (third one), check the objection result
```
vlc rtsp://localhost:8554/mediapipe_output
```

You can check the the rtsp input of mediapipe as well
```
vlc rtsp://localhost:8554/drone_camera
```