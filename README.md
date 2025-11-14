# Create Jira Issue

This GitHub Action creates a Jira issue and optionally assigns it to the current sprint and release. It integrates with pull requests to prevent duplicate issue creation and automatically adds issue links to PR comments. The action uses the Jira REST API and GitHub CLI to provide seamless integration between GitHub workflows and Jira project management.

## Inputs

### `url`

**Required** The URL of your Jira instance (e.g., `https://your-company.atlassian.net`).

### `pat`

**Required** Personal Access Token for Jira authentication. Store this as a secret in your repository.

### `user`

**Required** Jira username for authentication.

### `project_key`

**Required** The project key in Jira where the issue will be created (e.g., `PROJ`).

### `project_board_name`

**Required** The name of the Jira board associated with your project.

### `issue_type`

**Required** The type of issue to create (e.g., `Task`, `Bug`, `Story`, `External Request`).

### `issue_summary`

**Required** The summary/title of the issue to create.

### `issue_description`

**Required** The description of the issue to create.

### `issue_status`

**Optional** The status to set for the created issue after creation (e.g., `In Progress`, `Done`, `To Do`). If not provided, the issue will remain in its default status.

### `pr_number`

**Optional** The pull request number to check for existing issues and add comment to. If provided, the action will check PR comments for existing Jira issue keys and skip creation if found. It will also add a comment with the created issue link.

### `assign_to_current_sprint`

**Optional** Whether to assign the issue to the current active sprint. Default: `false`.

### `assign_to_current_release`

**Optional** Whether to assign the issue to the current unreleased version. Default: `false`.

## Outputs

### `jira_issue_id`

The ID/key of the created Jira issue (e.g., `PROJ-123`).

## Features

- Creates Jira issues using REST API v3
- Supports Basic authentication with username and PAT
- Customizable issue summary and description
- Sets issue status after creation using transitions (optional)
- Automatically assigns issues to current active sprint (optional)
- Automatically assigns issues to current unreleased version (optional)
- Pull request integration with duplicate prevention
- Automatically adds issue links to PR comments
- Uses Atlassian Document Format (ADF) for issue descriptions
- Provides the created issue ID as output for further workflow steps

## Example usage

```yaml
- name: Create Jira Issue
  uses: left-code/jira-sit-create-issue@v1
  with:
    jira_url: ${{ secrets.URL }}
    jira_pat: ${{ secrets.PAT }}
    jira_user: ${{ secrets.USER }}
    jira_project_key: 'PROJ'
    jira_project_board_name: 'Project Board'
    jira_issue_type: 'Task'
    jira_issue_summary: 'Automated issue from GitHub Actions'
    jira_issue_description: 'This issue was created automatically by GitHub Actions workflow'
    jira_issue_status: 'In Progress'
    pr_number: ${{ github.event.number }}
    jira_assign_to_current_sprint: 'true'
    jira_assign_to_current_release: 'true'
  id: create-issue

- name: Use created issue ID
  run: echo "Created issue ${{ steps.create-issue.outputs.jira_issue_id }}"
```

## Environment Variables

Alternatively, you can use environment variables instead of inputs:

```yaml
- name: Create Jira Issue
  uses: left-code/jira-sit-create-issue@v1
  env:
    JIRA_URL: ${{ secrets.URL }}
    JIRA_PAT: ${{ secrets.PAT }}
    JIRA_USER: ${{ secrets.USER }}
    JIRA_PROJECT_KEY: 'PROJ'
    JIRA_PROJECT_BOARD_NAME: 'Project Board'
    JIRA_ISSUE_TYPE: 'Task'
    JIRA_ISSUE_SUMMARY: 'Automated issue from GitHub Actions'
    JIRA_ISSUE_DESCRIPTION: 'This issue was created automatically by GitHub Actions workflow'
    JIRA_ISSUE_STATUS: 'In Progress'
    PR_NUMBER: ${{ github.event.number }}
    JIRA_ASSIGN_TO_CURRENT_SPRINT: 'true'
    JIRA_ASSIGN_TO_CURRENT_RELEASE: 'true'
```

## Pull Request Integration

When used with pull requests, the action provides additional functionality:
2. Add the following secrets to your GitHub repository:
   - `JIRA_URL`: Your Jira instance URL
   - `JIRA_PAT`: Your Jira Personal Access Token
   - `JIRA_USER`: Your Jira username
3. Ensure the GitHub CLI is available in your workflow environment (most GitHub-hosted runners include it by default)
  pull_request:
    types: [opened]

```yaml
jobs:
  create-jira-issue:
    runs-on: ubuntu-latest
    steps:
    - name: Create Jira Issue
      uses: left-code/jira-sit-create-issue@v1
      with:
        jira_url: ${{ secrets.JIRA_URL }}
        jira_pat: ${{ secrets.JIRA_PAT }}
        jira_user: ${{ secrets.JIRA_USER }}
        jira_project_key: 'PROJ'
        jira_project_board_name: 'Project Board'
        jira_issue_type: 'Task'
        jira_issue_summary: 'Review: ${{ github.event.pull_request.title }}'
        jira_issue_description: 'PR: ${{ github.event.pull_request.html_url }}'
        pr_number: ${{ github.event.number }}
```

### PR Integration Features:
- **Duplicate Prevention**: Checks existing PR comments for Jira issue keys and skips creation if found
- **Automatic Linking**: Adds a comment to the PR with a direct link to the created Jira issue
- **Smart Detection**: Uses project key pattern matching to identify existing issues

## Setup

1. Create a Jira Personal Access Token in your Jira account
2. Add the following secrets to your GitHub repository:
   - `JIRA_URL`: Your Jira instance URL
   - `JIRA_PAT`: Your Jira Personal Access Token
   - `JIRA_USER`: Your Jira username
3. Ensure the GitHub CLI is available in your workflow environment (most GitHub-hosted runners include it by default)
4. Configure the action inputs or environment variables as needed
