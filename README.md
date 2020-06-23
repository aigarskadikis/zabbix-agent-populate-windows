# Populate Zabbix agent with native windows tools

The script is suitable for 64-bit and 32-bit Windows starting from Windows XP/2003 and going up..
## Download very latest agent binaries for windows system at:

https://www.zabbix.com/download_agents

Make sure these files are persistent in the source directory and the structure is as:
```
win32\zabbix_agentd.exe
win32\zabbix_get.exe
win32\zabbix_sender.exe
win64\zabbix_agentd.exe
win64\zabbix_get.exe
win64\zabbix_sender.exe
conf\zabbix_agentd.conf
populate.cmd
uninstall.cmd
upgrade.cmd
```

'zabbix_get.exe' and 'zabbix_sender.exe' are optional.

## Configuration
Open 'zabbix_agentd.conf' and make sure to set the right IP address or DNS name for Zabbix master server or Zabbix proxy:
```
ServerActive=
Server=
```

Open 'populate.cmd' and specify the destination for agent:
```
set zabbix=%systemdrive%\zabbix
```

Specify the version which is located in 'Win32' and 'Win64' directory:
```
set version=5.0.1
```

## Delete agent

To delete the already running agent 
```
uninstall.cmd
```

## Custom settings for conf\zabbix_agentd.conf

Latest options/settings can found here:

https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/conf/zabbix_agentd.win.conf

### Replace

1) Location of log file. Replace:
```
LogFile=c:\zabbix_agentd.log
```
with:
```
LogFile=c:\zabbix\zabbix_agentd.log
```

2) To capture more metrics in memory for 'Zabbix agent (active)' checks in case of machine goes offline replace:
```
# BufferSize=100
```
with:
```
# BufferSize=100
BufferSize=65535
```


### Remove

1) To automatically register Agent host in zabbix as the %computername% for machine, delete the line:
```
Hostname=Windows host
```

### Add

1) To classify machines by Operating System using HostMetadata field enable:
```
HostMetadataItem=wmi.get[root\cimv2,select Caption from Win32_OperatingSystem]
```

2) To allow to pick up UserParameters from external dirctory:
```
Include=c:\zabbix\zabbix_agentd.conf.d\*.conf
```

## Installation
Run:
```
populate.cmd
```


## Maintenance cost

Every time when a new agent must be populated replace the binaries:
```
win32\zabbix_agentd.exe
win64\zabbix_agentd.exe
```
+ manually specify a new version inside 'populate.cmd':
```
set version=5.0.1
```

In case you forgot to update version variable in 'populate.cmd', the script will still work fine. But underneath the hood, the agent will get reinstalled every time the computer boots up.
