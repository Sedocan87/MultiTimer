from playwright.sync_api import sync_playwright, expect

def run(playwright):
    browser = playwright.chromium.launch(headless=True)
    context = browser.new_context()
    page = context.new_page()

    try:
        page.goto("http://localhost:8000")

        # Wait for the app to load by checking for a known element
        expect(page.get_by_text("Active Timers")).to_be_visible(timeout=60000)

        # Click the add button. The Icon(Icons.add) is rendered as text "add".
        page.get_by_text("add").click()

        # Wait for the new timer screen to appear
        expect(page.get_by_text("New Timer")).to_be_visible()

        # Fill out the timer details
        # Flutter input fields on web might not have standard labels, so we locate by order.
        page.locator('//input').nth(0).fill('My Test Timer')
        page.locator('//input').nth(1).fill('1')

        # Select a vibration pattern
        page.get_by_text("Pulse").click()

        # Start the timer using its role and name
        page.get_by_role("button", name="Start Timer").click()

        # Wait for the timer to appear on the home screen
        expect(page.get_by_text("My Test Timer")).to_be_visible()

        # Take a screenshot for verification
        page.screenshot(path="/app/jules-scratch/verification/verification.png")

    finally:
        context.close()
        browser.close()

with sync_playwright() as playwright:
    run(playwright)