# Zabbix agent populate for windows

This project contains multiple scripts how to detect, install, replace and maintain Zabbix agent for Windows systems. 

## Populate Zabbix agent with native windows tools
The script is suitable for 64-bit and 32-bit Windows starting from Windows XP/2003 and going up..
Make sure these files are persistant in the source direcotry:
```
win32\zabbix_agentd.exe
win32\zabbix_get.exe
win32\zabbix_sender.exe
win64\zabbix_agentd.exe
win64\zabbix_get.exe
win64\zabbix_sender.exe
conf\zabbix_agentd.conf
populate-zabbix-agent-native.cmd
```

'zabbix_get.exe' and 'zabbix_sender.exe' are optional.
Make sure to replace 'ServerActive=' field and 'Server=' with your zabbix servers DNS or IP addres


## Download agent through command line

Download the very light version:
```
download-zabbix-agent.cmd 4.0.7
```

Agent with the encryption feature can be initiating:
```
download-zabbix-agent.cmd 4.0.7 openssl
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
This script will automatically detect (based on record inside registry) where the agent is installed. Quite flexible!

```
replace-agent-respecting-installation-path.cmd
```

## Install Zabbix agent on fresh system

Make sure there are some zip archives placed side by side with the scripting files like:
```
zabbix_agents-4.0.7-win-amd64.zip
zabbix_agents-4.0.7-win-i386.zip
```

Open install-zabbix-agent-flexible.cmd and make sure destination ("set dest=c:\zabbix") suits your systems.

Install agent
```
install-zabbix-agent-flexible.cmd
```

Set dynamics (can be populated through group policy):
```
echo Server=127.0.0.1> c:\zabbix\zabbix_agentd.conf.d\Server.conf
echo ServerActive=ec2-1-2-3-4.us-west-2.compute.amazonaws.com> c:\zabbix\zabbix_agentd.conf.d\ServerActive.conf
echo HostMetadata=WindowsWorkstationActive> c:\zabbix\zabbix_agentd.conf.d\HostMetadata.conf
```
