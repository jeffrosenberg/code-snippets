# Chef

Run chef from any remote desktop:

```
chef-client
```

Or via remote PowerShell
**Prompt must have SA privileges

```powershell
$machineName="my.fqdn.com"
Invoke-Command -ComputerName $machineName -ScriptBlock { & chef-client }
```

## Knife

```bash
MYCONFIG=~/.chef/knife-dev.rb
# MYCONFIG=~/.chef/knife-prod.rb

# Show all nodes
knife node list --config $MYCONFIG

# Get data on a particular node
MYNODE="my.fqdn.com"
knife node show "$MYNODE" --config $MYCONFIG
knife node show "$MYNODE" --attribute "myAttribute" --config $MYCONFIG
knife node show "$MYNODE" --attribute "myAttribute.myNestedAttribute" --config $MYCONFIG

# Update a node from our chef-nodes files
knife node from file /path/to/nodefile.json --config $MYCONFIG
knife node run_list add "$MYNODE" "role[BaseProd]" --config $MYCONFIG

# View knife vault
knife vault show VaultName --config $MYCONFIG -m client
```