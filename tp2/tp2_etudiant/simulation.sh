#!/bin/bash

soclib-cc -p tp2.desc -t systemcass -o simul.x
./simul.x -DEBUG 0 -NCYCLES 5000 > tmp