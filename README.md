# Zabbix agent populate for windows

This project contains multiple scripts how to detect, install, replace and maintain Zabbix agent for Windows systems. It will use additional libraries (sed.exe, libiconv2.dll, libintl3.dll, regex2.dll, grep.exe, pcre3.dll) to format the received content. This libraries must be side by side with other *.cmd scripts.

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

## install agent on fresh system

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
echo Server=ip.or.dns.address> c:\zabbix\zabbix_agentd.conf.d\Server.conf
echo ServerActive=ip.or.dns.address> c:\zabbix\zabbix_agentd.conf.d\ServerActive.conf
echo HostMetadata=WindowsWorkstationActive> c:\zabbix\zabbix_agentd.conf.d\HostMetadata.conf

```

