package com.example.fileuploadlookup.model;

import lombok.Data;

import java.net.URL;

@Data
public class S3ServiceResponse {

    private URL uploadUrl;
    private String s3Key;

}
