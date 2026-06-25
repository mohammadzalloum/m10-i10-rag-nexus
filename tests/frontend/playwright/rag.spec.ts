import { test, expect } from '@playwright/test';

test('rag page renders cited answer', async ({ page }) => {
  await page.route('**/rag/answer', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        answer: 'Mince ginger before stir-frying and cite the source [1].',
        citations: [
          {
            chunk_id: 1,
            score: 0.91,
          },
        ],
        confidence: 0.91,
      }),
    });
  });

  await page.goto('/rag');

  await page.getByPlaceholder('Ask a recipe question...').fill(
    'How do I prep ginger for stir-fry?'
  );

  await page.getByRole('button', { name: 'Ask' }).click();

  await expect(page.getByTestId('rag-answer')).toContainText('Mince ginger');
  await expect(page.getByTestId('citation-marker')).toHaveText('1');
  await expect(page.getByText('Confidence: 0.91')).toBeVisible();
});
