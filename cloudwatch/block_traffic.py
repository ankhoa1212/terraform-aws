import boto3
import os

ec2_client = boto3.client('ec2')

def lambda_handler(event, context):
    subnet_id = "subnet-080a1151591879df7"
    network_acl_id = "acl-0182900b67235abbb"
    
    # In a real scenario, you'd likely extract the offending IP from the alert event
    # For demonstration, we'll assume a source IP or block all ICMP for the subnet
    # For blocking specific IPs, you'd need the alert to provide that.
    
    # Example: Block all inbound ICMP for IPv4
    rule_number = 50 # Choose a rule number. Best practice: leave gaps for future rules (e.g., 10, 20, 30...)
    protocol = '1'  # ICMP
    icmp_type = -1  # All
    cidr_block = '0.0.0.0/0' # To block all traffic from anywhere
    egress = True
    action = 'deny'
    
    try:
        # Find the NACL associated with the subnet if not directly provided
        if not network_acl_id and subnet_id:
            response = ec2_client.describe_subnets(SubnetIds=[subnet_id])
            if response['Subnets']:
                network_acl_id = response['Subnets'][0]['NetworkAclAssociationSet'][0]['NetworkAclId']
            else:
                print(f"Subnet {subnet_id} not found.")
                return False

        if not network_acl_id:
            print("No Network ACL identified to update.")
            return False

        ec2_client.create_network_acl_entry(
            DryRun=False,
            NetworkAclId=network_acl_id,
            RuleNumber=rule_number,
            Protocol=protocol,
            RuleAction=action,
            Egress=egress,
            CidrBlock=cidr_block,
            IcmpTypeCode={
                'Code': icmp_type,
                'Type': icmp_type
            }
        )
        print(f"Successfully added/modified NACL rule {rule_number} to deny ICMP (Echo Request) on {network_acl_id} for {cidr_block}")
        return True
    except Exception as e:
        print(f"Error adding NACL rule: {e}")
        return False
lambda_handler(None, None)
