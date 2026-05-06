const express = require("express");
const cors = require("cors");

require("dotenv").config();
const incidentRoutes = require("./routes/incidentRoutes");
const app = express();

// MIDDLEWARE
app.use(
  cors({
    origin: "*",
  })
);

app.use(express.json());

// TEST ROUTE
app.get("/", (req, res) => {
  res.send("Backend Running");
});

// ROUTES
app.use("/api/incidents", incidentRoutes);

// SERVER START
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
