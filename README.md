# rtsp-simple-server-restream-to-twitch-script
Powershell script that uses MariaDB ODBC to read out Twitch stream keys from MariaDB database. 

When a key is found it starts ffmpeg and restreams to Twitch.


# Requirements:
* [RtspSimpleServer](https://github.com/aler9/rtsp-simple-server)
* Powershell (*untested with PowerShell Core*)
* [FFmpeg](https://ffmpeg.org/download.html)
* [MariaDB Server](https://downloads.mariadb.org/)
* [MariaDB ODBC Connector](https://downloads.mariadb.org/connector-odbc/)

# How it works:

Use `runOnPublish` in your `rtsp-simple-server.yml` to run the script as follows: 

```YAML
runOnPublish: PowerShell.exe -ExecutionPolicy Unrestricted -command ".\restream.ps1 -streamPath $RTSP_PATH"
```

Make sure to create a folder called `logs` for Powershell & FFmpeg log files.
