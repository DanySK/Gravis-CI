#!/bin/bash
# Note: I'm not sure this works.
if [ $TRAVIS_OS_NAME = 'windows' ]
then
  echo "This is an attempt at disabling Windows Defender. I'm not sure it works."
  export PROJECTDIR=$(pwd)
  export TEMPDIR=$LOCALAPPDATA\\Temp
  powershell Add-MpPreference -ExclusionPath ${PROJECTDIR}
  powershell Add-MpPreference -ExclusionPath ${TEMPDIR}
  powershell Add-MpPreference -ExclusionPath ${HOME}
  echo "DisableArchiveScanning..."
  powershell Start-Process -PassThru -Wait PowerShell -ArgumentList "'-Command Set-MpPreference -DisableArchiveScanning \$true'"
  echo "DisableBehaviorMonitoring..."
  powershell Start-Process -PassThru -Wait PowerShell -ArgumentList "'-Command Set-MpPreference -DisableBehaviorMonitoring \$true'"
  echo "DisableRealtimeMonitoring..."
  powershell Start-Process -PassThru -Wait PowerShell -ArgumentList "'-Command Set-MpPreference -DisableRealtimeMonitoring \$true'"
  powershell -ExecutionPolicy Bypass Get-MpPreference
fi
