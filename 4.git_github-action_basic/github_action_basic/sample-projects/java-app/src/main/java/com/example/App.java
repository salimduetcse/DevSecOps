package com.example;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {

    public static void main(String[] args) throws IOException {
        int port = 8080;
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", exchange ->
                sendResponse(exchange, 200, "Hello from Java App!"));

        server.createContext("/health", exchange ->
                sendResponse(exchange, 200, "{\"status\":\"healthy\",\"app\":\"java-basic-app\"}"));

        server.setExecutor(null);
        server.start();

        System.out.println("Java server running on port " + port);
    }

    private static void sendResponse(HttpExchange exchange, int statusCode, String body)
            throws IOException {
        byte[] bytes = body.getBytes();
        exchange.getResponseHeaders().set("Content-Type", "text/plain");
        exchange.sendResponseHeaders(statusCode, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(bytes);
        }
    }
}
