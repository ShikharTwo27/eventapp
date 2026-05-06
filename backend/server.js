const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const incidentRoutes = require("./routes/incidentRoutes");
const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/incidents", incidentRoutes);
mongoose.connect("mongodb://127.0.0.1:27017/emergencyDB")
.then(() => console.log("MongoDB Connected"))
.catch((err) => console.log(err));

app.get("/", (req, res) => {
    res.send("Emergency Backend Running");
});

app.listen(5000, () => {
    console.log("Server running on port 5000");
});