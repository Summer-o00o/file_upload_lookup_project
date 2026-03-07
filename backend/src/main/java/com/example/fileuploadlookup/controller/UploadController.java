package com.example.fileuploadlookup.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.fileuploadlookup.service.S3Service;
import com.example.fileuploadlookup.model.S3ServiceResponse;
import java.util.Map;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;

@RestController
@RequestMapping("/api/upload")
public class UploadController {

    private final S3Service s3Service;

    public UploadController(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    @PostMapping("/url")
    public S3ServiceResponse generateUploadUrl(@RequestBody Map<String, String> request) {
    
        String fileName = request.get("fileName");
    
        return s3Service.generateUploadUrlAndS3Key(fileName);
    }
}
