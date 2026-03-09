/*
package com.example.filelookup;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.ScanRequest;
import software.amazon.awssdk.services.dynamodb.model.ScanResponse;

import java.util.HashMap;
import java.util.Map;

public class FileLookupHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    private final DynamoDbClient dynamoDbClient = DynamoDbClient.create();

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context context) {

        ScanRequest scanRequest = ScanRequest.builder()
                .tableName("file_metadata")
                .build();

        ScanResponse response = dynamoDbClient.scan(scanRequest);

        Map<String, Object> result = new HashMap<>();

        result.put("statusCode", 200);
        result.put("body", response.items().toString());

        return result;
    }
}
 */