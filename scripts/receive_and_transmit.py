#!/usr/bin/env python
import socket
import sys
from scapy.all import *
UDP_IP = "132.72.80.189"
UDP_PORT=5006

sock=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('', UDP_PORT))

def main(argv):
	print "starting"
	s = conf.L2socket(iface="mon0")
	while True:
		data, addr = sock.recvfrom(1024) # buffer size is 1024 byte
		p = RadioTap()/Dot11(data)
#		p.show()
#		print p.show()
		s.send(p)
#		print "transmitting"
if __name__ == "__main__":
    main(sys.argv)

