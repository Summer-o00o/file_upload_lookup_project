package com.example.fileuploadlookup.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.example.fileuploadlookup.model.FileMetadata;
import com.example.fileuploadlookup.service.MetadataService;
import com.example.fileuploadlookup.model.SaveMetadataRequest;



@RestController
@RequestMapping("/api/metadata")
public class MetadataController {
    private final MetadataService metadataService;

    public MetadataController(MetadataService metadataService) {
        this.metadataService = metadataService;
    }

    @PostMapping
    public FileMetadata saveMetadata(@RequestBody SaveMetadataRequest request) {
    
        FileMetadata metadata = new FileMetadata();
        metadata.setFileName(request.getFileName());
        metadata.setS3Key(request.getS3Key());
    
        return metadataService.saveMetadata(metadata);
    }
}
