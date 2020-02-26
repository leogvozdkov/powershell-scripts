#  Change OU of computer by IP
#  using IS-InSubnet function by Srinivasa Tumarada    https://gallery.technet.microsoft.com/scriptcenter/Validate-an-Ipaddress-is-03481731
#  
#  Settings

$output_ou = ""    # destination OU
$subnets_array = ('')           # array of subnets where the computers are located


#function for detection if computer's IP is in the subnet

Function IS-InSubnet() 
{ 
 
[CmdletBinding()] 
[OutputType([bool])] 
Param( 
                    [Parameter(Mandatory=$true, 
                     ValueFromPipelineByPropertyName=$true, 
                     Position=0)] 
                    [validatescript({([System.Net.IPAddress]$_).AddressFamily -match 'InterNetwork'})] 
                    [string]$ipaddress="", 
                    [Parameter(Mandatory=$true, 
                     ValueFromPipelineByPropertyName=$true, 
                     Position=1)] 
                    [validatescript({(([system.net.ipaddress]($_ -split '/'|select -first 1)).AddressFamily -match 'InterNetwork') -and (0..32 -contains ([int]($_ -split '/'|select -last 1) )) })] 
                    [string]$Cidr="" 
    ) 
Begin{ 
        [int]$BaseAddress=[System.BitConverter]::ToInt32((([System.Net.IPAddress]::Parse(($cidr -split '/'|select -first 1))).GetAddressBytes()),0) 
        [int]$Address=[System.BitConverter]::ToInt32(([System.Net.IPAddress]::Parse($ipaddress).GetAddressBytes()),0) 
        [int]$mask=[System.Net.IPAddress]::HostToNetworkOrder(-1 -shl (32 - [int]($cidr -split '/' |select -last 1))) 
} 
Process{ 
        if( ($BaseAddress -band $mask) -eq ($Address -band $mask)) 
        { 
 
            $status=$True 
        }else { 
 
        $status=$False 
        } 
} 
end { return $status }
}


$ADcomputers = Get-ADComputer -Filter * -Properties ipv4Address    #get all AD computers with IPs

foreach ($ADcomputer in $ADcomputers)                              #check every computer if they in the subnets, then move to the OU
{
    if ($ADcomputer.IPv4Address)
    {
        foreach($subnet in $subnets_array)
        {
            $address = $ADcomputer.IPv4Address.ToString()
            $cidr = $subnet
            $check_subnet = IS-InSubnet -ipaddress $address -Cidr $cidr
            if ($check_subnet)
            {
                Move-ADObject -Identity $ADcomputer.objectGUID -TargetPath $output_ou
                $output_res = "Changed OU for " + $ADcomputer.ipv4Address + " " + $ADcomputer.Name
                Write-Host ($output_res)
            }
        }
    }
}
            
        

