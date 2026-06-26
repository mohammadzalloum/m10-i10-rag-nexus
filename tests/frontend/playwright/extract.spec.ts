import { test, expect } from '@playwright/test';

test('extract page renders and returns entities', async ({ page }) => {
  await page.route('**/extract', async (route) => {
    const request = route.request();

    // Do not intercept the page navigation GET /extract.
    // Only mock the API POST /extract request.
    if (request.method() !== 'POST') {
      await route.continue();
      return;
    }

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

  const textbox = page.getByPlaceholder('Paste text to extract named entities from...');
  await expect(textbox).toBeVisible();

  await textbox.fill('Ginger is used in stir-fry recipes.');

  await page.getByRole('button', { name: /extract/i }).click();

  await expect(page.getByTestId('entity-span').getByText('Ginger')).toBeVisible();
  await expect(page.getByText('INGREDIENT')).toBeVisible();
});
