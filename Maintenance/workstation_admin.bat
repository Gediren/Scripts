@ECHO off

:: All this file does is run maintenance_workstation.ps1 with admin permissions. Please do not run maintenance_workstation.ps1 directly
:: as it will not function properly, and some features will not work at all.

powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -file %~dp0maintenance_workstation.ps1' -verb RunAs}"