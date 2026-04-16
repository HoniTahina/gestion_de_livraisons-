require("dotenv").config();

const fs = require("fs");
const path = require("path");
const { restoreDbBackup } = require("../utils/dbBackup");

const getLatestBackupFile = (backupDir) => {
  if (!fs.existsSync(backupDir)) {
    throw new Error(`Dossier backups introuvable: ${backupDir}`);
  }

  const sqlFiles = fs
    .readdirSync(backupDir)
    .filter((fileName) => fileName.toLowerCase().endsWith(".sql"))
    .map((fileName) => ({
      fileName,
      fullPath: path.join(backupDir, fileName),
      mtimeMs: fs.statSync(path.join(backupDir, fileName)).mtimeMs,
    }))
    .sort((a, b) => b.mtimeMs - a.mtimeMs);

  if (sqlFiles.length === 0) {
    throw new Error(`Aucun fichier .sql dans le dossier: ${backupDir}`);
  }

  return sqlFiles[0].fullPath;
};

(async () => {
  try {
    const backupDir = process.env.DB_BACKUP_DIR
      ? path.resolve(process.env.DB_BACKUP_DIR)
      : path.resolve(__dirname, "..", "backups");

    const latestBackup = getLatestBackupFile(backupDir);
    const result = await restoreDbBackup(latestBackup);

    console.log(`Dernier backup restaure: ${result.backupFilePath}`);
    process.exit(0);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
})();
