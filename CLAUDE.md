# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Testing
```bash
# Run all tests
rake test

# Run specific test file
ruby -Itest test/path/to/specific_test.rb

# Run tests from a specific directory
rake test TEST=test/controllers/**/*_test.rb
```

### Dependencies
```bash
# Install dependencies
bundle install

# Update dependencies
bundle update
```

### Database Migrations
```bash
# When used as an engine in a host Rails app:
# Copy migrations from engine to host app
rails ecommerce:install:migrations

# Run migrations
rails db:migrate

# Seed the database (required for initial configuration)
rails db:seed
```

## Architecture Overview

This is a **Rails Engine** (not a standalone Rails app) that provides e-commerce functionality to host Rails applications. Understanding this distinction is critical for development.

### Key Architectural Components

1. **Engine Namespace**: All models, controllers, and other classes are namespaced under `Ecommerce::`
   - Example: `Ecommerce::Product`, `Ecommerce::Order`, `Ecommerce::Cart`

2. **Isolated Routing**: The engine has its own routes defined in `config/routes.rb` that get mounted in the host application
   - Frontend routes: products, categories, cart, checkout, orders
   - Backoffice namespace: admin functionality under `/backoffice`

3. **Dual Layout System**: 
   - **Expatshop theme**: Consumer-facing store with modern UI (`app/views/ecommerce/expatshop/`)
   - **Organici theme**: Alternative store theme (`app/views/ecommerce/organici/`)
   - **Backoffice**: Admin interface for managing products, orders, users

4. **Payment Integration**:
   - Culqi (Peruvian payment gateway) for credit card processing
   - PagoEfectivo for cash payments
   - Bank transfer support

5. **Multi-currency Support**: 
   - Handles both PEN (Peruvian Soles) and USD
   - Exchange rate configured via Control model

6. **Marketing Features**:
   - Campaign system with email automation
   - Coupon management (fixed, percentage, dynamic)
   - Combo discounts for product bundles
   - Referral program with points system

7. **External Integrations**:
   - Electronic invoicing (Nubefact/DataBiz for Peru)
   - Shipping providers (Urbaner, Olva)
   - WhatsApp/Interakt for messaging
   - Facebook Conversions API

8. **Background Jobs**: Uses workers for:
   - Email campaigns (`send_*_email_worker.rb`)
   - Electronic invoice generation
   - Cart abandonment reminders
   - Video processing for shopping videos

9. **Multi-language Support**: 
   - I18n for Spanish (es-PE) and English (en-PE)
   - Product and category translations stored in database

10. **Dependency on Host App**:
    - Requires Devise for authentication
    - Expects User model with specific schema
    - Uses CanCanCan for authorization
    - Needs jQuery, Bootstrap, and other frontend dependencies

### Critical Files for Understanding the System

- `lib/ecommerce/engine.rb`: Engine configuration and initialization
- `app/controllers/ecommerce/application_controller.rb`: Base controller with cart/wishlist management
- `app/models/ecommerce/order.rb`: Central order processing logic
- `app/models/ecommerce/cart.rb` & `cart_item.rb`: Shopping cart functionality
- `app/controllers/ecommerce/checkout_controller.rb`: Payment processing flow

### Development Considerations

- Always namespace new classes under `Ecommerce::`
- Test within the dummy app located in `test/dummy/`
- Use existing CarrierWave uploaders for file uploads
- Follow the existing pattern of using Money gem for price handling
- Respect the multi-tenant controls system via `Control.get_control_value()`

## Main Application Integration (ExpatShop)

The ecommerce engine is integrated into the main ExpatShop Rails application located at `../expatshop/`. This integration provides context for how the engine operates in production.

### Host Application Structure

1. **Rails Version**: The main app runs on Rails 7.0 with Ruby 3.3.4
2. **Mount Point**: The engine is mounted at `/store` in the main app's routes
3. **Root Route**: The main app's root route points directly to `ecommerce/store#main`

### Key Integration Points

1. **User Model Extension**: 
   - Main app's User model (`expatshop/app/models/user.rb`) extends the engine's user requirements
   - Adds custom validations for Peruvian phone numbers (9 digits)
   - Implements referral system with referral codes
   - Handles guest users with default passwords
   - Integrates with points system for rewards

2. **Configuration** (`expatshop/config/initializers/ecommerce.rb`):
   - Layout: Uses "expatshop" theme
   - Company Details: ANIRUDDHA SAC (VAT: 20602903312)
   - Locales: Default store locale is Spanish (es-PE), backoffice is English (en-PE)
   - Payment: Culqi integration for card processing
   - Shipping: Urbaner integration
   - E-invoicing: Nubefact for Peruvian electronic invoices

3. **Background Jobs**:
   - Main app uses Sidekiq for background processing
   - Workers handle SMS notifications via Twilio
   - Media conversion workers for video processing
   - Slack integration for notifications

4. **Additional Features in Main App**:
   - Points transactions system for user rewards
   - Suppression list management for email compliance
   - Custom Devise controllers for authentication overrides
   - Health check endpoints for monitoring

### Development Workflow

When developing features that span both the engine and main app:

1. **Local Development Setup**:
   ```bash
   # Configure local gem path for development
   bundle config local.ecommerce /Users/augusto/workspace/expatshop/ecommerce
   ```

2. **Database Commands** (run from main app directory):
   ```bash
   # Install engine migrations
   rails ecommerce:install:migrations
   
   # Run migrations
   rails db:migrate
   
   # Seed initial data
   rails db:seed
   ```

3. **Server Commands** (run from main app directory):
   ```bash
   # Start Rails server
   rails server
   
   # Start Sidekiq for background jobs
   bundle exec sidekiq
   
   # Access Sidekiq web UI (admin only)
   # Navigate to: /sidekiq
   ```

4. **Deployment**:
   - Uses Capistrano for deployment
   - Deployment scripts: `deploy_production.sh`, `deploy_staging.sh`
   - AWS infrastructure with S3 for storage

### Important Paths

- **Engine code**: `/Users/augusto/workspace/expatshop/ecommerce/`
- **Main app code**: `/Users/augusto/workspace/expatshop/expatshop/`
- **Shared uploads**: `expatshop/public/uploads/`
- **Logs**: `expatshop/log/`

### Environment Variables

The main app uses dotenv for configuration. Key variables include:
- Database credentials
- AWS S3 configuration
- Culqi payment gateway keys
- Twilio SMS credentials
- Facebook App ID
- Rollbar error tracking