# Toit Flutter App

## 📦 Platforms

- Windows
- Android

## 🧭 App Structure

### AppBar

- Title: **"Toit"**, centered
- Right side of AppBar:
  - **Gear icon (⚙️)** on the far right → opens the **Settings screen**
  - **Checkmark icon (✓)** to the **left of the gear**, shows color status based on page content (see logic below)

---

## ⚙️ Settings Screen

A `Column` with the following elements:

1. **Text**: `"Enter your code"` and a number-only input below
2. **Text**: `"Enter your password"` and a number-only input below

- Inputs accept **only digits**
- Show **numeric keyboard**
- Values are stored using the `shared_preferences` package
- Fields are empty by default
- Use `InputDecoration.labelText` to float the label when user starts typing (default Flutter behavior)

---

## 🏠 Main Screen

- Displays a full-screen WebView of:  
  🔗 `https://toit.thermory.com/et`
- Uses the `flutter_inappwebview` package

### Floating Action Button (FAB)

- Positioned bottom-right
- Shows a **loading/refresh icon**
- On press:
  - Reloads the page
  - Runs a sequence of **auto-clicks** inside the web page (see logic below)
- FAB is **enabled only** if both code and password are stored

---

## ✅ Checkmark Logic (in AppBar)

The checkmark icon reflects date status from a specific element in the webpage:

- 🔵 **Blue** — if date found on page **equals today**
- 🟢 **Green** — if date is **in the future**
- ⚪ **Gray** — if the date is missing or in the past

You can use JavaScript evaluation or DOM parsing via `flutter_inappwebview` to check this.

### DOM target for date

The date is located inside an `<a>` tag inside a `<li>` with class `active`, for example:

```html
<li role="presentation" class="active">
  <a href="#tab-1428" aria-controls="home" role="tab" data-toggle="tab">
    Tellimus 14.04.2025
  </a>
</li>
```

To extract the date from the page, use JavaScript to locate the active tab and parse the text content of the `<a>` element. Look for the `Tellimus` prefix followed by the date.

---

## 🤖 Auto-click Logic (FAB)

Upon clicking the FAB:

1. Wait for the web page to fully load
2. Wait until **buttons with digits** appear (e.g., button with `text() == "1"`)
3. Input two digit sequences:
   - First: the **code** (e.g. `0`, `3`, `8`, `5`)
   - Second: the **password** (e.g. `8`, `6`, `3`, `6`)
4. For each sequence:
   - Click buttons by XPATH:  
     `//button[text()="digit"]` — this selects buttons by visible digit
   - After the digits are pressed, click the **green OK button**:  
     `//button[@class="ok"]`
5. Wait 100ms between each digit click
6. Wait 300ms after clicking OK

Repeat the process for both code and password.

---

## 📦 Required dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_inappwebview: ^6.0.0
  shared_preferences: ^2.2.0
```

---

## 🏁 Project goal

A lightweight desktop/mobile Flutter app that automatically logs in to [toit.thermory.com/et](https://toit.thermory.com/et) using saved numeric credentials, with visual feedback and partial automation built into the UI.
