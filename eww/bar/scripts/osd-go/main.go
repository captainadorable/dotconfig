package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

func main() {
  args := os.Args[1:]

  // volume, brightness
  if (len(args) != 1) {
    fmt.Println("Not enough arguments")
    return
  } 

  // set value
  var value string
  if (args[0] == "volume") {
    text, _ := exec.Command("wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@").Output()
    _, value, _ = strings.Cut(string(text), " ")
  }
  if (args[0] == "brightness") {
    text, _ := exec.Command("brightnessctl", "g").Output()
    value = string(text)
  }

  openOSD(args[0], strings.TrimSpace(value))
}

func getEwwVar(varName string) string {
  output, _ := exec.Command("eww", "get", varName).Output()
  text := string(output)
  return strings.TrimSpace(text) 
}

func openOSD(state string, value string) {
  // set last call
  now := strconv.FormatInt(time.Now().Unix(), 10)
  exec.Command("eww", "update", fmt.Sprintf("osd_last=%s", now)).Run()

  exec.Command("eww", "update", "osd_value="+value).Run()
  exec.Command("eww", "update", "osd_state="+state).Run()

  // open osd
  if getEwwVar("osd_open") == "false" {
    exec.Command("eww", "open", "osd").Run()
    exec.Command("eww", "update", "osd_open=true").Run()
  }

  time.Sleep(2 * time.Second)

  // if another script called before time.sleep don't close osd
  if getEwwVar("osd_last") != now {
    fmt.Println("Called another script")
    return
  } 

  // close osd
  exec.Command("eww", "close", "osd").Run()
  exec.Command("eww", "update", "osd_open=false").Run()
}
