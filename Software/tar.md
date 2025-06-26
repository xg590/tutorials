* To exclude a subdirectory, you may omit root directory in the path. 
```sh
tar --exclude="FlaskPy/py/lib/python3.10/site-packages" -Jcvf SMDC_deployed.tar.xz SMDC/
```