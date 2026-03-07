package com.example.fileuploadlookup.repository;

import com.example.fileuploadlookup.model.FileMetadata;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

import java.util.HashMap;
import java.util.Map;

@Repository
public class DynamoDBRepository {

    private final DynamoDbClient dynamoDbClient;

    private static final String TABLE_NAME = "file_metadata";

    public DynamoDBRepository(DynamoDbClient dynamoDbClient) {
        this.dynamoDbClient = dynamoDbClient;
    }

    public void save(FileMetadata metadata) {
        //AttributeValue is the data type wrapper used by the DynamoDB API.
        //DynamoDB does not accept raw Java values
        Map<String, AttributeValue> item = new HashMap<>();

        item.put("fileId", AttributeValue.builder().s(metadata.getFileId()).build());
        item.put("fileName", AttributeValue.builder().s(metadata.getFileName()).build());
        item.put("s3Key", AttributeValue.builder().s(metadata.getS3Key()).build());
        item.put("uploadTime", AttributeValue.builder().s(metadata.getUploadTime().toString()).build());

        PutItemRequest request = PutItemRequest.builder()
                .tableName(TABLE_NAME)
                .item(item)
                .build();

        dynamoDbClient.putItem(request);
    }
}