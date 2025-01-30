import {
  createUser,
  getUserById,
  updateUser,
  deleteUser,
  listUsers,
} from "../services/user.service.js";

const createUserController = async (req, res) => {
  try {
    const user = await createUser(req.body);
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const getUserByIdController = async (req, res) => {
  try {
    const user = await getUserById(req.params.id);
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ error: "Usuario no encontrado" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUserController = async (req, res) => {
  try {
    const user = await getUserById(req.params.id);
    if (user) {
      await updateUser(req.params.id, req.body);
      res.json(user);
    } else {
      res.status(404).json({ error: "Usuario no encontrado" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const deleteUserController = async (req, res) => {
  try {
    const success = await deleteUser(req.params.id);
    if (success) {
      res.status(204).end();
    } else {
      res.status(404).json({ error: "Usuario no encontrado" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const listUsersController = async (req, res) => {
  try {
    const users = await listUsers();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export {
  createUserController,
  getUserByIdController,
  updateUserController,
  deleteUserController,
  listUsersController,
};
