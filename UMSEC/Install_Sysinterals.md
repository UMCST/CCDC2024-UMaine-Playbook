# Install Sysinternals
This will install the following Sysinternals tools to a new directory called 'sysinternals'.
```
﻿$uri = "live.sysinternals.com"
$tools = @("procexp64.exe", "Autoruns64.exe", "Tcpview.exe", "Procmon64.exe", "Sysmon64.exe")
$dirname = "sysinternals"

mkdir $dirname

foreach($tool in $tools) {
    Invoke-WebRequest -uri "$uri/$tool" -OutFile "$dirname\$tool"
}

```
