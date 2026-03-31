import { Link, Routes, Route, Navigate } from "react-router-dom";
import UploadPage from "./pages/UploadPage";
import LookupPage from "./pages/LookupPage";

function App() {
  return (
    <div>
      <h1>File Upload Lookup Platform</h1>

      <nav style={{ marginBottom: "20px" }}>
        <Link to="/upload" style={{ marginRight: "12px" }}>
          Upload
        </Link>
        <Link to="/files">Lookup Files</Link>
      </nav>

      <Routes>
        <Route path="/" element={<Navigate to="/upload" replace />} />
        <Route path="/upload" element={<UploadPage />} />
        <Route path="/files" element={<LookupPage />} />
      </Routes>
    </div>
  );
}

export default App;