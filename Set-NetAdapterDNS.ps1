# This script will set the network adapter of your choice to non-standard DNS like Google or Quad 9
# Has an auto mode command line flag, configures all UP interfaces with Quad 9

# Starts with
Get-NetAdapter | format-list name,ifindex,status

# Store the results that have status UP in a variable
# Give the option to select all UP interfaces or a single UP inteface

# Give option of which DNS to set or set to DHCP interface (clear the static assignment)