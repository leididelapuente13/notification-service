export interface NotificationRequest {
  type: NotificationType;
  data: NotificationData;
}

export type NotificationType = 
  | 'WELCOME'
  | 'USER.LOGIN' 
  | 'USER.UPDATE'
  | 'CARD.CREATE'
  | 'CARD.ACTIVATE' 
  | 'TRANSACTION.PURCHASE'
  | 'TRANSACTION.SAVE'
  | 'TRANSACTION.PAID'
  | 'REPORT.ACTIVITY';

export type NotificationData = 
  | WelcomeData
  | UserLoginData
  | UserUpdateData
  | CardCreateData
  | CardActivateData
  | TransactionPurchaseData
  | TransactionSaveData
  | TransactionPaidData
  | ReportActivityData;

export interface WelcomeData {
  fullName: string;
}

export interface UserLoginData {
  date: string;
}

export interface UserUpdateData {
  date: string;
}

export interface CardCreateData {
  date: string;
  type: 'CREDIT' | 'DEBIT';
  amount: number;
}

export interface CardActivateData {
  date: string;
  type: 'CREDIT' | 'DEBIT';
  amount: number;
}

export interface TransactionPurchaseData {
  date: string;
  merchant: string;
  cardId: string;
  amount: number;
}

export interface TransactionSaveData {
  date: string;
  merchant: 'SAVING';
  amount: number;
}

export interface TransactionPaidData {
  date: string;
  merchant: 'PSE';
  amount: number;
}

export interface ReportActivityData {
  date: string;
  url: string;
}

export interface NotificationRecord {
  uuid: string;
  createdAt: string;
  type: NotificationType;
  email: string;
  data: NotificationData;
  status: 'SENT' | 'FAILED' | 'PENDING';
}

export interface NotificationErrorRecord {
  uuid: string;
  createdAt: string;
  originalMessage: string;
  error: string;
  attempts: number;
}