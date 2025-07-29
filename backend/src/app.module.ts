import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MongooseModule } from '@nestjs/mongoose';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { ContentModule } from './content/content.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: process.env.NODE_ENV !== 'production',
      logging: process.env.NODE_ENV !== 'production',
      retryAttempts: 10,
      retryDelay: 3000,
      keepConnectionAlive: true,
      extra: {
        max: 20,
        connectionTimeoutMillis: 5000,
        idleTimeoutMillis: 30000,
      },
    }),
    MongooseModule.forRoot(process.env.MONGODB_URI, {
      connectionFactory: (connection) => {
        connection.on('connected', () => {
          console.log('MongoDB connected successfully');
        });
        connection.on('error', (error) => {
          console.error('MongoDB connection error:', error);
        });
        return connection;
      },
    }),
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: '24h' },
    }),
    PassportModule,
    AuthModule,
    UsersModule,
    DashboardModule,
    ContentModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {} 