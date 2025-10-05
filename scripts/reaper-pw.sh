#!/usr/bin/env bash

# 1) start Reaper under PipeWire-JACK in the background
pw-jack reaper &
PID=$!
sleep 1

# 2) wire your HDA mic → REAPER inputs
pw-link \
  alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source:capture_FL \
  REAPER:in1

pw-link \
  alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source:capture_FR \
  REAPER:in2

# 3) wire REAPER outputs → your BurrBrown USB DAC playback
pw-link \
  REAPER:out1 \
  alsa_output.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo:playback_FL

pw-link \
  REAPER:out2 \
  alsa_output.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo:playback_FR

# keep the script alive until Reaper exits
wait $PID

