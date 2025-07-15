const express = require('express');
const multer = require('multer');
const cors = require('cors');
const fs = require('fs');
const { OpenAI } = require('openai');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json()); 

const upload = multer({ dest: 'uploads/' });
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.post('/explain-image', upload.single('image'), async (req, res) => {
  try {
    const filePath = req.file.path;
    const base64 = fs.readFileSync(filePath, { encoding: 'base64' });

    console.log('Calling OpenAI with image size:', base64.length);

    const result = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [
        {
          role: 'system',
          content: `You are a helpful code tutor. Respond using the following format:
            Code: [insert code here]

            Language: [e.g., Python, C++]

            Summary: [brief description of what the code does]

            Explanation:
            [detailed explanation of the code, including key functions and logic]

            Potential Errors or Improvements:
            - [improvement 1]

            If the image does not contain code or the code is unreadable, respond **exactly** with:

            INVALID: This image does not appear to contain code.
            
            `,
        },
        {
          role: 'user',
          content: [
            { type: 'text', text: 'Please explain the code in this image:' },
            {
              type: 'image_url',
              image_url: {
                url: `data:image/jpeg;base64,${base64}`,
              },
            },
          ],
        },
      ],
    });


    const explanation = result.choices[0].message.content;
    res.json({ explanation });
  } catch (err) {
    console.error('OpenAI Error:', err.response?.data || err.message || err);
    res.status(500).json({ error: 'Failed to process image' });
  }
});

app.post('/extract-code', upload.single('image'), async (req, res) => {
  try {
    const filePath = req.file.path;
    const base64 = fs.readFileSync(filePath, { encoding: 'base64' });

    const result = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [
        {
          role: 'system',
          content: `You are a code OCR tool. Your task is to extract only the raw source code from an image.

    Instructions:
    - Do not wrap the code in triple backticks (e.g., \`\`\`cpp).
    - Do not label the language.
    - Do not add any explanation or commentary.
    - Only return the exact code as plain text.
    - If no valid code is found in the image, respond with exactly:
    INVALID: No code detected.
    `
        },
        {
          role: 'user',
          content: [
            { type: 'text', text: 'Extract the code from this image:' },
            {
              type: 'image_url',
              image_url: {
                url: `data:image/jpeg;base64,${base64}`,
              },
            },
          ],
        },
      ],
    });


    const codeOnly = result.choices[0].message.content;
    res.json({ code: codeOnly });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to extract code' });
  }
});

app.post('/follow-up', async (req, res) => {
  const { code, history, question } = req.body;

  if (!code || !question) {
    return res.status(400).json({ error: 'Code and question are required.' });
  }

  try {
    const messages = [
      {
        role: 'system',
        content: `You're a helpful assistant that explains code to students. Use simple, clear language.`,
      },
      {
        role: 'user',
        content: `Here is some code:\n\n${code}\n\nPlease explain it.`,
      },
      ...history, // prior follow-up messages
      {
        role: 'user',
        content: question,
      },
    ];

    const result = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages,
    });

    res.json({
      reply: result.choices[0].message.content,
    });

  } catch (error) {
    console.error('Follow-up error:', error.message);
    res.status(500).json({ error: 'Failed to process follow-up question.' });
  }
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on http://0.0.0.0:3000');
});