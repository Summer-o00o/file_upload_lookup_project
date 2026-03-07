package com.example.fileuploadlookup.model;

import lombok.Data;

@Data
public class SaveMetadataRequest {

    private String fileName;
    private String s3Key;

}
