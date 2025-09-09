import { SQSClient, ReceiveMessageCommand, DeleteMessageCommand, SendMessageCommand } from '@aws-sdk/client-sqs';

export class SQSService {
  private client: SQSClient;

  constructor() {
    this.client = new SQSClient({
      region: process.env.AWS_REGION || 'us-west-1'
    });
  }

  async sendMessage(queueUrl: string, messageBody: string): Promise<void> {
    try {
      const command = new SendMessageCommand({
        QueueUrl: queueUrl,
        MessageBody: messageBody
      });

      await this.client.send(command);
      console.log('✅ Message sent to SQS:', queueUrl);

    } catch (error) {
      console.error('❌ Error sending SQS message:', error);
      throw error;
    }
  }

  async receiveMessages(queueUrl: string, maxMessages: number = 10) {
    const command = new ReceiveMessageCommand({
      QueueUrl: queueUrl,
      MaxNumberOfMessages: maxMessages,
      WaitTimeSeconds: 20,
    });

    const result = await this.client.send(command);
    return result.Messages || [];
  }

  async deleteMessage(queueUrl: string, receiptHandle: string) {
    const command = new DeleteMessageCommand({
      QueueUrl: queueUrl,
      ReceiptHandle: receiptHandle
    });

    await this.client.send(command);
  }

  async sendToErrorQueue(message: any) {
    const command = new SendMessageCommand({
      QueueUrl: process.env.ERROR_QUEUE_URL!,
      MessageBody: JSON.stringify(message)
    });

    await this.client.send(command);
  }
}