import User from '../models/user.model.js';

const createUser = async (userData) => {
  return await User.create(userData);
};

const getUserById = async (userId) => {
  return await User.findByPk(userId);
};

const updateUser = async (userId, updateData) => {
  const user = await User.findByPk(userId);
  if (user) {
    return await user.update(updateData);
  }
  return null;
};

const deleteUser = async (userId) => {
  const user = await User.findByPk(userId);
  if (user) {
    await user.destroy();
    return true;
  }
  return false;
};

const listUsers = async () => {
  return await User.findAll();
};

export {
  createUser,
  getUserById,
  updateUser,
  deleteUser,
  listUsers
};
