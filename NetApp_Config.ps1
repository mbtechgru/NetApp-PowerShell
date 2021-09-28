#Create a cached credential
import-module dataontap
$cred=Get-Credential
$IP_Address = Read-Host "Enter Management IP Address"

#Connect to Cluster
Connect-NcController -name $IP_Address -Credential $cred

#Create SVM
New-NcVserver -Name GEF_iSCSI -RootVolumeAggregate GEF_aggregate -RootVolume GEF_iSCSI_Root  -NameServerSwitch file -RootVolumeSecurityStyle unix -NameMappingSwitch file
#New-NcQtree -Volume GEF_iSCSI -Qtree vol -VserverContext GEF_iSCSI

#Commad to enable iSCSI and set IQN name
Add-NcIscsiService -Name GEF_iSCSI -NodeName iqn.1992-08.com.netapp:gefiscsi -VserverContext GEF_iSCSI

#Create Volumes
New-NcVol -Name GEF_Boot_Vol -Size 1024gb -Aggregate GEF_aggregate -SpaceReserve volume -JunctionPath /GEF_Boot_Vol -VserverContext GEF_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name GEF_Data_1 -Size 102400gb -Aggregate GEF_aggregate -SpaceReserve volume -JunctionPath /GEF_Data_1 -VserverContext GEF_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name GEF_Data_2 -Size 102400gb -Aggregate GEF_aggregate -SpaceReserve volume -JunctionPath /GEF_Data_2 -VserverContext GEF_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name GEF_Data_3 -Size 102400gb -Aggregate GEF_aggregate -SpaceReserve volume -JunctionPath /GEF_Data_3 -VserverContext GEF_iSCSI | Set-NcSnapshotReserve -Percentage 0

#Commands to Set MTU and Create Broadcast Domain
New-NcNetPortBroadCastDomain -Name GEF_OOB_MGMT -Ipspace Default -mtu 1500 -port GEFNACL1-02:e0M,GEFNACL1-01:e0M
New-NcNetPortBroadCastDomain -Name GEF-10GB -Ipspace Default -mtu 9000 -port GEFNACL1-02:e0e,GEFNACL1-02:e0f,GEFNACL1-01:e0e,GEFNACL1-01:e0f
New-NcNetPortBroadCastDomain -Name GEF-iSCSI -Ipspace Default -mtu 9000 -port GEFNACL1-01:e0e-999,GEFNACL1-01:e0f-999,GEFNACL1-02:e0e-999,GEFNACL1-02:e0f-999

#Commands to Create Network Interfaces
New-NcNetInterface -Name GEF_iSCSI_LIF_A1 -Vserver GEF_iSCSI -Role data -Node GEFNACL1-01 -Port e0e-999 -Address 172.16.0.1 -Netmask 255.255.255.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name GEF_iSCSI_LIF_B1 -Vserver GEF_iSCSI -Role data -Node GEFNACL1-01 -Port e0f-999 -Address 172.16.0.2 -Netmask 255.255.255.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name GEF_iSCSI_LIF_A2 -Vserver GEF_iSCSI -Role data -Node GEFNACL1-02 -Port e0e-999 -Address 172.16.0.3 -Netmask 255.255.255.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name GEF_iSCSI_LIF_B2 -Vserver GEF_iSCSI -Role data -Node GEFNACL1-02 -Port e0f-999 -Address 172.16.0.4 -Netmask 255.255.255.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name GEF_iSCSI_mgmt -Vserver GEF_iSCSI -Role data -Node GEFNACL1-01 -Port e0M -Address 10.5.44.93 -Netmask 255.255.252.0 -FirewallPolicy mgmt -DataProtocols none -ForceSubnetAssociation



#Commands To Generate VLAN Interface for iSCSI
New-NcNetPortVlan -ParentInterface e0e -node GEFNACL1-01 -VlanId 999
New-NcNetPortVlan -ParentInterface e0f -node GEFNACL1-01 -VlanId 999
New-NcNetPortVlan -ParentInterface e0e -node GEFNACL1-02 -VlanId 999
New-NcNetPortVlan -ParentInterface e0f -node GEFNACL1-02 -VlanId 999

#Command to Create iGroup
New-NcIgroup -Name GEF_UCS_B1 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B2 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B3 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B4 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B5 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B6 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B7 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B8 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B9 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B10 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B11 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B12 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B13 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI
New-NcIgroup -Name GEF_UCS_B14 -Protocol iscsi -Type hyper_v -VserverContext GEF_iSCSI

#Command to Add Initiators
Add-NcIgroupInitiator -Igroup GEF_UCS_B1 -Initiator iqn.2012-01.com.vm-cisco:hypera1  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B1 -Initiator iqn.2012-01.com.vm-cisco:hyperb1 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B2 -Initiator iqn.2012-01.com.vm-cisco:hypera2  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B2 -Initiator iqn.2012-01.com.vm-cisco:hyperb2 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B3 -Initiator iqn.2012-01.com.vm-cisco:hypera3  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B3 -Initiator iqn.2012-01.com.vm-cisco:hyperb3 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B4 -Initiator iqn.2012-01.com.vm-cisco:hypera4  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B4 -Initiator iqn.2012-01.com.vm-cisco:hyperb4 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B5 -Initiator iqn.2012-01.com.vm-cisco:hypera5  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B5 -Initiator iqn.2012-01.com.vm-cisco:hyperb5 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B6 -Initiator iqn.2012-01.com.vm-cisco:hypera6  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B6 -Initiator iqn.2012-01.com.vm-cisco:hyperb6 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B7 -Initiator iqn.2012-01.com.vm-cisco:hypera7  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B7 -Initiator iqn.2012-01.com.vm-cisco:hyperb7 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B8 -Initiator iqn.2012-01.com.vm-cisco:hypera8  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B8 -Initiator iqn.2012-01.com.vm-cisco:hyperb8 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B9 -Initiator iqn.2012-01.com.vm-cisco:hypera9  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B9 -Initiator iqn.2012-01.com.vm-cisco:hyperb9 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B10 -Initiator iqn.2012-01.com.vm-cisco:hypera10  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B10 -Initiator iqn.2012-01.com.vm-cisco:hyperb10 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B11 -Initiator iqn.2012-01.com.vm-cisco:hypera11  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B11 -Initiator iqn.2012-01.com.vm-cisco:hyperb11 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B12 -Initiator iqn.2012-01.com.vm-cisco:hypera12  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B12 -Initiator iqn.2012-01.com.vm-cisco:hyperb12 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B13 -Initiator iqn.2012-01.com.vm-cisco:hypera13  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B13 -Initiator iqn.2012-01.com.vm-cisco:hyperb13 -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B14 -Initiator iqn.2012-01.com.vm-cisco:hypera14  -VserverContext GEF_iSCSI
Add-NcIgroupInitiator -Igroup GEF_UCS_B14 -Initiator iqn.2012-01.com.vm-cisco:hyperb14 -VserverContext GEF_iSCSI

#Command to Generate LUNs
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B1 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B2 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B3 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B4 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B5 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B6 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B7 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B8 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B9 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B10 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B11 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B12 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B13 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B14 -Size 60g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -Size 16349g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -Size 16349g -Type hyper_v -vservercontext GEF_iSCSI
New-NcLun -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -Size 16349g -Type hyper_v -vservercontext GEF_iSCSI

#Map LUN to iGroup
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B1 -InitiatorGroup GEF_UCS_B1 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B2 -InitiatorGroup GEF_UCS_B2 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B3 -InitiatorGroup GEF_UCS_B3 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B4 -InitiatorGroup GEF_UCS_B4 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B5 -InitiatorGroup GEF_UCS_B5 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B6 -InitiatorGroup GEF_UCS_B6 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B7 -InitiatorGroup GEF_UCS_B7 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B8 -InitiatorGroup GEF_UCS_B8 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B9 -InitiatorGroup GEF_UCS_B9 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B10 -InitiatorGroup GEF_UCS_B10 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B11 -InitiatorGroup GEF_UCS_B11 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B12 -InitiatorGroup GEF_UCS_B12 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B13 -InitiatorGroup GEF_UCS_B13 -id 0 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Boot_Vol/GEF_Boot_Lun_B14 -InitiatorGroup GEF_UCS_B14 -id 0 -VserverContext GEF_iSCSI
#Placeholder
#Placeholder
#Placeholder
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B1 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B10 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B11 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B12 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B13 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B14 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B2 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B3 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B4 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B5 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B6 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B7 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B8 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_1/GEF_Data_LUN_1 -InitiatorGroup GEF_UCS_B9 -id 1 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B1 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B10 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B11 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B12 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B13 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B14 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B2 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B3 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B4 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B5 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B6 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B7 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B8 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_2/GEF_Data_LUN_2 -InitiatorGroup GEF_UCS_B9 -id 2 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B1 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B10 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B11 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B12 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B13 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B14 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B2 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B3 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B4 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B5 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B6 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B7 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B8 -id 3 -VserverContext GEF_iSCSI
Add-NcLunMap -Path /vol/GEF_Data_3/GEF_Data_LUN_3 -InitiatorGroup GEF_UCS_B9 -id 3 -VserverContext GEF_iSCSI
