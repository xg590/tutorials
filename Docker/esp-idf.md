### IDF Docker Image
* Get the image and print its version. [Ref](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-docker-image.html)
  ```
  docker run --rm espressif/idf bash -c "echo \$ESP_IDF_VERSION"
  ```
* See the print of "docker run" and We get the ESP-IDF 5.2
  ``` 
  Detecting the Python interpreter
  Checking "python3" ... 
  Adding ESP-IDF tools to PATH...
  Checking if Python packages are up to date...
  Python requirements are satisfied.
  Requirement files:
   - /opt/esp/idf/tools/requirements/requirements.core.txt
  Python being checked: ...
  Added the following directories to PATH:
    /opt/esp/idf/components/espcoredump
    ...
    /opt/esp/idf/tools
  Done! You can now compile ESP-IDF projects.
  Go to the project directory and run:
  
    idf.py build
  
  5.2
  ```
* Clone a test project
  ```
  git clone https://github.com/xg590/ESP32_Beacon.git && cd ESP32_Beacon
  ```
* Use the image interactively
  ```
  docker run --rm -v $PWD:/project -w /project -u $UID -e HOME=/tmp -it espressif/idf
  ```
* Now we are in the working directory (which is $PWD in our host machine and /project in our container) so build it
  ``` 
  idf.py set-target esp32
  idf.py build
  exit # the container 
  ```
  or 
  ```
  docker run --rm -v $PWD:/project -w /project -u $UID -e HOME=/tmp espressif/idf bash -c "idf.py set-target esp32 && idf.py build" 
  ```

* Flash it.
  ```
  esptool.py --chip esp32 merge_bin -o esp32_beacon.bin 0x1000  build/bootloader/bootloader.bin           \
                                                        0x8000  build/partition_table/partition-table.bin \
                                                        0x10000 build/ESP32_Beacon.bin
  esptool.py --chip esp32 -p /dev/ttyUSB0 erase_flash
  esptool.py --chip esp32 -p /dev/ttyUSB0 write_flash   0x0 esp32_beacon.bin
  ```
* Preserve and restore the image
  ```
  docker save espressif/idf | gzip > /var/www/html/idf_v5.2.tgz
  ```