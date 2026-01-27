# Customer-Specific Registration Pattern

## Overview

Pattern for handling customer-specific registration flows with configurable validation and onboarding steps.

## Use Case

When different customers require different registration workflows, validation rules, or onboarding processes.

## Implementation Steps

### 1. Customer Configuration
- Define customer-specific registration schemas
- Configure validation rules per customer
- Set up custom onboarding workflows

### 2. Dynamic Form Generation
- Load customer-specific form fields
- Apply conditional logic based on customer type
- Implement real-time validation

### 3. Registration Processing
- Validate input against customer schema
- Execute customer-specific business logic
- Trigger appropriate onboarding workflows

### 4. Account Provisioning
- Create accounts with customer-specific settings
- Apply customer-specific permissions
- Configure integration endpoints

## Configuration Examples

### Customer Schema Definition
```json
{
  "customer_id": "enterprise-001",
  "registration_fields": [
    {
      "name": "company_name",
      "type": "text",
      "required": true,
      "validation": "min_length:2"
    },
    {
      "name": "employee_count",
      "type": "number",
      "required": true,
      "validation": "min:10,max:10000"
    }
  ],
  "onboarding_steps": ["account_setup", "team_invites", "integration_config"]
}
```

### Validation Rules
```yaml
enterprise-001:
  company_name:
    - required
    - min_length: 2
  employee_count:
    - required
    - type: integer
    - min: 10
```

## Related Skills

- **integration-patterns.md** - API Gateway Pattern for routing
- **data-analysis.md** - Error Pattern Detection for validation failures