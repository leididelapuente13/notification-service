import { SQSEvent, SQSRecord } from 'aws-lambda';
import { DynamoService } from '../services/dynamoService';

const dynamoService = new DynamoService();

export const handler = async (event: SQSEvent) => {
  console.log('🚨 Processing error notifications:', JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    try {
      await processErrorRecord(record);
    } catch (error) {
      console.error('❌ Failed to process error record:', error);
    }
  }
};

async function processErrorRecord(record: SQSRecord) {
  try {
    console.log('🔍 Processing error record:', record.messageId);
    await dynamoService.saveNotificationError({  // ✅ Use correct method name
      originalMessage: record.body,
      error: 'Message processing failed and sent to DLQ',
      attempts: parseInt(record.attributes.ApproximateReceiveCount) || 1
    });
    console.log('✅ Error record processed and saved');
  } catch (error) {
    console.error('❌ Error processing error record:', error);
    throw error;
  }
}