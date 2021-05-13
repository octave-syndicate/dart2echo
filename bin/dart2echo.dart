import 'dart:io';

void main(List<String> arguments) {
  ServerSocket serverSocket;
  Socket clientSocket;

  void disconnectClient() {
    if (clientSocket != null) {
      clientSocket.close();
      clientSocket.destroy();
    }
    clientSocket = null;
  }

  void handleClient(Socket client) {
    clientSocket = client;

    print(
        'A new client has connected from ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}');

    clientSocket.listen(
      (onData) {
        print(String.fromCharCodes(onData).trim());
        clientSocket.write(String.fromCharCodes(onData));
      },
      onError: (e) {
        print(e.toString());
        disconnectClient();
      },
      onDone: () {
        print('Connection has terminated.');
        disconnectClient();
      },
    );
  }

  void startServer() async {
    print('Starting server.');
    serverSocket =
        await ServerSocket.bind(InternetAddress.anyIPv4, 4321, shared: true);
    print('Server listening on port 4321 on all IPv4 addresses.');
    serverSocket.listen(handleClient);
  }

  startServer();
}
