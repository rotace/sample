# coding: utf-8

import time
import socket
import scapy_socket

host = "10.0.2.15"
port = 50000

client = scapy_socket.ScapySocket()
# client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((host, port))
time.sleep(1)
client.send(b"from client")
response = client.recv(4096)

print(response)

# client.close()
client.send(b"")