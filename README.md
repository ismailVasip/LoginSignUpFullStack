# Login and Signup Backend System

## Overview

This project is a robust, secure authentication backend system built with ASP.NET Core. It implements a clean architecture approach with modern security practices, rate limiting, and JWT authentication to provide a professional-grade solution for user management.

## Architecture

- **Presentation Layer**: API controllers handling HTTP requests
- **Service Layer**: Business logic implementation
- **Repository Layer**: Data access and persistence


## Key Features

- **Secure Authentication**: Complete JWT-based authentication system
- **User Management**: Registration, login, and profile management
- **Rate Limiting**: Protection against brute force and DoS attacks
- **Email Integration**: Configured for notifications and verification
- **Comprehensive Logging**: Detailed logging for monitoring and debugging
- **Swagger Documentation**: Interactive API documentation

## Technologies & Packages

### Core Framework
- **ASP.NET Core**: Modern, high-performance web framework
- **Entity Framework Core**: ORM for database operations with SQL Server

### Authentication & Security
- **ASP.NET Core Identity**: User management and authentication framework
- **JWT Bearer Authentication**: Token-based security implementation
- **AspNetCoreRateLimit**: Protection against excessive requests

### Development Tools
- **AutoMapper**: Object-to-object mapping for clean data transformations
- **Swagger/OpenAPI**: API documentation and testing interface

### Design Patterns
- **Repository Pattern**: Abstraction over data access
- **Dependency Injection**: Built-in IoC container for loose coupling
- **Service Pattern**: Encapsulation of business logic

## Implementation Details

### JWT Authentication Flow

The system implements a secure token-based authentication mechanism with:
- Token generation upon successful login
- Configurable token lifetime
- Validation of issuer, audience, and signing key
- Refresh token capabilities

### Rate Limiting Strategy

To protect against abuse, the system implements IP-based rate limiting:
- 10 requests per minute per IP address
- Memory cache storage for rate limit counters
- Async processing strategy for high-performance handling

### Clean Architecture Implementation

The project strictly adheres to clean architecture principles:
- **Interfaces**: Defined in the `interfaces` namespace for dependency inversion
- **Models**: Domain entities in the `models` namespace
- **Repositories**: Data access implementations in the `repositories` namespace
- **Services**: Business logic in the `services` namespace

This ensures that dependencies always point inward, with the domain layer at the core, free from external dependencies.

## Security Considerations

- Password requirements enforced (uppercase, lowercase, digits, minimum length)
- Unique email requirement for user registration
- JWT tokens with proper validation parameters
- Rate limiting to prevent brute force attacks
- HTTPS enforcement

## Getting Started

### Prerequisites
- .NET 6.0 SDK or later
- SQL Server instance
- SMTP server access (for email functionality)

### Configuration

The application uses the following configuration sections:
- `ConnectionStrings:sqlConnection`: Database connection string
- `JwtSetting`: JWT configuration including secret key, issuer, and audience
- `MailSettings`: Email server configuration

### Running the Application

```bash
dotnet restore
```

```bash
dotnet build
```

```bash
dotnet run
```

The API will be available at https://localhost:5001 with Swagger documentation at https://localhost:5001/swagger.

## API Documentation

The API is fully documented using Swagger/OpenAPI. When running in development mode, navigate to the `/swagger` endpoint to explore and test the available endpoints.

---

This backend system demonstrates professional-grade implementation of authentication and user management with a focus on security, performance, and maintainability through clean architecture principles.
