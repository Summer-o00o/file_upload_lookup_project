package com.example.fileuploadlookup.service;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import com.example.fileuploadlookup.model.S3ServiceResponse;
import java.net.URL;
import java.time.Duration;
import java.util.UUID;

@Service
public class S3Service {

    private static final String BUCKET_NAME = "file-upload-lookup-bucket";

    public S3ServiceResponse generateUploadUrlAndS3Key(String fileName) {
        // Generate a unique S3 key for the file, the key will be used to identify the file in the S3 bucket
        // S3Key will be saved to DynamoDB table file_metadata
        String key = "uploads/" + UUID.randomUUID() + "-" + fileName;

        S3Presigner presigner = S3Presigner.builder()
                .region(Region.US_WEST_2)
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();

        PutObjectRequest objectRequest = PutObjectRequest.builder()
                .bucket(BUCKET_NAME)
                .key(key)
                .build();

        PutObjectPresignRequest presignRequest =
                PutObjectPresignRequest.builder()
                        .signatureDuration(Duration.ofMinutes(10))
                        .putObjectRequest(objectRequest)
                        .build();

        URL presignedUrl = presigner.presignPutObject(presignRequest).url();

        presigner.close();

        S3ServiceResponse response = new S3ServiceResponse();
        response.setUploadUrl(presignedUrl);
        response.setS3Key(key);

        return response;
    }
}