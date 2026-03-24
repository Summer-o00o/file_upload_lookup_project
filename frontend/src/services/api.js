//Connect react frontend to the api gateway
const API_BASE_URL = "https://z07qmg52sb.execute-api.us-west-2.amazonaws.com";

export const getUploadUrl = async (fileName) => {
  const response = await fetch(`${API_BASE_URL}/api/upload/url`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ fileName }),
  });

  return response.json();
};

export const saveMetadata = async (fileName, s3Key) => {
  const response = await fetch(`${API_BASE_URL}/api/metadata`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ fileName, s3Key }),
  });

  return response.json();
};

export const getFiles = async () => {
  const response = await fetch(`${API_BASE_URL}/api/files`);
  return response.json();
};