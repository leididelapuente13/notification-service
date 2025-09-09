import { SQSEvent, SQSRecord } from 'aws-lambda';
import { NotificationRequest } from '../types/notification.types';
import { SQSService } from '../services/sqsService';
import { DynamoService } from '../services/dynamoService';
import { S3Service } from '../services/s3Service';
import { SESService } from '../services/sesService';
import { TemplateProcessor } from '../utils/templateProcessor';

const sqsService = new SQSService();
const dynamoService = new DynamoService();
const s3Service = new S3Service();
const sesService = new SESService();

export const handler = async (event: SQSEvent) => {
  for (const record of event.Records) {
    try {
      await processNotificationRecord(record);
    } catch (error) {
      console.error('❌ Error processing record:', record.messageId, error);
      await handleError(record, error);
    }
  }
};

async function processNotificationRecord(record: SQSRecord) {
  const EMAIL = "leididelapuente3@gmail.com"
  try {
    const notification: NotificationRequest = JSON.parse(record.body);
    if (!notification.type || !EMAIL || !notification.data) {
      throw new Error('Invalid notification structure: missing type, email, or data');
    }
    const template = await s3Service.getEmailTemplate(notification.type);
    const processedSubject = TemplateProcessor.processTemplate(template.subject, notification.data);
    const processedHtmlBody = TemplateProcessor.processTemplate(template.htmlBody, notification.data);
    const processedTextBody = TemplateProcessor.processTemplate(template.textBody, notification.data);

    await sesService.sendEmail({
      to: EMAIL,
      subject: processedSubject,
      htmlBody: processedHtmlBody,
      textBody: processedTextBody
    });

    try {
      await dynamoService.saveNotification({
        type: notification.type,
        email: EMAIL,
        data: notification.data,
        status: 'SENT'
      });
    } catch (dynamoError) {
      console.error('❌ DynamoDB Error:', dynamoError);
    }
    
  } catch (error) {
    console.error('❌ Error processing notification:', error);
    throw error;
  }
}

async function handleError(record: SQSRecord, error: any) {
  try {
    await sqsService.sendMessage(
      process.env.ERROR_QUEUE_URL!,
      JSON.stringify({
        originalMessage: record.body,
        error: error.message,
        timestamp: new Date().toISOString(),
        messageId: record.messageId
      })
    );

    await dynamoService.saveNotificationError({
      originalMessage: record.body,
      error: error.message,
      attempts: parseInt(record.attributes.ApproximateReceiveCount) || 1
    });

  } catch (saveError) {
    console.error('❌ Failed to handle error:', saveError);
  }
}