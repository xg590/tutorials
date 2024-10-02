* Install Opencv [Ref](https://docs.opencv.org/4.x/d2/de6/tutorial_py_setup_in_ubuntu.html) 
  ```
  sudo apt-get install python3-opencv
  python3 -c 'import cv2 as cv; print(f"OpenCV Version: {cv.__version__}")'
  ```
* Python
  ```
  
  ```
* Original error was: libopenblas.so.0: cannot open shared object file: No such file or directory
  ```
  sudo apt-get install libatlas-base-dev libopenblas-dev
  ```