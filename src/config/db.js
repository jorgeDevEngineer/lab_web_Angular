import { Sequelize } from "sequelize";
import {
  DB_DATABASE,
  DB_HOST,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
  DB_SCHEMA,
} from "./config.js";

const sequelize = new Sequelize(DB_DATABASE, DB_USER, DB_PASSWORD, {
  host: DB_HOST,
  port: DB_PORT,
  dialect: "postgres",
  define: {
    schema: DB_SCHEMA, // Establecer el esquema por defecto
  },
});

async function authenticateDatabase() {
  try {
    await sequelize.authenticate();
    // eslint-disable-next-line no-console
    console.log("Connection has been established successfully.");
    await sequelize.query(`SET search_path TO ${DB_SCHEMA}`);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("Unable to connect to the database:", error);
  }
}

authenticateDatabase();

// Cerrando la conexión de la base de datos
async function closeConnection() {
  try {
    await sequelize.close();
    // eslint-disable-next-line no-console
    console.log("Database connection closed.");
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("Error closing the database connection:", error);
  }
}

// Esto es solo un ejemplo para mostrar cómo cerrar la conexión
process.on("SIGINT", async () => {
  await closeConnection();
  process.exit(0);
});

export default sequelize;
