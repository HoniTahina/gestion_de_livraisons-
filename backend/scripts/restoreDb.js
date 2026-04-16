require("dotenv").config();

const path = require("path");
const { restoreDbBackup } = require("../utils/dbBackup");

(async () => {
  try {
    const inputPath = process.argv[2] || process.env.DB_RESTORE_FILE;
    if (!inputPath) {
      throw new Error(
        "Veuillez fournir le fichier backup: npm run restore:db -- \"C:/chemin/backup.sql\""
      );
    }

    const resolvedPath = path.resolve(inputPath);
    const result = await restoreDbBackup(resolvedPath);
    console.log(`Restauration terminee depuis: ${result.backupFilePath}`);
    process.exit(0);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
})();
