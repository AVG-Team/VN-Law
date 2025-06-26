from dotenv import load_dotenv
from openai import OpenAI
import logging
import os
import sys


load_dotenv()
class SummaryService:
    def __init__(self):
        """
        Initializes the SummaryService.
        """
        self.api_key = os.getenv("OPENAI_API_KEY")
        if not self.api_key:
            raise ValueError("OPENAI_API_KEY environment variable is not set.")
        self.client = OpenAI(api_key=self.api_key)

        

    def summarize(self, data: str) -> str:
        """
        Summarizes the given text using a simple algorithm.
        
        Args:
            text (str): The text to summarize.
        
        Returns:
            str: The summarized text.
        """
        # For simplicity, this is a placeholder implementation.
        # In a real application, you would use a more sophisticated summarization algorithm.
        sentences = data.split('. ')
        if len(sentences) <= 2:
            logging.warning("Text is too short to summarize effectively.")
        prompt = f"""
        You are a legal assistant tasked with summarizing legal documents for better understanding.
        
        Please provide a concise summary of the following text:
        \"\"\"{data}\"\"\
        """
        response = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful legal assistant."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=150,
            temperature=0.7
        )
        summary = response.choices[0].message['content'].strip()
        return summary if summary else "No summary could be generated."
    
    def summarize_document(self, document: str) -> str:
        """
        Summarizes a legal document.
        
        Args:
            document (str): The legal document to summarize.
        
        Returns:
            str: The summarized document.
        """
        if not document:
            raise ValueError("Document cannot be empty.")
        
        logging.info("Starting document summarization.")
        summary = self.summarize(document)
        logging.info("Document summarization completed.")
        
        return summary
        
