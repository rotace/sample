# samples
# https://gstreamer.freedesktop.org/documentation/plugins_doc.html

all:

usbcam:
	@gst-launch-1.0 -v \
	v4l2src ! \
	videoconvert ! \
	autovideosink

usbcam.info:
	@v4l2-ctl --list-formats

usbcam.info.all:
	@v4l2-ctl --list-formats-ext | less


raw.1:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,format=YUY2 ! \
	videoconvert ! \
	autovideosink

raw.2:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,format=YUY2,width=640,height=480,framerate=30/1 ! \
	videoconvert ! \
	autovideosink

raw.3:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,format=YUY2,width=640,height=480,framerate=30/1 ! \
	videoconvert ! \
	video/x-raw,format=Y444,width=640,height=480,framerate=30/1 ! \
	x264enc tune=zerolatency ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink

raw.4:
	@gst-launch-1.0 -v \
	v4l2src ! \
	videoconvert ! \
	x264enc tune=zerolatency ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink


jpeg.1:
	@gst-launch-1.0 -v \
	v4l2src ! \
	image/jpeg ! \
	jpegdec ! \
	videoconvert ! \
	autovideosink

jpeg.2:
	@gst-launch-1.0 -v \
	v4l2src ! \
	image/jpeg,width=640,height=480,framerate=30/1 ! \
	jpegdec ! \
	videoconvert ! \
	autovideosink

jpeg.3:
	@gst-launch-1.0 -v \
	v4l2src ! \
	image/jpeg,width=640,height=480,framerate=30/1 ! \
	jpegdec ! \
	x264enc tune=zerolatency ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink

scale:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,width=640,height=480 ! \
	videoscale ! \
	video/x-raw,width=100 ! \
	videoconvert ! \
	autovideosink

rate:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,width=640,height=480 ! \
	videorate ! \
	video/x-raw,framerate=1/1 ! \
	videoconvert ! \
	autovideosink

rtp.test:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,width=160,height=120,framerate=8/1 ! \
	videoconvert ! \
	autovideosink

rtp.send:
	@gst-launch-1.0 -v \
	v4l2src ! \
	video/x-raw,width=160,height=120,framerate=8/1 ! \
	videoconvert ! \
	x264enc ! \
	rtph264pay ! \
	udpsink host=127.0.0.1 port=5005 sync=false

rtp.recv:
	@gst-launch-1.0 -v \
	udpsrc port=5005 ! \
	application/x-rtp,media=video,encoding-name=H264 ! \
	queue ! \
	rtph264depay ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink

rtsp.fake:
	@gst-launch-1.0 -v \
	rtspsrc location=rtsp://127.0.0.1:8554/test ! \
	fakesink

rtsp.test.send:
	@./test-launch '( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 )'

rtsp.test.recv:
	@gst-launch-1.0 -v \
	rtspsrc location=rtsp://127.0.0.1:8554/test ! \
	rtph264depay ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink

rtsp.send:
	@./test-launch '( v4l2src ! video/x-raw,width=160,height=120,framerate=8/1 ! videoconvert ! x264enc ! rtph264pay name=pay0 pt=96 )'

rtsp.recv:
	@gst-launch-1.0 -v \
	rtspsrc location=rtsp://khi-desktop.local:8554/test ! \
	rtph264depay ! \
	avdec_h264 ! \
	videoconvert ! \
	autovideosink
