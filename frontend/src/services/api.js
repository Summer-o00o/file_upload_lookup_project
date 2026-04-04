// Connect React frontend to the API Gateway
import { API_BASE_URL } from "./fileUploadService";

export { getUploadUrl, saveMetadata, API_BASE_URL } from "./fileUploadService";

export const getFiles = async () => {
  const response = await fetch(`${API_BASE_URL}/api/files`);
  return response.json();
};
