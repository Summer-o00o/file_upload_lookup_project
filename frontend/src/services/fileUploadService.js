export const API_BASE_URL =
  "https://z07qmg52sb.execute-api.us-west-2.amazonaws.com";

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

export const uploadFile = async (file) => {
  const uploadResponse = await getUploadUrl(file.name);
  const { uploadUrl, s3Key } = uploadResponse;

  const s3Response = await fetch(uploadUrl, {
    method: "PUT",
    body: file,
  });

  if (!s3Response.ok) {
    throw new Error("Failed to upload file to S3");
  }

  const metadataResponse = await saveMetadata(file.name, s3Key);

  return metadataResponse;
};