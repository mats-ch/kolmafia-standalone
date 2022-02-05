#!/bin/bash
vncserver -geometry 1800x1000 :1

/home/kolmafia/novnc/utils/novnc_proxy --vnc localhost:5901
#/home/kolmafia/novnc/utils/launch.sh --vnc localhost:5901
