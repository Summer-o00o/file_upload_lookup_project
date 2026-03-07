package com.example.fileuploadlookup.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.example.fileuploadlookup.model.FileMetadata;
import com.example.fileuploadlookup.service.MetadataService;



@RestController
@RequestMapping("/api")
public class MetadataController {
    private final MetadataService metadataService;

    public MetadataController(MetadataService metadataService) {
        this.metadataService = metadataService;
    }

    @PostMapping("/metadata")
    public FileMetadata saveMetadata(@RequestBody FileMetadata metadata) {
        return metadataService.saveMetadata(metadata);
    }
}
