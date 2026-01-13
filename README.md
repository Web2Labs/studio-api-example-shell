# Studio API Shell Example

Welcome to the Studio API Shell example! This project demonstrates how to interact with the Studio API using standard command-line tools.

## 🚀 Features

- **Zero Dependencies**: Uses `curl` and `bash`, available on almost all Unix-like systems.
- **JSON Parsing**: Uses `jq` for robust response handling.
- **CI/CD Ready**: Perfect for integrating into build pipelines or quick manual testing.

## 📋 Prerequisites

- **Bash** (Linux, macOS, or WSL on Windows).
- **curl**: For making HTTP requests.
- **jq**: For parsing JSON responses.
  - macOS: `brew install jq`
  - Ubuntu/Debian: `sudo apt install jq`
- **API Key**: You need a Web2Labs Studio API key.
  - Go to `https://web2labs.com/docs-api`
  - Generate your API key.

## 🛠️ Installation

1.  **Clone the repository** (or download these files).

2.  **Make the script executable**:
    ```bash
    chmod +x script.sh
    ```

3.  **Set up your API Key**:
    ```bash
    export STUDIO_API_KEY=sk_live_YOUR_KEY
    ```

## 🏃 Usage

Run the script with your video file:

```bash
./script.sh path/to/your/video.mp4
```

### What happens next?

1.  **Upload**: `curl` uploads your video to the Studio secure processing cloud.
2.  **Processing**: The script loops, polling the status endpoint and updating the progress.
    ```
    Status: Editing    | Stage: AI processing...            | Progress:  60%
    ```
3.  **Results**: Once finished, it parses the JSON response and prints download links.

## 📚 API Documentation

For complete API reference (including thumbnails), visit:
- Scalar UI: `https://web2labs.com/api/v1/reference`
- Swagger UI: `https://web2labs.com/api/v1/docs`
- OpenAPI JSON: `https://web2labs.com/api/v1/openapi.json`

## 🤝 Contributing & Support

Found a bug? Have a feature request?
- **Issues**: Please open an issue in this repository.
- **Pull Requests**: PRs are welcome! Please make sure your code follows the existing style.

---
*Built with ❤️ by Web2Labs*
