const express = require("express");

const router = express.Router();

const {
  createIncident,
  getIncidents,
  updateIncidentStatus,
  deleteIncident,
} = require("../services/incidentStore");



// CREATE INCIDENT
router.post("/create",
async (req, res) => {

  try {
    const incident = await createIncident({
      title: req.body.title,
      description: req.body.description,
      category: req.body.category,
      priority: req.body.priority,
      location: req.body.location,
    });

    res.status(201).json({

      message:
      "Incident Created",

      incident,
    });

  } catch (error) {

    res.status(500).json({

      message:
      error.message,
    });
  }
});



// GET ALL INCIDENTS
router.get("/",
async (req, res) => {

  try {

    const incidents = await getIncidents();

    res.status(200).json(
        incidents);

  } catch (error) {

    res.status(500).json({

      message:
      error.message,
    });
  }
});



// UPDATE STATUS
router.put(
"/update-status/:id",

async (req, res) => {

  try {

    const updatedIncident = await updateIncidentStatus(
      req.params.id,
      req.body.status
    );

    if (!updatedIncident) {
      return res.status(404).json({
        message: "Incident not found",
      });
    }

    res.status(200).json({

      message:
      "Status Updated",

      updatedIncident,
    });

  } catch (error) {

    res.status(500).json({

      message:
      error.message,
    });
  }
});



// DELETE INCIDENT
router.delete(
"/delete/:id",

async (req, res) => {

  try {

    const deleted = await deleteIncident(req.params.id);

    if (!deleted) {
      return res.status(404).json({
        message: "Incident not found",
      });
    }

    res.status(200).json({

      message:
      "Incident Deleted",
    });

  } catch (error) {

    res.status(500).json({

      message:
      error.message,
    });
  }
});



module.exports = router;