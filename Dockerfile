FROM buildpack-deps:stretch

ARG opencv_version=3.4.8
ARG dcmtk_version=3.6.4

ENV OPENCV_VERSION $opencv_version
ENV DCMTK_VERSION $dcmtk_version

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        cmake && \
    rm -rf /var/lib/apt/lists/*

ARG build_threads=${nproc}

RUN curl -L -o opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
    unzip opencv.zip && \
    cd opencv-$OPENCV_VERSION && \
    mkdir build && cd build && cmake -DBUILD_LIST=imgproc,highgui -DBUILD_EXAMPLES=OFF -DBUILD-JAVA=OFF -DBUILD_opencv_python2=OFF .. && \
    make all -j$build_threads && \
    make install && \
    rm -rf /build/opencv

RUN curl -L -o dcmtk.zip ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk364/dcmtk-$DCMTK_VERSION.zip && \
    unzip dcmtk.zip && \
    cd dcmtk-$DCMTK_VERSION && \
    mkdir build && cd build && cmake .. && \
    make all -j$build_threads && \
    make install && \
    rm -rf /build/dcmtk
