#!/bin/bash
# Note: I'm not sure this works.
echo This is an attempt at disabling Windows Defender. I'm not sure it works.
powershell -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass -Command \"Set-MpPreference -DisableRealtimeMonitoring \$true\"'"
powershell -ExecutionPolicy Bypass -Command 'Get-MpPreference > wd-status.log'
cat wd-status.log
