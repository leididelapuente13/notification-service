import { EmailTemplate } from '../types/email-template.types';
import { NotificationData } from '../types/notification.types';

export class TemplateProcessor {
  static processTemplate(template: string, data: NotificationData): string {
    let processedTemplate = template;
    
    Object.keys(data).forEach(key => {
      const value = String((data as any)[key] || '');
      
      const pattern = `\\{\\{${key}\\}\\}`;
      const regex = new RegExp(pattern, 'g');
      processedTemplate = processedTemplate.replace(regex, value);
    });
    
    return processedTemplate;
  }

  static processEmailTemplate(template: EmailTemplate, data: NotificationData): EmailTemplate {
    return {
      subject: this.processTemplate(template.subject, data),
      htmlBody: this.processTemplate(template.htmlBody, data),
      textBody: this.processTemplate(template.textBody, data)
    };
  }

  static formatDate(dateString: string): string {
    try {
      return new Date(dateString).toLocaleString();
    } catch {
      return dateString;
    }
  }

  static formatCurrency(amount: number): string {
    return `$${amount.toLocaleString()}`;
  }
}