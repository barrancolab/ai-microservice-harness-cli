# Synchronous Request to Async Workers Pattern

## Overview

Pattern for converting synchronous HTTP requests into asynchronous background work with proper response handling.

## Use Case

When API requests need to trigger long-running processes but provide immediate feedback to the client.

## Implementation Steps

### 1. Request Reception
- Receive synchronous HTTP request
- Validate input parameters
- Generate unique correlation ID

### 2. Job Queue Submission
- Convert request to background job
- Submit to message queue or job system
- Store job metadata with correlation ID

### 3. Immediate Response
- Return 202 Accepted status
- Include correlation ID in response
- Provide status check endpoint URL

### 4. Background Processing
- Workers consume jobs from queue
- Process long-running tasks
- Update job status and results

### 5. Status Checking
- Client polls status endpoint
- Return job progress or completion status
- Provide final results when ready

## Configuration Examples

### Message Queue Setup
```
Queue: async-jobs
Exchange: async-work-exchange
Routing Key: job.type
```

### API Response Format
```json
{
  "status": "accepted",
  "correlation_id": "uuid-here",
  "status_url": "/api/jobs/uuid-here",
  "estimated_completion": "2023-12-01T10:30:00Z"
}
```

## Related Skills

- **integration-patterns.md** - Async Message Queue Integration
- **devops.md** - Environment Setup for queue infrastructure