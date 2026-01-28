import { Router } from "express";

const router = Router();

router.get("/", () => {
  process.exit(1);
});

export default router;
