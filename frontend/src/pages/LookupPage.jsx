import { useEffect, useState } from "react";
import { getFiles } from "../services/api";

export default function LookupPage() {
  const [files, setFiles] = useState([]);

  useEffect(() => {
    const fetchFiles = async () => {
      try {
        const data = await getFiles();
        setFiles(data);
      } catch (error) {
        console.error(error);
      }
    };

    fetchFiles();
  }, []);

  return (
    <div>
      <h2>Uploaded Files</h2>
      {files.length === 0 ? (
        <p>No files found.</p>
      ) : (
        <ul>
          {files.map((file) => (
            <li key={file.fileId}>
              <strong>{file.fileName}</strong> — {file.s3Key}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}