import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';
import { randomUUID } from 'crypto';
import { NotificationRecord, NotificationErrorRecord } from '../types/notification.types';

export class DynamoService {
  private client: DynamoDBDocumentClient;

  constructor() {
    const dynamoClient = new DynamoDBClient({
      region: process.env.AWS_REGION || 'us-west-1'
    });
    this.client = DynamoDBDocumentClient.from(dynamoClient);
  }

  async saveNotification(record: Omit<NotificationRecord, 'uuid' | 'createdAt'>) {
  try {
    const item: NotificationRecord = {
      ...record,
      uuid: randomUUID(),
      createdAt: new Date().toISOString()
    };
    const command = new PutCommand({
      TableName: process.env.NOTIFICATION_TABLE!,
      Item: item
    });
    const result = await this.client.send(command);    
  } catch (error) {
    throw error;
  }
}

  async saveNotificationError(error: Omit<NotificationErrorRecord, 'uuid' | 'createdAt'>): Promise<void> {
    const item: NotificationErrorRecord = {
      ...error,
      uuid: randomUUID(),
      createdAt: new Date().toISOString()
    };

    const command = new PutCommand({
      TableName: process.env.ERROR_TABLE!,
      Item: item
    });

    await this.client.send(command);
    console.log('✅ Error saved to DynamoDB');
  }

  async getNotificationsByType(type: string, limit: number = 10): Promise<NotificationRecord[]> {
    const command = new QueryCommand({
      TableName: process.env.NOTIFICATION_TABLE!,
      IndexName: 'TypeIndex',
      KeyConditionExpression: '#type = :type',
      ExpressionAttributeNames: {
        '#type': 'type'
      },
      ExpressionAttributeValues: {
        ':type': type
      },
      Limit: limit,
      ScanIndexForward: false
    });

    const result = await this.client.send(command);
    return result.Items as NotificationRecord[];
  }
  
  async saveError(error: Omit<NotificationErrorRecord, 'uuid' | 'createdAt'>): Promise<void> {
    return this.saveNotificationError(error);
  }
}