# MPR (Multiple Pull Request) Tool

MPR is a command-line tool designed to create pull requests for updating a specific file or directory across multiple GitHub repositories simultaneously.

## Features

- Update a single file or directory across multiple repositories
- Automatically create branches and pull requests
- Support for GitHub organizations and personal repositories
- Easy to use command-line interface

## Installation

### Using Homebrew

To install MPR using Homebrew, run the following commands:

```bash
brew tap koriym/mpr
brew install mpr
```

After installation, you need to authenticate GitHub CLI:

```bash
gh auth login
```

Follow the prompts to complete the authentication process.

### Manual Installation

1. Install GitHub CLI (gh):

   See https://github.com/cli/cli#installation

2. Authenticate GitHub CLI:
   ```bash
   gh auth login
   ```
   Follow the prompts to complete the authentication process.

3. Clone the MPR repository:
   ```bash
   git clone https://github.com/koriym/mpr.git
   ```

4. Navigate to the cloned directory:
   ```bash
   cd mpr
   ```

5. Make the script executable:
   ```bash
   chmod +x mpr.sh
   ```

6. Optionally, create a symbolic link to make the script accessible from anywhere:
   ```bash
   sudo ln -s $(pwd)/mpr.sh /usr/local/bin/mpr
   ```

Now you can use the `mpr` command from any directory.

## Authentication

Regardless of the installation method, MPR requires GitHub CLI to be authenticated. Ensure your token has the necessary scopes: `repo`, `workflow`, and `read:org`.

To verify your authentication status:

```bash
gh auth status
```

If you need to re-authenticate or adjust token scopes:

```bash
gh auth logout
gh auth login -s repo,workflow,read:org
```

## Usage

```bash
mpr <file_or_directory_path> <commit_message> <repo1> <repo2> ...
```

Example:
```bash
mpr .github/workflows/ci.yml "Update CI workflow" owner1/repo1 owner2/repo2
```

## Authentication

MPR uses the GitHub CLI (`gh`) for authentication. Make sure you have `gh` installed and authenticated:

1. Install GitHub CLI: [Installation Guide](https://github.com/cli/cli#installation)
2. Authenticate with GitHub:
   ```bash
   gh auth login
   ```

Ensure your token has the necessary scopes: `repo`, `workflow`, and `read:org`.

## Troubleshooting

If you encounter authentication issues:

1. Verify your token scopes:
   ```bash
   gh auth status
   ```

2. Re-authenticate if necessary:
   ```bash
   gh auth logout
   gh auth login -s repo,workflow,read:org
   ```

3. For organization repositories, ensure your token is authorized for SSO if required.

4. Check organization settings to allow access via personal access tokens.

5. Verify you have the necessary permissions on the target repositories.

## Similar Tools

While MPR is designed for simplicity and ease of use, there are other tools available that offer similar or expanded functionality. Here are some alternatives you might want to consider:

1. [multi-gitter](https://github.com/lindell/multi-gitter)
   - A tool for updating multiple repositories in bulk
   - Supports more complex operations and custom scripts
   - Offers a wider range of features compared to MPR

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
