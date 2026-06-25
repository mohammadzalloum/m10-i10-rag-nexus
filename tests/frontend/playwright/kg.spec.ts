import { test, expect } from '@playwright/test';

test('kg page renders and returns rows', async ({ page }) => {
  await page.route('**/kg/query', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        cypher: 'MATCH (r:Recipe) RETURN r.name AS recipe',
        rows: [
          {
            recipe: 'Mapo Tofu',
          },
        ],
        count: 1,
      }),
    });
  });

  await page.goto('/kg');

  await page.getByPlaceholder('e.g. Find Sichuan recipes').fill('Find Sichuan recipes');
  await page.getByRole('button', { name: 'Ask' }).click();

  await expect(page.getByRole('heading', { name: 'Cypher' })).toBeVisible();
  await expect(page.getByText('MATCH (r:Recipe) RETURN r.name AS recipe')).toBeVisible();
  await expect(page.getByTestId('kg-row')).toContainText('Mapo Tofu');
});
