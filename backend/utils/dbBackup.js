const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");

const formatTimestamp = (date) => {
  const pad = (value) => String(value).padStart(2, "0");
  return `${date.getFullYear()}${pad(date.getMonth() + 1)}${pad(date.getDate())}_${pad(date.getHours())}${pad(date.getMinutes())}${pad(date.getSeconds())}`;
};

const createDbBackup = () => {
  const dbName = process.env.DB_NAME;
  const dbUser = process.env.DB_USER;
  const dbPass = process.env.DB_PASS;
  const dbHost = process.env.DB_HOST || "localhost";
  const dbPort = process.env.DB_PORT || "5432";
  const backupDir = process.env.DB_BACKUP_DIR || path.join(__dirname, "..", "backups");

  if (!dbName || !dbUser || !dbPass) {
    throw new Error("Variables DB_NAME, DB_USER et DB_PASS requises pour le backup.");
  }

  fs.mkdirSync(backupDir, { recursive: true });

  const filename = `${dbName}_${formatTimestamp(new Date())}.sql`;
  const outputPath = path.join(backupDir, filename);

  const args = [
    "-h",
    dbHost,
    "-p",
    dbPort,
    "-U",
    dbUser,
    "-d",
    dbName,
    "-F",
    "p",
    "-f",
    outputPath,
  ];

  return new Promise((resolve, reject) => {
    execFile("pg_dump", args, { env: { ...process.env, PGPASSWORD: dbPass } }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(`Echec backup DB: ${stderr || error.message}`));
        return;
      }

      resolve({ outputPath, stdout, stderr });
    });
  });
};

const restoreDbBackup = (backupFilePath) => {
  const dbName = process.env.DB_NAME;
  const dbUser = process.env.DB_USER;
  const dbPass = process.env.DB_PASS;
  const dbHost = process.env.DB_HOST || "localhost";
  const dbPort = process.env.DB_PORT || "5432";

  if (!dbName || !dbUser || !dbPass) {
    throw new Error("Variables DB_NAME, DB_USER et DB_PASS requises pour la restauration.");
  }

  if (!backupFilePath) {
    throw new Error("Chemin du fichier backup requis pour la restauration.");
  }

  if (!fs.existsSync(backupFilePath)) {
    throw new Error(`Fichier backup introuvable: ${backupFilePath}`);
  }

  const args = [
    "-h",
    dbHost,
    "-p",
    dbPort,
    "-U",
    dbUser,
    "-d",
    dbName,
    "-f",
    backupFilePath,
  ];

  return new Promise((resolve, reject) => {
    execFile("psql", args, { env: { ...process.env, PGPASSWORD: dbPass } }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(`Echec restauration DB: ${stderr || error.message}`));
        return;
      }

      resolve({ backupFilePath, stdout, stderr });
    });
  });
};

module.exports = { createDbBackup, restoreDbBackup };
