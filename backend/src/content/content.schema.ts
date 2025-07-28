import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type ContentDocument = Content & Document;

@Schema({ timestamps: true })
export class Content {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  content: string;

  @Prop({ required: true })
  type: string;

  @Prop({ required: true })
  userId: string;

  @Prop()
  processedResult?: string;

  @Prop()
  metadata?: Record<string, any>;
}

export const ContentSchema = SchemaFactory.createForClass(Content); 