package com.example.fileuploadlookup.service;

import com.example.fileuploadlookup.model.FileMetadata;
import org.springframework.stereotype.Service;
import com.example.fileuploadlookup.repository.DynamoDBRepository;
import java.time.Instant;
import java.util.UUID;

@Service
public class MetadataService {

    private final DynamoDBRepository dynamoDBRepository;

    public MetadataService(DynamoDBRepository dynamoDBRepository) {
        this.dynamoDBRepository = dynamoDBRepository;
    }

    public FileMetadata saveMetadata(FileMetadata metadata) {
        metadata.setFileId(UUID.randomUUID().toString());
        metadata.setUploadTime(Instant.now());
        dynamoDBRepository.save(metadata);

        return metadata;
    }
}