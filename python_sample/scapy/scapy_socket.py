# coding: utf-8

import queue
import threading
from scapy.all import *

class ScapySocket():
    def __init__(self):
        super().__init__()
        self.recv_pkt = None
        self.shost = None
        self.sport = None
        self.dhost = None
        self.dport = None
        self.n_seq = None
        self.n_ack = None
        self.n_listen = 1
        self.ip = None

        self._thread = None
        self._stop_event = threading.Event()
        self._pkt_queue = queue.Queue()

    def bind(self, args):
        print ("########## bind()")
        self.shost, self.sport = args

    def listen(self, n_listen):
        print ("########## listen()")
        self.n_listen = n_listen

    def connect(self, args):
        print ("########## connect()")
        self.dhost, self.dport = args
        self.ip = IP(dst=self.dhost)

        syn = self.ip/TCP(  dport=self.dport,
                            flags='S'
                            )

        self.shost = syn[IP].src
        self.sport = syn[TCP].sport
        
        syn_ack = sr1(syn)
        self._recv(syn_ack)

        ack = self.ip/TCP(  sport=self.sport,
                            dport=self.dport,
                            seq=self.n_ack,
                            ack=self.n_seq + 1,
                            flags='A'
                            )
        
        self._start()
        send(ack)

    def accept(self):
        print ("########## accept()")
        fil_str  = "ip and tcp"
        fil_str += " and (dst {0}) and (port {1})".format(self.shost, self.sport)
        fil_str += " and (tcp[tcpflags] == tcp-syn or tcp[tcpflags] == tcp-ack)"

        pkts = sniff(filter=fil_str, count=1, timeout=1000)
        pkt  = pkts[0]
        self._recv(pkt)

        syn_ack = self.ip/TCP(  sport=self.sport,
                                dport=self.dport,
                                seq=1,
                                ack=self.n_seq + 1,
                                flags="SA"
                                )

        client_sock = ScapySocket()
        client_sock.shost = self.shost
        client_sock.sport = self.sport
        client_sock.dhost = self.dhost
        client_sock.dport = self.dport
        client_sock.ip = IP(src=self.shost, dst=self.dhost)
        client_sock.n_seq = self.n_seq

        client_sock._start()
        send(syn_ack)

        return client_sock, (self.dhost, self.dport)

    def recv(self, n_buffer):
        print ("########## recv()")
        pkt = self._pkt_queue.get()
        self._recv(pkt)
        pkt.show()
        message  = pkt[Raw].load


        if   pkt.sprintf('%TCP.flags%') == "PA" :
            ack = self.ip/TCP(  sport=self.sport,
                                dport=self.dport,
                                seq=self.n_ack,
                                ack=self.n_seq + len(message),
                                flags="A"
                                )
            send(ack)
     
        return message

    def send(self, message):
        print ("########## send()")
        if not message:
            self.close()
        else:
            pkt = self.ip/TCP(  sport=self.sport,
                                dport=self.dport,
                                seq=self.n_ack,
                                ack=self.n_seq + 1,
                                flags="PA"
                                )/message
            ack = sr1(pkt)
            self._recv(ack)
            
        return len(message)

    def sendall(self, message):
        print ("########## sendall()")
        while True:
            # 送信できたバイト数が返ってくる
            sent_len = self.send(message)
            # 全て送れたら完了
            if sent_len == len(message):
                break
            # 送れなかった分をもう一度送る
            message = message[sent_len:]
    
    def close(self):
        print ("########## close()")
        pkt = self.ip/TCP(  sport=self.sport,
                            dport=self.dport,
                            seq=self.n_ack,
                            ack=self.n_seq + 1,
                            flags="FA"
                            )
        send(pkt)
        # initialize dst
        self.dhost = None
        self.dport = None
        self.ip = None

    def _recv(self, pkt):
        self.recv_pkt = pkt
        self.n_seq = pkt[TCP].seq
        self.n_ack = pkt[TCP].ack

        if self.dhost is None:
            self.dhost = pkt[IP].src
            self.dport = pkt[TCP].sport
            self.ip = IP(src=self.shost, dst=self.dhost)
    
    def _start(self):
        self._thread = threading.Thread(target=self._listen)
        self._thread.start()

    def _listen(self):
        fil_str  = "ip and tcp"
        fil_str += " and (src {0})".format(self.dhost)
        fil_str += " and (dst {0}) and (port {1})".format(self.shost, self.sport)
        sniff(  filter=fil_str,
                prn=self._queuing,
                stop_filter=lambda p: self._stop_event.is_set()
                )

    def _queuing(self, pkt):
        if  pkt[IP].src == self.dhost and \
            pkt[IP].dst == self.shost and \
            pkt[TCP].sport == self.dport and \
            pkt[TCP].dport == self.sport and \
            pkt[TCP].flags != 'A':
            self._pkt_queue.put(pkt)
    
    def _stop(self):
        self._stop_event.set()
        self._thread.join()
