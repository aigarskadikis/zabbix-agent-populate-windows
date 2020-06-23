# Populate Zabbix agent with native windows tools

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
populate.cmd
uninstall.cmd
upgrade.cmd
```

'zabbix_get.exe' and 'zabbix_sender.exe' are optional.

## Installation
Open 'zabbix_agentd.conf' and make sure to replace set the right IP address or DNS name for
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


Run:
```
populate.cmd
```

## Delete agent

To delete the already running agent 
```
uninstall.cmd
```

## Custom configuration made to conf\zabbix_agentd.conf

Latast options/settings can found here:

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

2) To capture more metrics for in memory for 'Zabbix agent (active)' checks if machine has lost network connectivity replace:
```
# BufferSize=100
```
with:
```
# BufferSize=100
BufferSize=65535
```


### Remove

1) To automatically register agent host in zabbix as the %computername% for machine delete the line:
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


## Download very latest version

https://www.zabbix.com/download_agents

