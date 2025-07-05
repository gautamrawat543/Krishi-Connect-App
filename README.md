# 🌾 KrishiConnect – Empowering Farmers through Digital Contract Farming

**KrishiConnect** is a digital contract farming platform built to connect **farmers**, **buyers**. With real-time chat, secure authentication, and simple listing management, it enables farmers to reach markets directly, negotiate prices, and increase their income through transparent contracts.

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
- `http`, `image_picker`, `shared_preference`

### 🔹 Backend (Spring Boot)
- Java + Spring Boot
- MySQL database
- JWT authentication
- WebSocket with STOMP for chat
- RESTful API endpoints

---

## 🖼️ Screenshots *(Add your actual screenshots here)*

| 🧑‍🌾 Farmer View | 🧑‍💼 Buyer View | 💬 Chat Interface |
|------------------|------------------|-------------------|
| ![Farmer](screenshots/farmer.png) | ![Buyer](screenshots/buyer.png) | ![Chat](screenshots/chat.png) |

---

## 🚀 Getting Started

### 🔧 Frontend Setup
```bash
git clone https://github.com/your-org/krishiconnect-backend.git
