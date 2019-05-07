# Zabbix agent deployment for windows

This project contains multiple scripts how to detect, install, replace and maintain Zabbix agent for Windows systems. It will use additional libraries (sed.exe, libiconv2.dll, libintl3.dll, regex2.dll, grep.exe, pcre3.dll) to format the received content. This libraries must be side by side with other *.cmd scripts.

## Download agent through command line
```
download-zabbix-agent.cmd 4.0.7
```
By initiating command without arguments it will download all available packages for 4.2 release
```
download-zabbix-agent.cmd
```

## Detect already installed agent
```
check-agent-installed.cmd
```
this can print content like
```
Zabbix agent:

.. is installed as service

.. already running

binary location:
C:\zabbix\zabbix_agentd.exe

agent version:
4.0.0

.. agent running currently as an process
zabbix_agentd.exe             8264 Services                   0     11 016 K
```

## Replace agent file
This script will automatically detect (based on record inside registry) where the agent is installed.

```
replace-agent-respecting-installation-path.cmd
```

