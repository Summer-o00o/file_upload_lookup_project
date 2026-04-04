import { useState } from "react";
import { uploadFile } from "../services/fileUploadService";

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
      await uploadFile(selectedFile);
      setMessage("File uploaded successfully.");
      setSelectedFile(null);
    } catch (error) {
      console.error(error);
      setMessage("Upload failed.");
    }
  };

  return (
    <>
      <header className="app-header">
        <h2 className="title">Upload File</h2>
        <p className="subtitle">Please Choose a file to upload.</p>
      </header>

      <section className="card">
        <div className="card-body upload-card-body">
          <input type="file" onChange={handleFileChange} />
          <button type="button" className="btn btn-primary" onClick={handleUpload}>
            Upload
          </button>
          {message ? <p className="empty text-center">{message}</p> : null}
        </div>
      </section>
    </>
  );
}