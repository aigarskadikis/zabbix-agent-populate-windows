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
populate-zabbix-agent-native.cmd
```

'zabbix_get.exe' and 'zabbix_sender.exe' are optional.
Make sure to replace 'ServerActive=' field and 'Server=' with your zabbix servers DNS or IP addres

To install the agent open 'populate-zabbix-agent.cmd' and specify the destination for agent:
```
set zabbix=%systemdrive%\zabbix
```

Then run
```
populate-zabbix-agent.cmd
```

To delete the already running agent 
```
uninstall-zabbix-agent.cmd
```
