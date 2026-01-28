import { Router } from "express";
import os from "os";

const router = Router();

router.get("/", (req, res) => {
  res.json({
    app: process.env.APP_NAME || "devops-node-k8s-demo",
    env: process.env.APP_ENV || "dev",
    version: process.env.APP_VERSION || "0.0.0",
    hostname: os.hostname()
  });
});

export default router;
