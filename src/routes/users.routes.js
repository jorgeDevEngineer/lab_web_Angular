import express from 'express';
import {
  createUserController,
  getUserByIdController,
  updateUserController,
  deleteUserController,
  listUsersController
} from '../controllers/user.controller.js';

const router = express.Router();

router.post('/users', createUserController);
router.get('/users', listUsersController);
router.get('/users/:id', getUserByIdController);
router.put('/users/:id', updateUserController);
router.delete('/users/:id', deleteUserController);

export default router;
