require("dotenv").config();

const { createDbBackup } = require("../utils/dbBackup");

(async () => {
  try {
    const result = await createDbBackup();
    console.log(`Backup cree: ${result.outputPath}`);
    process.exit(0);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
})();
