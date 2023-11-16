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

## Working with cookbook versions

To test a new cookbook version before rolling it out, you can execute the target
recipe(s) via a onetime Chef run that uses only those recipes:

```
chef-client -o "recipe[mycookbook@0.1.1]"
chef-client -o "recipe[mycookbook@0.1.1],recipe[myothercookbook@0.3.3]"
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
knife node run_list add "$MYNODE" "role[MyRole]" --config $MYCONFIG
knife node run_list remove "$MYNODE" "role[MyRole]" --config $MYCONFIG
```

### Knife vault

See the [knife vault docs](https://docs.chef.io/workstation/chef_vault/)

NOTE: You can avoid needing to add `--mode client` to these commands
by instead adding a line to your Knife config file (i.e. `$MYCONFIG`):

`knife[:vault_mode] = 'client'`

```bash
# View knife vault
knife vault show VaultName --config $MYCONFIG --mode client
knife vault show VaultName ItemName --config $MYCONFIG --mode client

# Remove an old client from a vault item
knife vault refresh VaultName ItemName --clean-unknown-clients --config $MYCONFIG --mode client

# Update encryption by rotating the backing key for a vault item
knife vault rotate keys VaultName ItemName --config $MYCONFIG --mode client
knife vault rotate keys VaultName ItemName --config --clean-unknown-clients $MYCONFIG --mode client

# Add an admin to a vault item
knife vault update VaultName ItemName -A "admin1, admin2" --config $MYCONFIG --mode client

# Add a client to a vault item
knife vault update VaultName ItemName -C "my.fqdn.com" --config $MYCONFIG --mode client

# Even better, don't directly add clients, but use a role instead
# Use this command to determine what role(s) have access to the item:
knife vault show VaultName ItemName --print search --config $MYCONFIG
knife vault update VaultName ItemName -S 'role:MyRole' --config $MYCONFIG

# Access through knife data bag instead
knife data bag show VaultName --config $MYCONFIG
knife data bag show VaultName ItemName --config $MYCONFIG
knife data bag show VaultName ItemName_keys --config $MYCONFIG

# Create a new vault item and grant access for a given role (or roles)
knife vault create VaultName ItemName '{"username": "root", "password": "mypassword"}' -S "role:webserver"

```