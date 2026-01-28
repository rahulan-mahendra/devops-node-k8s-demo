import express from "express";
import healthRoute from "./routes/health.js";
import infoRoute from "./routes/info.js";
import crashRoute from "./routes/crash.js";

const app = express();

app.use("/health", healthRoute);
app.use("/info", infoRoute);
app.use("/crash", crashRoute);

export default app;
