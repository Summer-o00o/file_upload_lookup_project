import { useState } from "react";
import { getUploadUrl, saveMetadata } from "../services/api";

export default function UploadPage() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [message, setMessage] = useState("");

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleUpload = async () => {
    if (!selectedFile) {
      setMessage("Please select a file first.");
      return;
    }

    try {
      setMessage("Uploading...");

      const uploadResponse = await getUploadUrl(selectedFile.name);
      const { uploadUrl, s3Key } = uploadResponse;

      await fetch(uploadUrl, {
        method: "PUT",
        body: selectedFile,
      });

      await saveMetadata(selectedFile.name, s3Key);

      setMessage("File uploaded successfully.");
      setSelectedFile(null);
    } catch (error) {
      console.error(error);
      setMessage("Upload failed.");
    }
  };

  return (
    <div>
      <h2>Upload File</h2>
      <input type="file" onChange={handleFileChange} />
      <button onClick={handleUpload}>Upload</button>
      <p>{message}</p>
    </div>
  );
}