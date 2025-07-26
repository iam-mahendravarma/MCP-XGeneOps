import { Injectable } from '@nestjs/common';

@Injectable()
export class DashboardService {
  async getStats(userId: string) {
    // Mock data - in real app, this would query the database
    return {
      totalContent: 15,
      processedItems: 12,
      lastActivity: new Date().toISOString(),
    };
  }

  async getRecentContent(userId: string) {
    // Mock data - in real app, this would query the database
    return [
      {
        id: '1',
        title: 'Sample Document 1',
        type: 'document',
        createdAt: new Date().toISOString(),
      },
      {
        id: '2',
        title: 'Analysis Report',
        type: 'report',
        createdAt: new Date(Date.now() - 86400000).toISOString(),
      },
    ];
  }
} 