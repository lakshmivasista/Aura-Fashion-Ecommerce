
package com.aura.util;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;
import java.util.Locale;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.Gson;

public class FashnTryOnService {

    private static final String SPACE_URL =
            "https://fashn-ai-fashn-vton-1-5.hf.space";

    private static final String TRY_ON_ENDPOINT =
            SPACE_URL + "/gradio_api/call/try_on";

    private static final int MAX_IMAGE_SIZE =
            10 * 1024 * 1024;

    private final String token;
    private final HttpClient httpClient;
    private final Gson gson;

    public FashnTryOnService() {

        token = System.getenv("HF_TOKEN");

        if (token == null || token.isBlank()) {
            throw new IllegalStateException(
                "HF_TOKEN is not configured. Check your Windows environment variables."
            );
        }

        httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();

        gson = new Gson();
    }

    /**
     * Generates a virtual try-on image using the hosted FASHN Space.
     *
     * @param personBytes customer's photo bytes
     * @param personMimeType MIME type of the customer's photo
     * @param personFileName original customer photo filename
     * @param garmentBytes selected product image bytes
     * @param garmentMimeType MIME type of the product image
     * @param garmentFileName product image filename
     * @param category tops, bottoms, or one-pieces
     * @param garmentPhotoType model or flat-lay
     * @return generated image bytes
     */
    public byte[] generateTryOn(
            byte[] personBytes,
            String personMimeType,
            String personFileName,
            byte[] garmentBytes,
            String garmentMimeType,
            String garmentFileName,
            String category,
            String garmentPhotoType)
            throws IOException, InterruptedException {

        validateImage(
            personBytes, personMimeType, "Customer photo"
        );

        validateImage(
            garmentBytes, garmentMimeType, "Product image"
        );

        validateCategory(category);
        validateGarmentPhotoType(garmentPhotoType);

        System.out.println(
            "Submitting virtual try-on request to FASHN..."
        );

        JsonArray inputs = new JsonArray();

        inputs.add(createImageInput(
            personBytes,
            personMimeType,
            personFileName
        ));

        inputs.add(createImageInput(
            garmentBytes,
            garmentMimeType,
            garmentFileName
        ));

        inputs.add(category);
        inputs.add(garmentPhotoType);

        // Generation settings
        inputs.add(25);       // Sampling steps: 10-50
        inputs.add(1.5);      // Guidance scale: 1.0-3.0
        inputs.add(42);       // Seed
        inputs.add(true);     // Segmentation-free mode

        JsonObject requestBody = new JsonObject();
        requestBody.add("data", inputs);

        HttpRequest submitRequest = HttpRequest.newBuilder()
                .uri(URI.create(TRY_ON_ENDPOINT))
                .timeout(Duration.ofSeconds(60))
                .header(
                    "Authorization",
                    "Bearer " + token
                )
                .header(
                    "Content-Type",
                    "application/json"
                )
                .header(
                    "Accept",
                    "application/json"
                )
                .POST(
                    HttpRequest.BodyPublishers.ofString(
                        gson.toJson(requestBody),
                        StandardCharsets.UTF_8
                    )
                )
                .build();

        HttpResponse<String> submitResponse =
                httpClient.send(
                    submitRequest,
                    HttpResponse.BodyHandlers.ofString()
                );

        if (submitResponse.statusCode() < 200
                || submitResponse.statusCode() >= 300) {

            throw new IOException(
                "FASHN rejected the request. HTTP "
                + submitResponse.statusCode()
                + ": "
                + shorten(submitResponse.body())
            );
        }

        JsonObject submitJson;

        try {
            submitJson = JsonParser.parseString(
                submitResponse.body()
            ).getAsJsonObject();
        } catch (RuntimeException e) {
            throw new IOException(
                "Could not read the FASHN submission response.",
                e
            );
        }

        JsonElement eventIdElement =
                submitJson.get("event_id");

        if (eventIdElement == null
                || eventIdElement.isJsonNull()
                || !eventIdElement.isJsonPrimitive()) {

            throw new IOException(
                "FASHN did not return an event ID. Response: "
                + shorten(submitResponse.body())
            );
        }

        String eventId = eventIdElement.getAsString();

        if (eventId.isBlank()
                || !eventId.matches("[a-zA-Z0-9_-]+")) {

            throw new IOException(
                "FASHN returned an invalid event ID."
            );
        }

        System.out.println(
            "Request submitted. Waiting for the generated image..."
        );

        String resultData = waitForResult(eventId);

        JsonElement resultElement;

        try {
            resultElement = JsonParser.parseString(resultData);
        } catch (RuntimeException e) {
            throw new IOException(
                "Could not parse the FASHN generation result.",
                e
            );
        }

        if (!resultElement.isJsonArray()
                || resultElement.getAsJsonArray().isEmpty()) {

            throw new IOException(
                "FASHN returned no generated image."
            );
        }

        JsonElement imageElement =
                resultElement.getAsJsonArray().get(0);

        if (!imageElement.isJsonObject()) {
            throw new IOException(
                "FASHN returned an unexpected image format."
            );
        }

        JsonObject imageObject =
                imageElement.getAsJsonObject();

        String outputUrl = getString(
            imageObject, "url"
        );

        String outputPath = getString(
            imageObject, "path"
        );

        return downloadGeneratedImage(
            outputUrl,
            outputPath
        );
    }

    private String waitForResult(String eventId)
            throws IOException, InterruptedException {

        String eventUrl =
                TRY_ON_ENDPOINT + "/" + eventId;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(eventUrl))
                .timeout(Duration.ofMinutes(8))
                .header(
                    "Authorization",
                    "Bearer " + token
                )
                .header(
                    "Accept",
                    "text/event-stream"
                )
                .GET()
                .build();

        HttpResponse<String> response =
                httpClient.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
                );

        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            throw new IOException(
                "Could not retrieve the FASHN result. HTTP "
                + response.statusCode()
                + ": "
                + shorten(response.body())
            );
        }

        String currentEvent = "";
        String completedData = null;
        String errorData = null;

        for (String line : response.body().split("\\R")) {

            if (line.startsWith("event:")) {
                currentEvent =
                    line.substring(6).trim();

            } else if (line.startsWith("data:")) {

                String data =
                    line.substring(5).trim();

                if ("complete".equals(currentEvent)) {
                    completedData = data;

                } else if ("error".equals(currentEvent)) {
                    errorData = data;
                }
            }
        }

        if (errorData != null) {
            throw new IOException(
                "FASHN image generation failed: "
                + shorten(errorData)
            );
        }

        if (completedData == null
                || completedData.isBlank()) {

            throw new IOException(
                "FASHN did not return a completed result. "
                + "The request may have timed out or been interrupted."
            );
        }

        return completedData;
    }

    private JsonObject createImageInput(
            byte[] imageBytes,
            String mimeType,
            String fileName) {

        String base64 = Base64.getEncoder()
                .encodeToString(imageBytes);

        String dataUri =
                "data:" + mimeType + ";base64," + base64;

        JsonObject image = new JsonObject();

        // Gradio accepts a public URL or a base64 data URI.
        image.addProperty("url", dataUri);
        image.add("path", JsonNull.INSTANCE);
        image.addProperty("size", imageBytes.length);

        String safeName = sanitizeFileName(fileName);

        image.addProperty("orig_name", safeName);
        image.addProperty("mime_type", mimeType);
        image.addProperty("is_stream", false);

        JsonObject metadata = new JsonObject();
        metadata.addProperty("_type", "gradio.FileData");

        image.add("meta", metadata);

        return image;
    }

    private byte[] downloadGeneratedImage(
            String outputUrl,
            String outputPath)
            throws IOException, InterruptedException {

        if (outputUrl != null
                && outputUrl.startsWith("data:")) {

            int comma = outputUrl.indexOf(',');

            if (comma < 0) {
                throw new IOException(
                    "Invalid generated image data URI."
                );
            }

            try {
                return Base64.getDecoder().decode(
                    outputUrl.substring(comma + 1)
                );
            } catch (IllegalArgumentException e) {
                throw new IOException(
                    "Could not decode the generated image.",
                    e
                );
            }
        }

        String downloadUrl = outputUrl;

        if (downloadUrl == null || downloadUrl.isBlank()) {

            if (outputPath == null || outputPath.isBlank()) {
                throw new IOException(
                    "FASHN returned neither an image URL nor a file path."
                );
            }

            if (outputPath.startsWith("https://")
                    || outputPath.startsWith("http://")) {

                downloadUrl = outputPath;

            } else if (outputPath.startsWith(
                    "/gradio_api/file=")) {

                downloadUrl = SPACE_URL + outputPath;

            } else {

                String normalizedPath = outputPath.startsWith("/")
                        ? outputPath
                        : "/" + outputPath;

                downloadUrl = SPACE_URL
                        + "/gradio_api/file="
                        + normalizedPath;
            }

        } else if (downloadUrl.startsWith("/")) {

            downloadUrl = SPACE_URL + downloadUrl;
        }

        URI resultUri;

        try {
            resultUri = URI.create(downloadUrl);
        } catch (IllegalArgumentException e) {
            throw new IOException(
                "FASHN returned an invalid image URL.",
                e
            );
        }

        String scheme = resultUri.getScheme();

        if (!"https".equalsIgnoreCase(scheme)
                && !"http".equalsIgnoreCase(scheme)) {

            throw new IOException(
                "The generated image URL has an unsupported scheme."
            );
        }

        // Only download from the configured Space to avoid
        // sending the Hugging Face token to an unrelated host.
        if (!SPACE_URL.equalsIgnoreCase(
                resultUri.getScheme() + "://" + resultUri.getAuthority())) {

            throw new IOException(
                "The generated image URL is outside the configured FASHN Space."
            );
        }

        HttpRequest downloadRequest = HttpRequest.newBuilder()
                .uri(resultUri)
                .timeout(Duration.ofMinutes(2))
                .header(
                    "Authorization",
                    "Bearer " + token
                )
                .header(
                    "Accept",
                    "image/*"
                )
                .GET()
                .build();

        HttpResponse<byte[]> downloadResponse =
                httpClient.send(
                    downloadRequest,
                    HttpResponse.BodyHandlers.ofByteArray()
                );

        if (downloadResponse.statusCode() < 200
                || downloadResponse.statusCode() >= 300) {

            throw new IOException(
                "Could not download the generated image. HTTP "
                + downloadResponse.statusCode()
            );
        }

        String contentType = downloadResponse.headers()
                .firstValue("Content-Type")
                .orElse("")
                .toLowerCase(Locale.ROOT);

        if (!contentType.startsWith("image/")) {
            throw new IOException(
                "The FASHN result download was not an image."
            );
        }

        byte[] imageBytes = downloadResponse.body();

        if (imageBytes == null || imageBytes.length == 0) {
            throw new IOException(
                "The generated image was empty."
            );
        }

        return imageBytes;
    }

    private void validateImage(
            byte[] bytes,
            String mimeType,
            String label) {

        if (bytes == null || bytes.length == 0) {
            throw new IllegalArgumentException(
                label + " is required."
            );
        }

        if (bytes.length > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                label + " must not exceed 10 MB."
            );
        }

        if (mimeType == null
                || !(mimeType.equalsIgnoreCase("image/jpeg")
                || mimeType.equalsIgnoreCase("image/png")
                || mimeType.equalsIgnoreCase("image/webp"))) {

            throw new IllegalArgumentException(
                label + " must be a JPEG, PNG, or WebP image."
            );
        }
    }

    private void validateCategory(String category) {

        if (!("tops".equals(category)
                || "bottoms".equals(category)
                || "one-pieces".equals(category))) {

            throw new IllegalArgumentException(
                "Category must be tops, bottoms, or one-pieces."
            );
        }
    }

    private void validateGarmentPhotoType(String photoType) {

        if (!("model".equals(photoType)
                || "flat-lay".equals(photoType))) {

            throw new IllegalArgumentException(
                "Garment photo type must be model or flat-lay."
            );
        }
    }

    private String getString(
            JsonObject object,
            String key) {

        if (!object.has(key)
                || object.get(key).isJsonNull()
                || !object.get(key).isJsonPrimitive()) {
            return null;
        }

        return object.get(key).getAsString();
    }

    private String sanitizeFileName(String fileName) {

        if (fileName == null || fileName.isBlank()) {
            return "image.jpg";
        }

        String sanitized = fileName
                .replace("\\", "/");

        int lastSlash = sanitized.lastIndexOf('/');

        if (lastSlash >= 0) {
            sanitized = sanitized.substring(lastSlash + 1);
        }

        sanitized = sanitized.replaceAll(
            "[^a-zA-Z0-9._-]",
            "_"
        );

        if (sanitized.isBlank()) {
            return "image.jpg";
        }

        return sanitized;
    }

    private String shorten(String value) {

        if (value == null || value.isBlank()) {
            return "(no details supplied)";
        }

        String cleaned = value.replaceAll("\\s+", " ").trim();

        if (cleaned.length() > 500) {
            return cleaned.substring(0, 500) + "...";
        }

        return cleaned;
    }
}
