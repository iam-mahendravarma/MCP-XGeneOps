import React, { useState } from 'react';
import axios from 'axios';

const AI_SERVICE_URL = process.env.REACT_APP_AI_SERVICE_URL || 'http://localhost:8000';

function AIProcessor({ user }) {
  const [inputText, setInputText] = useState('');
  const [processingType, setProcessingType] = useState('summarize');
  const [result, setResult] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const processingOptions = [
    { value: 'summarize', label: 'Summarize Text', description: 'Generate a concise summary' },
    { value: 'analyze', label: 'Analyze Sentiment', description: 'Analyze the emotional tone' },
    { value: 'extract', label: 'Extract Keywords', description: 'Extract key terms and phrases' },
    { value: 'translate', label: 'Translate', description: 'Translate to different languages' }
  ];

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!inputText.trim()) {
      setError('Please enter some text to process');
      return;
    }

    setLoading(true);
    setError('');
    setResult('');

    try {
      const response = await axios.post(`${AI_SERVICE_URL}/process`, {
        text: inputText,
        type: processingType,
        userId: user?.id
      });

      setResult(response.data.result);
    } catch (error) {
      setError(error.response?.data?.message || 'Processing failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleClear = () => {
    setInputText('');
    setResult('');
    setError('');
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header */}
      <div className="card">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">AI Content Processor</h1>
        <p className="text-gray-600">
          Use AI to analyze, summarize, and process your content with advanced machine learning algorithms.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Input Section */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Input</h2>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Processing Type Selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Processing Type
              </label>
              <div className="grid grid-cols-2 gap-3">
                {processingOptions.map((option) => (
                  <label key={option.value} className="relative flex cursor-pointer rounded-lg border border-gray-300 bg-white p-4 shadow-sm focus:outline-none">
                    <input
                      type="radio"
                      name="processingType"
                      value={option.value}
                      checked={processingType === option.value}
                      onChange={(e) => setProcessingType(e.target.value)}
                      className="sr-only"
                    />
                    <span className="flex flex-1">
                      <span className="flex flex-col">
                        <span className="block text-sm font-medium text-gray-900">
                          {option.label}
                        </span>
                        <span className="mt-1 flex items-center text-xs text-gray-500">
                          {option.description}
                        </span>
                      </span>
                    </span>
                    <span className={`pointer-events-none absolute -inset-px rounded-lg border-2 ${
                      processingType === option.value ? 'border-primary-500' : 'border-transparent'
                    }`} />
                  </label>
                ))}
              </div>
            </div>

            {/* Text Input */}
            <div>
              <label htmlFor="inputText" className="block text-sm font-medium text-gray-700 mb-2">
                Text to Process
              </label>
              <textarea
                id="inputText"
                rows={8}
                className="input-field resize-none"
                placeholder="Enter your text here..."
                value={inputText}
                onChange={(e) => setInputText(e.target.value)}
                disabled={loading}
              />
            </div>

            {/* Action Buttons */}
            <div className="flex space-x-3">
              <button
                type="submit"
                disabled={loading || !inputText.trim()}
                className="btn-primary flex-1"
              >
                {loading ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    Processing...
                  </>
                ) : (
                  'Process Text'
                )}
              </button>
              <button
                type="button"
                onClick={handleClear}
                disabled={loading}
                className="btn-secondary"
              >
                Clear
              </button>
            </div>
          </form>

          {error && (
            <div className="mt-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
              {error}
            </div>
          )}
        </div>

        {/* Results Section */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Results</h2>
          
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <div className="text-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto mb-4"></div>
                <p className="text-gray-600">Processing your text...</p>
              </div>
            </div>
          ) : result ? (
            <div className="space-y-4">
              <div className="bg-gray-50 rounded-lg p-4">
                <h3 className="text-sm font-medium text-gray-700 mb-2">Processed Result</h3>
                <div className="text-gray-900 whitespace-pre-wrap">{result}</div>
              </div>
              
              <div className="flex space-x-3">
                <button
                  onClick={() => navigator.clipboard.writeText(result)}
                  className="btn-secondary text-sm"
                >
                  Copy Result
                </button>
                <button
                  onClick={() => setResult('')}
                  className="btn-secondary text-sm"
                >
                  Clear Result
                </button>
              </div>
            </div>
          ) : (
            <div className="text-center py-12 text-gray-500">
              <svg className="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <p>Enter text and select a processing type to get started.</p>
            </div>
          )}
        </div>
      </div>

      {/* Usage Tips */}
      <div className="card">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Usage Tips</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-600">
          <div>
            <h3 className="font-medium text-gray-900 mb-2">For Best Results:</h3>
            <ul className="space-y-1">
              <li>• Use clear, well-structured text</li>
              <li>• Provide context when possible</li>
              <li>• Keep input under 1000 words for faster processing</li>
            </ul>
          </div>
          <div>
            <h3 className="font-medium text-gray-900 mb-2">Supported Features:</h3>
            <ul className="space-y-1">
              <li>• Text summarization</li>
              <li>• Sentiment analysis</li>
              <li>• Keyword extraction</li>
              <li>• Multi-language translation</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default AIProcessor; 