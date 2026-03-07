package com.example.fileuploadlookup.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
//@RequestMapping("/api/upload")
public class UploadController {

    @GetMapping("/health")
    public String healthCheck() {
        return "Backend is running";
    }
}
