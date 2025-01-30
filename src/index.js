import express from "express";
import usersRoutes from "./routes/users.routes.js";
import morgan from "morgan";
import { PORT } from "./config/config.js";

const app = express();

app.use(morgan("dev"));

// middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(usersRoutes);

// Manejador para rutas 404
app.use((req, res) => {
    res.status(404).send('API Labs: Ruta no encontrada');
});

app.listen(PORT);
// eslint-disable-next-line no-console
console.log("Server on port", " - http://localhost:" + PORT + " 🚀");