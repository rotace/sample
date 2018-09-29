# coding: utf-8

import socket
import scapy_socket

host = "10.0.2.15"
port = 50000

serversock = scapy_socket.ScapySocket()
# serversock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# serversock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
serversock.bind((host,port))
serversock.listen(10)

print("Waiting for connections...")
clientsock, client_address = serversock.accept()

print("Make Connection")
while True:
    rcvmsg = clientsock.recv(1024)
    print( "Recieved -> %s" % (rcvmsg) )
    if not rcvmsg:
        break
    print("Type message...")
    s_msg = input()
    if s_msg == "":
        break
    print("Wait...")
    
    clientsock.sendall(s_msg.encode("UTF-8"))
clientsock.close()