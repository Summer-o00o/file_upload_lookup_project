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
    <>
      <header className="app-header">
        <h1 className="title">Uploaded Files</h1>
        <p className="subtitle">Browse the latest uploads stored in S3.</p>
      </header>

      <section className="card">
        <div className="card-body">
          {files.length === 0 ? (
            <p className="empty text-center">No files found.</p>
          ) : (
            <ul className="file-list">
              {files.map((file) => (
                <li key={file.fileId} className="file-row">
                  <div className="file-meta">
                    <div className="file-name">{file.fileName}</div>
                    <div className="file-id">{file.fileId}</div>
                  </div>

                  <div className="actions">
                    <a
                      className="btn btn-primary"
                      href={`https://file-upload-lookup-bucket.s3.us-west-2.amazonaws.com/${file.s3Key}`}
                      target="_blank"
                      rel="noreferrer"
                    >
                      View file
                    </a>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>
    </>
  );
}