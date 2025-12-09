# Endpoints Fizzy - Custom Setup

This is a customized fork of [Fizzy](https://github.com/basecamp/fizzy) for Endpoints News.

## Customisations

### Domain Restriction
Access to the application is restricted to specific email domains only. This prevents unauthorized signups and logins.

**Implementation:**
- `app/models/concerns/domain_restricted.rb` - Centralised domain validation logic
- Allowed domains: `@endpoints.news` and `@endpointsnews.com`
- Enforced on both signup and login flows
- Validation at the Identity model level prevents any unauthorized account creation

**To add/remove allowed domains:**
Edit `app/models/concerns/domain_restricted.rb`:
```ruby
ALLOWED_DOMAINS = ["@endpoints.news", "@endpointsnews.com", "@newdomain.com"].freeze
```

## Local Development Setup

### Prerequisites

#### Install Ruby on macOS

1. Install Homebrew (if not already installed):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install rbenv (Ruby version manager):
```bash
brew install rbenv ruby-build
```

3. Add rbenv to your shell:
```bash
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
```

4. Install Ruby (check `.ruby-version` file for required version):
```bash
rbenv install 3.3.6  # or whatever version is in .ruby-version
rbenv global 3.3.6
```

5. Verify installation:
```bash
ruby -v
```

### Setup Application

1. Clone the repository:
```bash
git clone git@github.com:endpoints-news/ep-fizzy.git
cd ep-fizzy
```

2. Install dependencies:
```bash
bin/setup
```

3. Start the development server:
```bash
bin/dev
```

4. Access the app at: http://fizzy.localhost:3006

5. Login with development credentials:
   - Email: `david@example.com`
   - Check browser console for verification code

## Hosting

### Infrastructure
- **Platform:** AWS EC2
- **Instance Type:** t3.small
- **OS:** Ubuntu
- **Deployment Tool:** Kamal

### Server Requirements
- Docker installed
- SSH access configured
- Domain DNS pointing to server IP
- Ports 80 and 443 open

## Deployment

### Initial Setup

1. Ensure you have AWS credentials configured locally

2. Update deployment configuration:
   - Edit `config/deploy.yml` with your server details
   - Create `.kamal/secrets` with required environment variables

3. First deployment:
```bash
bin/kamal setup
```

### Subsequent Deployments

1. Commit your changes:
```bash
git add -A
git commit -m "Your commit message"
```

2. Deploy:
```bash
bin/kamal deploy
```

**Important:** Kamal deploys from Git commits, not uncommitted changes. Always commit before deploying.

### Deployment Commands

```bash
# Deploy the application
bin/kamal deploy

# View application logs
bin/kamal app logs

# Access Rails console on production
bin/kamal app exec 'bin/rails console'

# Restart the application
bin/kamal app restart

# SSH into the server
bin/kamal app exec bash
```

## Environment Variables

Required environment variables (set in `.kamal/secrets`):
- `SECRET_KEY_BASE` - Rails secret key
- `VAPID_PUBLIC_KEY` - For push notifications
- `VAPID_PRIVATE_KEY` - For push notifications
- `SMTP_USERNAME` - Email provider username
- `SMTP_PASSWORD` - Email provider password

See main README.md for instructions on generating these values.

## Maintenance

### Updating Fizzy from Upstream

To pull in updates from the original Fizzy repository:

```bash
# Add upstream remote (first time only)
git remote add upstream https://github.com/basecamp/fizzy.git

# Fetch upstream changes
git fetch upstream

# Merge upstream changes
git merge upstream/main

# Resolve any conflicts, then deploy
git push origin main
bin/kamal deploy
```

### EC2 Backups

Uses Data Lifecycle Manager to create daily snapshots of EC2 instance and store for 7 days.

## Support

For issues specific to this deployment, contact the Endpoints News team.
For Fizzy-related issues, see the [main Fizzy repository](https://github.com/basecamp/fizzy).
