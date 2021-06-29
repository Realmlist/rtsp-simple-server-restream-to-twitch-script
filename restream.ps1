param(
    [Parameter(Mandatory=$true)]
    [string]$streamPath
)
Start-Transcript "logs/$streamPath-PowerShell.log" -Append

#DB Config
$SQLServer = "localhost"
$SQLDBName = "restream-keys"
$SQLUser = "root"
$SQLPW = ""

# Connect to the database
$SqlConnection = New-Object System.Data.ODBC.ODBCConnection
$SqlConnection.connectionstring = `
   "DRIVER={MariaDB ODBC 3.1 Driver};" +
   "Server = $SQLServer;" +
   "Database = $SQLDBName;" +
   "UID = $SQLUser;" +
   "PWD= $SQLPW;" +
   "Option = 3"
$SqlConnection.Open()
Write-host "MariaDB connection:" $SqlConnection.State

$SqlQuery = "SELECT twitchKey FROM twitchKeys WHERE path = `'$streamPath`';"
$Command = New-Object `
    System.Data.ODBC.ODBCCommand($SQLQuery, $SQLConnection)

$twitchStreamkey = $Command.executescalar()
if($twitchStreamkey){
    $keyFound = $true
    Write-Host "Found key!"
}else{
    $keyFound = $false
    Write-Host "No key found!"
}

$SqlConnection.Close()
Write-host "MariaDB connection:" $SqlConnection.State


if($keyFound){
    Write-Host "Starting FFmpeg restream..."
    Stop-Transcript
    ffmpeg -loglevel error -fflags nobuffer -i rtsp://localhost:8554/$streamPath -c copy -f flv rtmp://live.twitch.tv/app/$twitchStreamkey  > 'logs/'$streamPath'-ffmpeg.log'
}
Stop-Transcript