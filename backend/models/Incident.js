const mongoose =
require("mongoose");

const incidentSchema =
new mongoose.Schema({

  title: {

    type: String,

    required: true,
  },

  description: {

    type: String,

    required: true,
  },

  category: {

    type: String,

    required: true,
  },

  priority: {

    type: String,

    required: true,
  },

  location: {

    type: String,

    required: true,
  },

  status: {

    type: String,

    default: "Reported",
  },

}, {

  timestamps: true,
});

module.exports =
mongoose.model(
    "Incident",
    incidentSchema
);