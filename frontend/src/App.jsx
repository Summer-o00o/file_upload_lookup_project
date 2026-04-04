import { Link, Routes, Route, Navigate } from "react-router-dom";
import UploadPage from "./pages/UploadPage";
import LookupPage from "./pages/LookupPage";

function App() {
  return (
    <div className="page">
      <div className="container">
        <header className="site-header">
          <h1 className="title">File Upload Lookup Platform</h1>
          <nav className="site-nav" aria-label="Main">
            <Link to="/upload">Upload</Link>
            <Link to="/files">Lookup Files</Link>
          </nav>
        </header>

        <main className="site-main">
          <Routes>
            <Route path="/" element={<Navigate to="/upload" replace />} />
            <Route path="/upload" element={<UploadPage />} />
            <Route path="/files" element={<LookupPage />} />
          </Routes>
        </main>
      </div>
    </div>
  );
}

export default App;