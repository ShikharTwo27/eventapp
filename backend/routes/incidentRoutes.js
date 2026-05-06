const express = require("express");
const router = express.Router();

const Incident = require("../models/Incident");



// CREATE INCIDENT
router.post("/create", async (req, res) => {

    try {

        const newIncident = new Incident({

            incidentId: "INC-" + Date.now(),

            title: req.body.title,
            description: req.body.description,
            category: req.body.category,
            priority: req.body.priority,
            location: req.body.location
        });

        const savedIncident =
        await newIncident.save();

        res.status(201).json(savedIncident);

    } catch (error) {

        res.status(500).json({
            message: error.message
        });
    }
});



// GET ALL INCIDENTS
router.get("/", async (req, res) => {

    try {

        const priorityOrder = {

            Critical: 4,
            High: 3,
            Medium: 2,
            Low: 1
        };

        const incidents =
        await Incident.find();

        incidents.sort((a, b) => {

            if (
                priorityOrder[b.priority] !==
                priorityOrder[a.priority]
            ) {

                return (
                    priorityOrder[b.priority] -
                    priorityOrder[a.priority]
                );
            }

            return (
                new Date(a.createdAt) -
                new Date(b.createdAt)
            );
        });

        res.status(200).json(incidents);

    } catch (error) {

        res.status(500).json({
            message: error.message
        });
    }
});



// UPDATE INCIDENT STATUS
router.put(
    "/update-status/:id",
    async (req, res) => {

        try {

            const updatedIncident =
            await Incident.findByIdAndUpdate(

                req.params.id,

                {
                    status: req.body.status
                },

                { new: true }
            );

            res.status(200).json(
                updatedIncident
            );

        } catch (error) {

            res.status(500).json({
                message: error.message
            });
        }
    }
);



// DELETE INCIDENT
router.delete(
    "/delete/:id",
    async (req, res) => {

        try {

            await Incident.findByIdAndDelete(
                req.params.id
            );

            res.status(200).json({

                message:
                "Incident Deleted Successfully"
            });

        } catch (error) {

            res.status(500).json({
                message: error.message
            });
        }
    }
);


module.exports = router;