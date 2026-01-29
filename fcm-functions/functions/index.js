import { initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";
import { logger } from "firebase-functions";

initializeApp();

// Set default region
setGlobalOptions({ region: "asia-south2" });

export const sendNotification = onDocumentCreated("notices/{noticeId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    logger.warn("No data in snapshot.");
    return;
  }

  const notice = snapshot.data();

  const payload = {
    notification: {
      title: notice?.title || "New Notice",
      body: notice?.description || "Check the app for details",
    },
    topic: "all",
  };

  try {
    await getMessaging().send(payload);
    logger.info("Notification sent successfully");
  } catch (error) {
    logger.error("Error sending notification:", error);
  }
});
