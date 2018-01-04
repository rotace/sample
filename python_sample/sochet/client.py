
import socket

host = "192.168.0.7"
port = 8080

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((host, port))
client.send(b"from client")
response = client.recv(4096)

print(response)