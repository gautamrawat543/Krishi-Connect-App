# 🌾 KrishiConnect – Empowering Farmers through Digital Contract Farming

**KrishiConnect** is a digital contract farming platform built to connect **farmers**, **buyers**, and **agricultural advisors**. With real-time chat, secure authentication, and simple listing management, it enables farmers to reach markets directly, negotiate prices, and increase their income through transparent contracts.

Whether you're a farmer looking to showcase your produce or a buyer searching for reliable partners, KrishiConnect bridges the gap with technology.

---

## 🧠 Key Features

- 📝 **Farmer Listings**: Farmers can list produce with title, description, category, price, quantity, and an optional image.
- 📦 **Buyer Interest**: Buyers can browse and show interest in listings.
- 💬 **Real-Time Chat**: Built-in chat using WebSocket + STOMP after a connection is established.
- 🔒 **Authentication**: Email/Password login with JWT + Google Sign-In support.
- 📤 **Secure Image Upload**: Multipart form-data API with bearer token validation.
- 🧾 **Negotiation Support**: Chat allows payment and terms negotiation between farmer and buyer.
- 📱 **Mobile First**: Built with Flutter for Android/iOS with a focus on usability.

---

## 🛠️ Tech Stack

### 🔹 Frontend (Flutter)
- Flutter & Dart
- `Provider` for state management
- `http`, `image_picker`, `stomp_dart_client`, and `flutter_secure_storage`

### 🔹 Backend (Spring Boot)
- Java + Spring Boot
- MySQL database
- JWT authentication
- WebSocket with STOMP for chat
- RESTful API endpoints
- Deployment on [Render](https://render.com)

---

## 🖼️ Screenshots *(Add your actual screenshots here)*

| 🧑‍🌾 Farmer View | 🧑‍💼 Buyer View | 💬 Chat Interface |
|------------------|------------------|-------------------|
| ![Farmer](screenshots/farmer.png) | ![Buyer](screenshots/buyer.png) | ![Chat](screenshots/chat.png) |

---

## 🧪 Sample API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/login` | Login with credentials |
| `POST` | `/api/listings` | Create produce listing |
| `GET`  | `/api/listings` | Browse all listings |
| `POST` | `/api/chat/send/{conversationId}` | Send a message |
| `SUB`  | `/topic/conversations/{conversationId}` | Subscribe to messages |

---

## 🚀 Getting Started

### 🔧 Backend Setup
```bash
git clone https://github.com/your-org/krishiconnect-backend.git
cd krishiconnect-backend
