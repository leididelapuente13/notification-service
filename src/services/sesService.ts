import { SESClient, SendEmailCommand } from '@aws-sdk/client-ses';

export interface EmailRequest {
  to: string;
  subject: string;
  htmlBody: string;
  textBody: string;
}

export class SESService {
  private sesClient: SESClient;

  constructor() {
    this.sesClient = new SESClient({
      region: process.env.AWS_REGION || 'us-west-1'
    });
  }

  async sendEmail(request: EmailRequest): Promise<void> {
    try {
      const command = new SendEmailCommand({
        Source: process.env.FROM_EMAIL!,
        Destination: {
          ToAddresses: [request.to]
        },
        Message: {
          Subject: {
            Data: request.subject,
            Charset: 'UTF-8'
          },
          Body: {
            Html: {
              Data: request.htmlBody,
              Charset: 'UTF-8'
            },
            Text: {
              Data: request.textBody,
              Charset: 'UTF-8'
            }
          }
        }
      });

      const result = await this.sesClient.send(command);
      console.log('✅ Email sent successfully:', result.MessageId);
      
    } catch (error) {
      console.error('❌ Error sending email:', error);
      throw error;
    }
  }
}