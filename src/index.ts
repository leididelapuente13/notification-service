import dotenv from 'dotenv';

dotenv.config();

export { handler as sendNotificationsHandler } from './lambdas/send-notifications-lambda';
export { handler as sendNotificationsErrorHandler } from './lambdas/send-notifications-error-lambda';

console.log('Notification service initialized');