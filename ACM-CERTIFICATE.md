# ACM Certificate Setup

## Configuration Added

✅ HTTPS listener on port 443 with ACM certificate
✅ HTTP to HTTPS redirect (port 80 → 443)
✅ Security group allows both HTTP (80) and HTTPS (443)
✅ TLS 1.3 security policy

## Setup Steps

### 1. Request ACM Certificate

**Option A: AWS Console**
1. Go to AWS Certificate Manager
2. Click "Request certificate"
3. Choose "Request a public certificate"
4. Enter your domain name (e.g., `example.com` or `*.example.com`)
5. Choose DNS validation
6. Add CNAME records to your DNS provider
7. Wait for validation (usually 5-30 minutes)
8. Copy the certificate ARN

**Option B: AWS CLI**
```bash
# Request certificate
aws acm request-certificate \
  --domain-name example.com \
  --validation-method DNS \
  --region us-east-1

# Get validation records
aws acm describe-certificate \
  --certificate-arn arn:aws:acm:us-east-1:xxx:certificate/xxx
```

### 2. Add Certificate ARN to terraform.tfvars

```hcl
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

### 3. Deploy

```bash
terraform apply
```

## DNS Configuration

After deployment, point your domain to the ALB:

```
example.com.  CNAME  <alb-dns-name>
```

Get ALB DNS name:
```bash
terraform output alb_dns_name
```

## Traffic Flow

```
User (HTTPS) → ALB:443 → ECS:8080
User (HTTP)  → ALB:80 → Redirect to HTTPS
```

## Testing

```bash
# Test HTTP redirect
curl -I http://your-domain.com

# Test HTTPS
curl -I https://your-domain.com

# Check certificate
openssl s_client -connect your-domain.com:443 -servername your-domain.com
```

## Notes

- Certificate must be in the same region as ALB (us-east-1)
- Certificate must be validated before use
- HTTP traffic automatically redirects to HTTPS
- TLS 1.3 security policy is used for best security
