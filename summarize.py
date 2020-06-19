#!/usr/bin/python3

import netaddr
from netaddr import IPNetwork
import sys

fh     = open (sys.argv[1], 'r')
iplist = list()
for addr in fh:
    addr = IPNetwork(addr.strip())
    iplist.append (addr)

fh.close()
for net in netaddr.cidr_merge(iplist):
    print (net.cidr)



