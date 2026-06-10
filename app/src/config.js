module.exports = {
  jwtSecret: process.env.JWT_SECRET || 'dev-secret-change-me',
  awsAccessKeyId: process.env.AWS_ACCESS_KEY_ID,
  awsSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
};
