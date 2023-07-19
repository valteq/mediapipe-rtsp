# mediapipe-gstreamer
diagram: RTSP -> mediapipe -> RTSP

https://github.com/googlesamples/mediapipe/tree/main/examples/object_detection/python/object_detector_live_stream

# start a mediamtx server
https://github.com/bluenviron/mediamtx#standalone-binary


# start a video
```bash
ffmpeg -re -stream_loop -1 -i object_detection.mp4  -c copy -f rtsp rtsp://localhost:8554/drone_camera
```

# run
```bash
python3 object_detector_rtsp_input/detect.py
```

# check output result
```bash
vlc rtsp://localhost:8554/mediapipe_output
```

# check input result
```bash
vlc rtsp://localhost:8554/drone_camera
```

# notes
1. Live stream mediapipe is running using [async](https://github.com/google/mediapipe/blob/17bc1a5ab5fa1ad02c48710719ce509028277f8e/mediapipe/tasks/python/vision/object_detector.py#L348). So if mediapipe is not able to catch up with the original FPS, it'll drop/skip the inference for that time. From the link "To lower the overall latency, object detector may drop the input images if needed. In other words, it's not guaranteed to have output per input image."
2. Disabling detector makes the RTSP smoother.
3. Following [instructions](https://github.com/bluenviron/mediamtx#opencv), opencv also needs to be compiled with QT. So the build command becomes
   ```bash
   cmake -D CMAKE_INSTALL_PREFIX=/home/neilchou/opencv-4.5.4 -D WITH_GSTREAMER=ON -D WITH_QT=ON ..
   ```
