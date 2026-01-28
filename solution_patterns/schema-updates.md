# Database Schema Updates Pattern

## Overview

Pattern for managing database schema updates across multiple microservices with minimal downtime and data consistency.

## Use Case

When evolving database schemas in a microservice environment where multiple services may depend on shared data structures.

## Implementation Steps

### 1. Schema Versioning
- Maintain version-controlled migration scripts
- Track applied migrations in schema versions table
- Support rollback capabilities

### 2. Blue-Green Deployments
- Deploy new schema alongside existing schema
- Implement feature flags for schema access
- Gradually migrate data to new structure

### 3. Backward Compatibility
- Maintain old schema during transition period
- Implement data transformation layers
- Support multiple schema versions concurrently

### 4. Data Validation
- Verify data integrity after migration
- Run consistency checks between old/new schemas
- Implement automatic data repair procedures

### 5. Cleanup
- Remove old schema after successful migration
- Clean up transformation layers
- Update service configurations

## Migration Script Examples

### Schema Migration
```sql
-- V1.2.0__add_user_preferences.sql
CREATE TABLE user_preferences_v2 (
    user_id UUID PRIMARY KEY,
    preferences JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Migrate existing data
INSERT INTO user_preferences_v2 (user_id, preferences)
SELECT user_id, 
       json_build_object('theme', theme, 'notifications', notifications)
FROM user_preferences_v1;
```

### Rollback Migration
```sql
-- V1.2.0__rollback_add_user_preferences.sql
DROP TABLE IF EXISTS user_preferences_v2;
```

## Configuration

### Migration Configuration
```yaml
database:
  host: localhost
  port: 5432
  name: microservice_db
  
migrations:
  path: db/migrations/
  table: schema_versions
  auto_rollback: false
  
blue_green:
  transition_period: 24h
  data_validation: true
```

## Related Skills

- **devops.md** - CI/CD Pipeline Management for migration deployment
- **data-analysis.md** - Performance Metrics Analysis during migration