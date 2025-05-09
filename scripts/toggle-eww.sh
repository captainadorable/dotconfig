#!/bin/bash

widget_name="bar"  # replace with your actual widget name

if eww active-windows | grep -q "$widget_name"; then
    eww close "$widget_name"
else
    eww open "$widget_name"
fi
