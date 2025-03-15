# 🚀 MCP Rules for Paperless-Astra

This file contains the **Model Context Protocol (MCP) guidelines** for the **Paperless-Astra project**.

---

## 📌 Project Overview

**Paperless-Astra** is a **fork of Paperless-ngx** that integrates **ChromaDB vector search** for **enhanced document search functionality**. It also introduces **dynamic LLM switching**, allowing users to connect to **local models (LM Studio)** or **cloud-based models (Claude, OpenAI, etc.)**.

This project introduces:
- **Vector search using ChromaDB** to improve **search accuracy**.
- **Document embeddings with Sentence Transformers** to create **high-quality vector representations**.
- **Automatic embedding generation** whenever a document is saved.
- **A new vector similarity search API endpoint** for querying documents.
- **Flexible AI model switching** for local (LM Studio) or cloud-based LLMs.

---

## 📌 Key Components

### 1️⃣ Multi-LLM Support (Local & Cloud)
- Connects to **LM Studio for Local LLM Models**.
- Supports **OpenAI, Claude, Mistral, etc., via API**.
- Allows users to **configure API endpoints and keys** manually.

### 2️⃣ Intelligent Model Switching (Task-Based)
- **Selects the best model** based on the task type:
  - **Tagging (Metadata Extraction & Summarization)** → Uses Claude, GPT-4, or a local LM Studio model.
  - **OCR with Vision (Processing Images, PDFs)** → Uses a Vision LLM (e.g., LLaVA, GPT-4V, etc.).
  - **Reasoning (Motion Drafting, Legal Inferences)** → Uses the most powerful model available.
- **Optimizes model switching** by:
  - **Batching similar tasks** to complete them before switching.
  - **Keeping a single model loaded** for as long as possible before switching.

### 3️⃣ LM Studio Model Management
- Knows which models are available in LM Studio.
- Automatically loads/unloads models as needed.
- Users define which models specialize in which tasks.

---

## 📌 Development Guidelines

### 1️⃣ Code Style
- Follow **PEP 8** guidelines for Python code.
- Use **type hints (`def func(name: str) -> dict`)** for all new functions.
- **Document every function & class** with clear docstrings.
- Keep functions **single-purpose and modular** for maintainability.

### 2️⃣ Testing
- Write **unit tests** for all new functionality.
- Ensure **edge cases** are tested, particularly for **vector searches**.
- Follow existing test patterns in **`tests/`**.

### 3️⃣ Documentation
- Update **API docs** whenever new endpoints are added.
- Document **config options** (e.g., enabling/disabling vector search).
- Provide **code examples** for **API usage** and **configuration settings**.

### 4️⃣ Version Control
- Use **descriptive commit messages** (`feat: added vector search API`).
- Develop **new features in branches** before merging into `main`.
- Submit **Pull Requests (PRs) for review** before merging changes.

---

## 📌 Project Structure

src/
  paperless_astra/ # Core application
    ├── init.py # Package initialization 
    ├── vector_search/ # Vector search module 
    │ ├── apps.py # Django app configuration 
    │ ├── chroma_client.py # ChromaDB singleton client 
    │ ├── embedding.py # Document embedding logic 
    │ ├── signals.py # Auto-generate embeddings on document save 
    │ ├── urls.py # URL routing for vector search 
    │ ├── views.py # API endpoints for searching 
    │ └── serializers.py # Data serialization for search results 
    ├── mcp_server/ # MCP API for external AI models 
    │ ├── models.py # MCP data structures 
    │ ├── endpoints.py # MCP request handling 
    │ ├── schema.py # MCP API schema definition 
    │ ├── auth.py # Optional authentication for AI access 
    ├── llm_router.py # Handles intelligent LLM switching 
    ├── lm_studio_manager.py # Manages LM Studio model loading/unloading



---

## 📌 Configuration Options

Paperless-Astra uses environment variables and a configuration file to control settings:

### **Environment Variables**
| **Variable** | **Description** | **Default** |
|-------------|----------------|------------|
| `PAPERLESS_VECTOR_SEARCH_ENABLED` | Enables/disables ChromaDB vector search | `true` |
| `PAPERLESS_CHROMA_DB_DIR` | ChromaDB storage location | `data/chroma_db` |
| `PAPERLESS_MCP_API_KEY` | API key for external LLM access | _None_ (optional) |

### **LLM Configuration File (`llm_config.json`)**
```json
{
  "default": "claude",
  "llm_backends": {
    "claude": {
      "type": "cloud",
      "url": "https://api.anthropic.com/v1/messages",
      "api_key": "your_claude_api_key"
    },
    "openai": {
      "type": "cloud",
      "url": "https://api.openai.com/v1/chat/completions",
      "api_key": "your_openai_api_key"
    },
    "local_lm_studio": {
      "type": "local",
      "lm_studio_path": "/path/to/lmstudio/models/",
      "model_names": {
        "tagging": "mistral-7b",
        "vision": "llava-13b",
        "reasoning": "gpt4all-13b"
      }
    }
  }
}

📌 API Endpoints

1️⃣ Vector Search API
GET /api/vector_search/search/
Queries documents using semantic similarity search via ChromaDB.

2️⃣ MCP API for LLM Integration
POST /api/mcp/query/
Allows external AI models to retrieve and analyze case data.

3️⃣ LM Studio Model Switching
POST /api/llm/switch_model/
Loads/unloads the best model for the current task.