import re
from datetime import datetime
from textblob import TextBlob
import nltk
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
import numpy as np

# Download required NLTK data
try:
    nltk.data.find('tokenizers/punkt')
except LookupError:
    nltk.download('punkt')

try:
    nltk.data.find('corpora/stopwords')
except LookupError:
    nltk.download('stopwords')

try:
    nltk.data.find('corpora/wordnet')
except LookupError:
    nltk.download('wordnet')

class AIProcessor:
    def __init__(self):
        self.stop_words = set(stopwords.words('english'))
        self.lemmatizer = WordNetLemmatizer()

    def get_current_timestamp(self):
        return datetime.now().isoformat()

    def summarize_text(self, text: str) -> str:
        """Generate a summary of the input text"""
        try:
            # Tokenize into sentences
            sentences = sent_tokenize(text)
            
            if len(sentences) <= 3:
                return text
            
            # Calculate sentence scores based on word frequency
            word_freq = {}
            for sentence in sentences:
                words = word_tokenize(sentence.lower())
                for word in words:
                    if word.isalnum() and word not in self.stop_words:
                        word_freq[word] = word_freq.get(word, 0) + 1
            
            # Score sentences
            sentence_scores = {}
            for sentence in sentences:
                words = word_tokenize(sentence.lower())
                score = sum(word_freq.get(word, 0) for word in words if word.isalnum())
                sentence_scores[sentence] = score
            
            # Get top sentences
            summary_sentences = sorted(sentence_scores.items(), key=lambda x: x[1], reverse=True)
            summary_length = max(1, len(sentences) // 3)
            
            # Reconstruct summary in original order
            summary = []
            for sentence in sentences:
                if sentence in [s[0] for s in summary_sentences[:summary_length]]:
                    summary.append(sentence)
            
            return ' '.join(summary)
        
        except Exception as e:
            return f"Error in summarization: {str(e)}"

    def analyze_sentiment(self, text: str) -> str:
        """Analyze the sentiment of the input text"""
        try:
            blob = TextBlob(text)
            polarity = blob.sentiment.polarity
            subjectivity = blob.sentiment.subjectivity
            
            # Determine sentiment
            if polarity > 0.1:
                sentiment = "Positive"
            elif polarity < -0.1:
                sentiment = "Negative"
            else:
                sentiment = "Neutral"
            
            # Create detailed analysis
            analysis = f"Sentiment: {sentiment}\n"
            analysis += f"Polarity Score: {polarity:.3f} (-1 to 1)\n"
            analysis += f"Subjectivity Score: {subjectivity:.3f} (0 to 1)\n"
            
            if subjectivity > 0.5:
                analysis += "The text is quite subjective and opinionated."
            else:
                analysis += "The text is relatively objective and factual."
            
            return analysis
        
        except Exception as e:
            return f"Error in sentiment analysis: {str(e)}"

    def extract_keywords(self, text: str) -> str:
        """Extract key terms and phrases from the text"""
        try:
            # Tokenize and clean
            words = word_tokenize(text.lower())
            words = [word for word in words if word.isalnum() and word not in self.stop_words]
            
            # Lemmatize words
            lemmatized_words = [self.lemmatizer.lemmatize(word) for word in words]
            
            # Count frequency
            word_freq = {}
            for word in lemmatized_words:
                word_freq[word] = word_freq.get(word, 0) + 1
            
            # Get top keywords
            keywords = sorted(word_freq.items(), key=lambda x: x[1], reverse=True)
            top_keywords = keywords[:10]
            
            # Format output
            result = "Top Keywords:\n"
            for i, (word, freq) in enumerate(top_keywords, 1):
                result += f"{i}. {word} (frequency: {freq})\n"
            
            # Extract key phrases (bigrams)
            bigrams = []
            for i in range(len(words) - 1):
                if words[i] not in self.stop_words and words[i+1] not in self.stop_words:
                    bigrams.append(f"{words[i]} {words[i+1]}")
            
            if bigrams:
                result += "\nKey Phrases:\n"
                for i, phrase in enumerate(bigrams[:5], 1):
                    result += f"{i}. {phrase}\n"
            
            return result
        
        except Exception as e:
            return f"Error in keyword extraction: {str(e)}"

    def translate_text(self, text: str) -> str:
        """Translate text to different languages (mock implementation)"""
        try:
            # This is a mock translation - in a real app, you'd use a translation API
            blob = TextBlob(text)
            
            # Detect language
            detected_lang = blob.detect_language()
            
            result = f"Detected Language: {detected_lang}\n\n"
            result += "Translation Options:\n"
            
            # Mock translations
            translations = {
                'Spanish': 'Este es un texto traducido al español.',
                'French': 'Ceci est un texte traduit en français.',
                'German': 'Dies ist ein ins Deutsche übersetzter Text.',
                'Italian': 'Questo è un testo tradotto in italiano.',
                'Portuguese': 'Este é um texto traduzido para português.'
            }
            
            for lang, translation in translations.items():
                result += f"{lang}: {translation}\n"
            
            result += "\nNote: This is a demonstration. For real translations, use a translation API like Google Translate or DeepL."
            
            return result
        
        except Exception as e:
            return f"Error in translation: {str(e)}"

    def process_text(self, text: str, processing_type: str) -> str:
        """Main processing method that routes to specific processors"""
        if processing_type == "summarize":
            return self.summarize_text(text)
        elif processing_type == "analyze":
            return self.analyze_sentiment(text)
        elif processing_type == "extract":
            return self.extract_keywords(text)
        elif processing_type == "translate":
            return self.translate_text(text)
        else:
            return f"Unknown processing type: {processing_type}" 