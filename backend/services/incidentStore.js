const fs = require("fs/promises");
const path = require("path");
const crypto = require("crypto");

const dataDir = path.join(__dirname, "..", "data");
const dataFile = path.join(dataDir, "incidents.json");

async function ensureStore() {
  await fs.mkdir(dataDir, { recursive: true });

  try {
    await fs.access(dataFile);
  } catch {
    await fs.writeFile(dataFile, "[]", "utf8");
  }
}

async function readIncidents() {
  await ensureStore();

  const raw = await fs.readFile(dataFile, "utf8");

  return JSON.parse(raw || "[]");
}

async function writeIncidents(incidents) {
  await ensureStore();

  await fs.writeFile(
    dataFile,
    JSON.stringify(incidents, null, 2),
    "utf8"
  );
}

async function createIncident(payload) {
  const incidents = await readIncidents();

  const incident = {
    _id: crypto.randomUUID(),
    title: payload.title,
    description: payload.description,
    category: payload.category,
    priority: payload.priority,
    location: payload.location,
    status: "Reported",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  incidents.unshift(incident);
  await writeIncidents(incidents);

  return incident;
}

async function getIncidents() {
  const incidents = await readIncidents();

  return incidents.sort(
    (left, right) => new Date(right.createdAt) - new Date(left.createdAt)
  );
}

async function updateIncidentStatus(id, status) {
  const incidents = await readIncidents();
  const index = incidents.findIndex((incident) => incident._id === id);

  if (index === -1) {
    return null;
  }

  incidents[index] = {
    ...incidents[index],
    status,
    updatedAt: new Date().toISOString(),
  };

  await writeIncidents(incidents);

  return incidents[index];
}

async function deleteIncident(id) {
  const incidents = await readIncidents();
  const nextIncidents = incidents.filter((incident) => incident._id !== id);

  if (nextIncidents.length === incidents.length) {
    return false;
  }

  await writeIncidents(nextIncidents);

  return true;
}

module.exports = {
  createIncident,
  getIncidents,
  updateIncidentStatus,
  deleteIncident,
};