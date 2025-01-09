apt update
apt install -y build-essential cmake git curl wget 
apt install -y libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev graphviz
    7  mkdir openMVG_Build && cd openMVG_Build
    8  cmake -DCMAKE_BUILD_TYPE=RELEASE ../openMVG/src/
    9  mkdir openMVG_Build && cd openMVG_Build
   10  cmake -DCMAKE_BUILD_TYPE=RELEASE ../openMVG/src/
   11  cmake -DCMAKE_BUILD_TYPE=RELEASE -DOpenMVG_BUILD_TESTS=ON ../openMVG/src/
   12  cmake --build . --target install
   13  make test

   docker container commit --pause --author xg590@nyu.edu 63d435c8908b openmvg:241216
