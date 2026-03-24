package com.example.fileuploadlookup.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.fileuploadlookup.service.S3Service;
import com.example.fileuploadlookup.model.S3ServiceResponse;
import com.example.fileuploadlookup.model.GenerateUploadUrlRequest;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/upload")
public class UploadController {

    private final S3Service s3Service;

    public UploadController(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    // generate upload url endpoint
    @PostMapping("/url")
    public S3ServiceResponse generateUploadUrl(@RequestBody GenerateUploadUrlRequest request) {
        String fileName = request.getFileName();
        return s3Service.generateUploadUrlAndS3Key(fileName);
    }

    // health check endpoint
    @GetMapping("/health")
    public String healthCheck() {
        return "Backend is running";
    }
}
