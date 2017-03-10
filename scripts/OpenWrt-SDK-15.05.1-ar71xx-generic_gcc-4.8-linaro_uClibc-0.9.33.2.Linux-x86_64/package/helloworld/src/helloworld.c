#include <stdio.h>
#include <arpa/inet.h>
#include <sys/socket.h>
 #include <sys/types.h>
 #include <linux/if_packet.h>
 #include <net/ethernet.h>
#include <net/if.h>
#include <sys/ioctl.h>
#define BUFLEN 512  //Max length of buffer
#define REC_PORT 5006   //The port on which to listen for incoming data

int main(void)
{
    //monitor mode socket binding
    char* IFACE_NAME = "mon0";

    int fd_monitor;
    struct ifreq ifr;
    struct sockaddr_ll interfaceAddrMon;
    struct packet_mreq mreq;
    if ((fd_monitor = socket(PF_PACKET,SOCK_RAW,htons(ETH_P_ALL))) < 0)
    {
        printf("can't open socket\n");
        return -1;
    }

    memset(&interfaceAddrMon,0,sizeof(interfaceAddrMon));
    memset(&ifr,0,sizeof(ifr));
    memset(&mreq,0,sizeof(mreq));
    memcpy(&ifr.ifr_name,IFACE_NAME,IFNAMSIZ);
    ioctl(fd_monitor,SIOCGIFINDEX,&ifr);

    interfaceAddrMon.sll_ifindex = ifr.ifr_ifindex;
    interfaceAddrMon.sll_family = AF_PACKET;
    if (bind(fd_monitor, (struct sockaddr *)&interfaceAddrMon,sizeof(interfaceAddrMon)) < 0)
    {
        printf("can't bind socket\n");
        return -2;  
    }

    //udp socket binding

    struct sockaddr_in si_me, si_other;
     
    int fd_UDP, i, slen = sizeof(si_other) , recv_len;
    
     
    //create a UDP socket
    if ((fd_UDP=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
         printf("problem : socket() UDP");
        return -1;
    }

  

    unsigned char buffReceiveMonitor[BUFLEN];
    unsigned char buf[BUFLEN];
    

     // zero out the structure
    memset((char *) &si_me, 0, sizeof(si_me));
     
    si_me.sin_family = AF_INET;
    si_me.sin_port = htons(REC_PORT);
    si_me.sin_addr.s_addr = htonl(INADDR_ANY);
     


    //bind socket to port
    if( bind(fd_UDP , (struct sockaddr*)&si_me, sizeof(si_me) ) == -1)
    {
  			printf("problem : bind()");
            return -1;  
     }
     




    //keep listening for data
    while(1)
    {


      if ((recv_len = recvfrom(fd_UDP, buf, BUFLEN, 0,NULL, NULL)) == -1)
       {
             printf("problem : recvfrom()\n");
             return -1;
        }
          


        if (send(fd_monitor, buf,recv_len, 0) < 0)
        {
            printf("problem : recform()\n");
            return -1;
        }
        printf("receive n bytes: %d\n", recv_len);    



    }
 
    close(fd_UDP);

	return 0;
}

