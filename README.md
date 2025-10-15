# 🔐 Secure Password Manager

A modern, full-stack password management application built with Ruby on Rails 8, featuring database encryption and hotwire to SPA-like experience.

## 🚀 Live Demo

#### There's a live demo version of this app on render:
It's important to note that due to inactivity render will turn off the app and it may take a couple minutes before it is ready to use

[Demo app link](https://password-manager-12kn.onrender.com/)


### Key Highlights for Employers

- **Security-First Architecture**: Implements Rails 8's built-in encryption for sensitive data
- **Modern Frontend**: Hotwire Turbo + Stimulus for SPA-like experience without complex JavaScript frameworks
- **API Integration**: RESTful API with JWT authentication for potential mobile/third-party integrations

## 🛠 Tech Stack

### Backend
- **Ruby on Rails 8.0** - Latest Rails with modern conventions
- **PostgreSQL** - Robust relational database
- **Devise** - Industry-standard authentication
- **JWT** - Stateless API authentication
- **Rails Encryption** - Built-in encryption for sensitive data

### Frontend
- **Hotwire (Turbo + Stimulus)** - Modern Rails frontend approach
- **Bootstrap 5** - Responsive CSS framework
- **esbuild** - Fast JavaScript bundling
- **Bootstrap Icons** - Consistent iconography


## ✨ Features

### Core Functionality
- **Secure Password Storage**: Encrypted username and password fields using Rails 8 encryption
- **User Authentication**: Complete user management with Devise (registration, login, password recovery)
- **One-Click Copy**: Clipboard integration for secure password copying

## 🚀 Getting Started

### Prerequisites
- Ruby 3.4.1
- Node.js 23.7.0
- PostgreSQL
- Docker (optional, for containerized development)

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone 
   cd password_manager
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

## 🧪 Testing

```bash
# Run the full test suite
rails test

```

