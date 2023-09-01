# Linux

## Get current version

```bash
lsb_release -a
```

## SSH

> TODO: Add snippet for creating SSH keys next time I need to do it

```bash
# For frequently accessed machines, copy my SSH key
ssh-copy-id <machine_name>

# Run a single command (or pipeline of commands) without an interactive prompt
ssh user1@server1 command1
ssh user1@server1 'command2'
ssh user1@server1 'command1 | command2'
ssh user1@server1 "command1; command2; command3"

# Copy a file from an SSH connection using scp
scp user1@server1:/path/to/file /path/to/local/file
```


## Control networking from the CLI -- use nmcli

```
$ nmcli --help
Usage: nmcli [OPTIONS] OBJECT { COMMAND | help }

OPTIONS
  -a, --ask                                ask for missing parameters
  -c, --colors auto|yes|no                 whether to use colors in output
  -e, --escape yes|no                      escape columns separators in values
  -f, --fields <field,...>|all|common      specify fields to output
  -g, --get-values <field,...>|all|common  shortcut for -m tabular -t -f
  -h, --help                               print this help
  -m, --mode tabular|multiline             output mode
  -o, --overview                           overview mode
  -p, --pretty                             pretty output
  -s, --show-secrets                       allow displaying passwords
  -t, --terse                              terse output
  -v, --version                            show program version
  -w, --wait <seconds>                     set timeout waiting for finishing operations

OBJECT
  g[eneral]       NetworkManager's general status and operations
  n[etworking]    overall networking control
  r[adio]         NetworkManager radio switches
  c[onnection]    NetworkManager's connections
  d[evice]        devices managed by NetworkManager
  a[gent]         NetworkManager secret agent or polkit agent
  m[onitor]       monitor NetworkManager changes

$ nmcli connection help
Usage: nmcli connection { COMMAND | help }

COMMAND := { show | up | down | add | modify | clone | edit | delete | monitor | reload | load | import | export }

  show [--active] [--order <order spec>]
  show [--active] [id | uuid | path | apath] <ID> ...

  up [[id | uuid | path] <ID>] [ifname <ifname>] [ap <BSSID>] [passwd-file <file with passwords>]

  down [id | uuid | path | apath] <ID> ...

  add COMMON_OPTIONS TYPE_SPECIFIC_OPTIONS SLAVE_OPTIONS IP_OPTIONS [-- ([+|-]<setting>.<property> <value>)+]

  modify [--temporary] [id | uuid | path] <ID> ([+|-]<setting>.<property> <value>)+

  clone [--temporary] [id | uuid | path ] <ID> <new name>

  edit [id | uuid | path] <ID>
  edit [type <new_con_type>] [con-name <new_con_name>]

  delete [id | uuid | path] <ID>

  monitor [id | uuid | path] <ID> ...

  reload

  load <filename> [ <filename>... ]

  import [--temporary] type <type> file <file to import>

  export [id | uuid | path] <ID> [<output file>]
```

```bash
# View network devices
nmcli dev status

# View saved connections
nmcli connection show

# Find available connections
nmcli dev wifi list

# Add a connection - requires sudo!
sudo nmcli dev wifi connect <ssid/bssid>
sudo nmcli dev wifi connect <ssid/bssid> password <password>

# Disconnect from a connection
nmcli con down <ssid/uuid>

# Connect to a saved connection
nmcli con up <ssid/uuid>
```

Need to sign into a captive portal? Use http://neverssl.com

## cURL

Return response headers: `-i`/`-I`.
`-i` includes headers, `-I` returns headers instead of the full response.

```
$ curl -kI https://myapp/health/status
HTTP/1.1 404 Not Found
Content-Length: 1245
Content-Type: text/html
Server: Microsoft-IIS/10.0
X-Powered-By: ASP.NET
Date: Tue, 30 May 2023 12:51:14 GMT
```