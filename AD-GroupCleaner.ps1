# delete all member of AD group, add admins
#
# e.g. to close shares from users and let admins control them
#

import-module activedirectory

$group = Read-Host 'group?'

Get-ADGroupMember $group | ForEach-Object {Remove-ADGroupMember $group $_ -Confirm:$false}
Add-ADGroupMember $group administrator      # possible to add any AD user