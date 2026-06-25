import { test, expect } from '@playwright/test';

test('extract page renders and returns entities', async ({ page }) => {
  await page.route('**/extract', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        entities: [
          {
            text: 'Ginger',
            label: 'INGREDIENT',
            start: 0,
            end: 6,
          },
        ],
      }),
    });
  });

  await page.goto('/extract');

  await page.getByPlaceholder('Paste text to extract named entities from...').fill(
    'Ginger is used in stir-fry recipes.'
  );

  await page.getByRole('button', { name: 'Extract' }).click();

  await expect(page.getByRole('heading', { name: 'Entities' })).toBeVisible();
  await expect(page.getByTestId('entity-span')).toContainText('Ginger');
  await expect(page.getByTestId('entity-span')).toContainText('INGREDIENT');
});
