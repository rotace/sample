
import socket

host = "10.0.2.15"
port = 50000

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((host, port))
client.send(b"from client")
response = client.recv(4096)

print(response)

# client.close()
client.send(b"")