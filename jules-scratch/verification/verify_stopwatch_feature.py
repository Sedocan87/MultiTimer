from playwright.sync_api import sync_playwright, expect

def run(playwright):
    browser = playwright.chromium.launch(headless=True)
    context = browser.new_context()
    page = context.new_page()

    try:
        page.goto("http://localhost:8080")

        # Give the app time to load
        page.wait_for_selector("text=Timers", timeout=60000)

        # Click the "Stopwatch" navigation item
        stopwatch_button = page.get_by_label("Stopwatch")
        expect(stopwatch_button).to_be_visible()
        stopwatch_button.click()

        # Verify the stopwatch screen is visible
        expect(page.get_by_text("00:00.00")).to_be_visible()

        # Take a screenshot
        page.screenshot(path="/app/jules-scratch/verification/verification.png")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        browser.close()

with sync_playwright() as playwright:
    run(playwright)