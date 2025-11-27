#Create a cached credential
import-module dataontap
$cred=Get-Credential
$IP_Address = Read-Host "Enter Management IP Address"

#Connect to Cluster
Connect-NcController -name $IP_Address -Credential $cred

#Create SVM
New-NcVserver -Name MASKED_iSCSI -RootVolumeAggregate MASKED_aggregate -RootVolume MASKED_iSCSI_Root  -NameServerSwitch file -RootVolumeSecurityStyle unix -NameMappingSwitch file
#New-NcQtree -Volume MASKED_iSCSI -Qtree vol -VserverContext MASKED_iSCSI

#Commad to enable iSCSI and set IQN name
Add-NcIscsiService -Name MASKED_iSCSI -NodeName iqn.1992-08.com.netapp:maskediscsi -VserverContext MASKED_iSCSI

#Create Volumes
New-NcVol -Name MASKED_Boot_Vol -Size 1024gb -Aggregate MASKED_aggregate -SpaceReserve volume -JunctionPath /MASKED_Boot_Vol -VserverContext MASKED_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name MASKED_Data_1 -Size 102400gb -Aggregate MASKED_aggregate -SpaceReserve volume -JunctionPath /MASKED_Data_1 -VserverContext MASKED_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name MASKED_Data_2 -Size 102400gb -Aggregate MASKED_aggregate -SpaceReserve volume -JunctionPath /MASKED_Data_2 -VserverContext MASKED_iSCSI | Set-NcSnapshotReserve -Percentage 0
New-NcVol -Name MASKED_Data_3 -Size 102400gb -Aggregate MASKED_aggregate -SpaceReserve volume -JunctionPath /MASKED_Data_3 -VserverContext MASKED_iSCSI | Set-NcSnapshotReserve -Percentage 0

#Commands to Set MTU and Create Broadcast Domain
New-NcNetPortBroadCastDomain -Name MASKED_OOB_MGMT -Ipspace Default -mtu 1500 -port MASKEDNACL1-02:e0M,MASKEDNACL1-01:e0M
New-NcNetPortBroadCastDomain -Name MASKED-10GB -Ipspace Default -mtu 9000 -port MASKEDNACL1-02:e0e,MASKEDNACL1-02:e0f,MASKEDNACL1-01:e0e,MASKEDNACL1-01:e0f
New-NcNetPortBroadCastDomain -Name MASKED-iSCSI -Ipspace Default -mtu 9000 -port MASKEDNACL1-01:e0e-999,MASKEDNACL1-01:e0f-999,MASKEDNACL1-02:e0e-999,MASKEDNACL1-02:e0f-999

#Commands to Create Network Interfaces
New-NcNetInterface -Name MASKED_iSCSI_LIF_A1 -Vserver MASKED_iSCSI -Role data -Node MASKEDNACL1-01 -Port e0e-999 -Address 0.0.0.0 -Netmask 0.0.0.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name MASKED_iSCSI_LIF_B1 -Vserver MASKED_iSCSI -Role data -Node MASKEDNACL1-01 -Port e0f-999 -Address 0.0.0.0 -Netmask 0.0.0.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name MASKED_iSCSI_LIF_A2 -Vserver MASKED_iSCSI -Role data -Node MASKEDNACL1-02 -Port e0e-999 -Address 0.0.0.0 -Netmask 0.0.0.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name MASKED_iSCSI_LIF_B2 -Vserver MASKED_iSCSI -Role data -Node MASKEDNACL1-02 -Port e0f-999 -Address 0.0.0.0 -Netmask 0.0.0.0 -FirewallPolicy data -DataProtocols iscsi -ForceSubnetAssociation
New-NcNetInterface -Name MASKED_iSCSI_mgmt -Vserver MASKED_iSCSI -Role data -Node MASKEDNACL1-01 -Port e0M -Address 0.0.0.0 -Netmask 0.0.0.0 -FirewallPolicy mgmt -DataProtocols none -ForceSubnetAssociation

#Commands To Generate VLAN Interface for iSCSI
New-NcNetPortVlan -ParentInterface e0e -node MASKEDNACL1-01 -VlanId 999
New-NcNetPortVlan -ParentInterface e0f -node MASKEDNACL1-01 -VlanId 999
New-NcNetPortVlan -ParentInterface e0e -node MASKEDNACL1-02 -VlanId 999
New-NcNetPortVlan -ParentInterface e0f -node MASKEDNACL1-02 -VlanId 999

#Command to Create iGroup
New-NcIgroup -Name MASKED_UCS_B1 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B2 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B3 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B4 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B5 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B6 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B7 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B8 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B9 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B10 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B11 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B12 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B13 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI
New-NcIgroup -Name MASKED_UCS_B14 -Protocol iscsi -Type hyper_v -VserverContext MASKED_iSCSI

#Command to Add Initiators
Add-NcIgroupInitiator -Igroup MASKED_UCS_B1 -Initiator iqn.2012-01.com.vm-cisco:hypera1  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B1 -Initiator iqn.2012-01.com.vm-cisco:hyperb1 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B2 -Initiator iqn.2012-01.com.vm-cisco:hypera2  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B2 -Initiator iqn.2012-01.com.vm-cisco:hyperb2 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B3 -Initiator iqn.2012-01.com.vm-cisco:hypera3  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B3 -Initiator iqn.2012-01.com.vm-cisco:hyperb3 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B4 -Initiator iqn.2012-01.com.vm-cisco:hypera4  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B4 -Initiator iqn.2012-01.com.vm-cisco:hyperb4 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B5 -Initiator iqn.2012-01.com.vm-cisco:hypera5  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B5 -Initiator iqn.2012-01.com.vm-cisco:hyperb5 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B6 -Initiator iqn.2012-01.com.vm-cisco:hypera6  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B6 -Initiator iqn.2012-01.com.vm-cisco:hyperb6 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B7 -Initiator iqn.2012-01.com.vm-cisco:hypera7  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B7 -Initiator iqn.2012-01.com.vm-cisco:hyperb7 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B8 -Initiator iqn.2012-01.com.vm-cisco:hypera8  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B8 -Initiator iqn.2012-01.com.vm-cisco:hyperb8 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B9 -Initiator iqn.2012-01.com.vm-cisco:hypera9  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B9 -Initiator iqn.2012-01.com.vm-cisco:hyperb9 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B10 -Initiator iqn.2012-01.com.vm-cisco:hypera10  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B10 -Initiator iqn.2012-01.com.vm-cisco:hyperb10 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B11 -Initiator iqn.2012-01.com.vm-cisco:hypera11  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B11 -Initiator iqn.2012-01.com.vm-cisco:hyperb11 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B12 -Initiator iqn.2012-01.com.vm-cisco:hypera12  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B12 -Initiator iqn.2012-01.com.vm-cisco:hyperb12 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B13 -Initiator iqn.2012-01.com.vm-cisco:hypera13  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B13 -Initiator iqn.2012-01.com.vm-cisco:hyperb13 -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B14 -Initiator iqn.2012-01.com.vm-cisco:hypera14  -VserverContext MASKED_iSCSI
Add-NcIgroupInitiator -Igroup MASKED_UCS_B14 -Initiator iqn.2012-01.com.vm-cisco:hyperb14 -VserverContext MASKED_iSCSI

#Command to Generate LUNs
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B1 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B2 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B3 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B4 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B5 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B6 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B7 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B8 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B9 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B10 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B11 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B12 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B13 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B14 -Size 60g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -Size 16349g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -Size 16349g -Type hyper_v -vservercontext MASKED_iSCSI
New-NcLun -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -Size 16349g -Type hyper_v -vservercontext MASKED_iSCSI

#Map LUN to iGroup
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B1 -InitiatorGroup MASKED_UCS_B1 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B2 -InitiatorGroup MASKED_UCS_B2 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B3 -InitiatorGroup MASKED_UCS_B3 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B4 -InitiatorGroup MASKED_UCS_B4 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B5 -InitiatorGroup MASKED_UCS_B5 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B6 -InitiatorGroup MASKED_UCS_B6 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B7 -InitiatorGroup MASKED_UCS_B7 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B8 -InitiatorGroup MASKED_UCS_B8 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B9 -InitiatorGroup MASKED_UCS_B9 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B10 -InitiatorGroup MASKED_UCS_B10 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B11 -InitiatorGroup MASKED_UCS_B11 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B12 -InitiatorGroup MASKED_UCS_B12 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B13 -InitiatorGroup MASKED_UCS_B13 -id 0 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Boot_Vol/MASKED_Boot_Lun_B14 -InitiatorGroup MASKED_UCS_B14 -id 0 -VserverContext MASKED_iSCSI
#Placeholder
#Placeholder
#Placeholder
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B1 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B10 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B11 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B12 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B13 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B14 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B2 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B3 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B4 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B5 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B6 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B7 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B8 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_1/MASKED_Data_LUN_1 -InitiatorGroup MASKED_UCS_B9 -id 1 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B1 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B10 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B11 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B12 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B13 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B14 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B2 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B3 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B4 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B5 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B6 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B7 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B8 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_2/MASKED_Data_LUN_2 -InitiatorGroup MASKED_UCS_B9 -id 2 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B1 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B10 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B11 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B12 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B13 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B14 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B2 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B3 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B4 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B5 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B6 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B7 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B8 -id 3 -VserverContext MASKED_iSCSI
Add-NcLunMap -Path /vol/MASKED_Data_3/MASKED_Data_LUN_3 -InitiatorGroup MASKED_UCS_B9 -id 3 -VserverContext MASKED_iSCSI
