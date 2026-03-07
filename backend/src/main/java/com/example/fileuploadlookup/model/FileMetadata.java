package com.example.fileuploadlookup.model;

import lombok.Data;
import java.time.Instant;

@Data // This annotation generates getters, setters, equals, hashCode, and toString methods
public class FileMetadata {

    private String fileId;
    private String fileName;
    private String s3Key;
    private Instant uploadTime;

}