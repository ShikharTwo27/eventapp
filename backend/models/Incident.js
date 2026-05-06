const mongoose = require("mongoose");

const incidentSchema = new mongoose.Schema({
    incidentId: {
        type: String,
        required: true,
        unique: true
    },

    title: {
        type: String,
        required: true
    },

    description: {
        type: String,
        required: true
    },

    category: {
        type: String,
        required: true
    },

    priority: {
        type: String,
        enum: ["Low", "Medium", "High", "Critical"],
        required: true
    },

    location: {
        type: String,
        required: true
    },

    status: {
        type: String,
        enum: ["Reported", "In Progress", "Resolved"],
        default: "Reported"
    },

    responder: {
        type: String,
        default: "Not Assigned"
    },

    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model("Incident", incidentSchema);