
package com.aura.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class HuggingFaceConnectionTest {

    private static final String SPACE_URL =
            "https://fashn-ai-fashn-vton-1-5.hf.space";

    public static void main(String[] args) {

        String token = System.getenv("HF_TOKEN");

        if (token == null || token.isBlank()) {
            System.out.println("ERROR: HF_TOKEN was not found.");
            System.out.println(
                "Check your Windows environment variable and restart Eclipse."
            );
            return;
        }

        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(20))
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();

        try {
            System.out.println("Connecting to FASHN VTON...");
            System.out.println("Checking API documentation only.");

            HttpResponse<String> response = sendRequest(
                    client,
                    token,
                    SPACE_URL + "/gradio_api/info"
            );

            if (response.statusCode() == 404) {
                response = sendRequest(
                        client,
                        token,
                        SPACE_URL + "/gradio_api/openapi.json"
                );
            }

            System.out.println(
                "HTTP Status: " + response.statusCode()
            );

            if (response.statusCode() >= 200
                    && response.statusCode() < 300) {

                System.out.println(
                    "SUCCESS: The hosted API responded."
                );

                System.out.println(
                    "API documentation response:\n"
                    + response.body()
                );

            } else {
                System.out.println(
                    "The hosted Space returned an error."
                );

                if (response.statusCode() == 401
                        || response.statusCode() == 403) {
                    System.out.println(
                        "Check token validity and permissions."
                    );
                } else if (response.statusCode() >= 500) {
                    System.out.println(
                        "The Space may be starting or temporarily unavailable."
                    );
                }

                System.out.println(
                    "Response: " + response.body()
                );
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("The request was interrupted.");

        } catch (Exception e) {
            System.out.println(
                "Connection failed: " + e.getMessage()
            );
        }
    }

    private static HttpResponse<String> sendRequest(
            HttpClient client,
            String token,
            String url
    ) throws Exception {

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(45))
                .header("Authorization", "Bearer " + token)
                .header("Accept", "application/json")
                .GET()
                .build();

        return client.send(
                request,
                HttpResponse.BodyHandlers.ofString()
        );
    }
}
