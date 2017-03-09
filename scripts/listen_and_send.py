#!/usr/bin/env python
import socket
import sys
from scapy.all import *


UDP_IP = "132.72.80.189"
UDP_PORT = 5005
interface ="mon0"
MAC_TRANS =  '14:cc:20:a9:02:86'
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def send_to_relayer(data):
	sock.sendto(data, (UDP_IP, UDP_PORT))

def sniffmgmt(p):
#	print p.show()
	send_to_relayer(str(p[1]))

def main(argv):
	sniff(iface=interface, prn=sniffmgmt,  lfilter=lambda(x): x.addr2 == MAC_TRANS, store = 0)


if __name__ == "__main__":
    main(sys.argv)
