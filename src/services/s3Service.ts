import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';
import { EmailTemplate } from '../types/email-template.types';
import { NotificationType } from '../types/notification.types';

export class S3Service {
  private s3Client: S3Client;

  constructor() {
    this.s3Client = new S3Client({
      region: process.env.AWS_REGION || 'us-west-1'
    });
  }

  async getEmailTemplate(type: NotificationType): Promise<EmailTemplate> {
    try {
      const key = this.getTemplateKey(type);
      
      const command = new GetObjectCommand({
        Bucket: process.env.TEMPLATES_BUCKET!,
        Key: key
      });

      const response = await this.s3Client.send(command);
      const templateContent = await response.Body!.transformToString();
      
      const template: EmailTemplate = JSON.parse(templateContent);
      return template;
      
    } catch (error) {
      console.error('Error getting email template:', error);
      throw new Error(`Failed to get template for ${type}`);
    }
  }

  private getTemplateKey(type: NotificationType): string {
    const templateMap: Record<NotificationType, string> = {
      'WELCOME': 'welcome.json',
      'USER.LOGIN': 'user.login.json',
      'USER.UPDATE': 'user.update.json',
      'CARD.CREATE': 'card.create.json',
      'CARD.ACTIVATE': 'card.activate.json',
      'TRANSACTION.PURCHASE': 'transaction.purchase.json',
      'TRANSACTION.SAVE': 'transaction.save.json',
      'TRANSACTION.PAID': 'transaction.paid.json',
      'REPORT.ACTIVITY': 'report.activity.json'
    };
    
    return templateMap[type];
  }
}