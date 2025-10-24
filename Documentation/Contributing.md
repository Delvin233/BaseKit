# Contributing to BaseKit

## How to Contribute

We welcome contributions to BaseKit! Whether you're fixing bugs, adding features, improving documentation, or helping with testing, your contributions make BaseKit better for everyone.

## Getting Started

### Fork and Clone

1. Fork the BaseKit repository on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/your-username/basekit.git
cd basekit
```

3. Add the upstream repository:
```bash
git remote add upstream https://github.com/basekit/basekit.git
```

### Development Setup

1. Install Godot 4.2 or later
2. Open the project in Godot
3. Enable the BaseKit plugin
4. Run the demo to verify everything works

## Code Style Guide

### GDScript Conventions

**Naming Conventions:**
```gdscript
# Classes: PascalCase
class_name BaseKitManager

# Variables and functions: snake_case
var connected_address: String
func connect_wallet() -> void

# Constants: SCREAMING_SNAKE_CASE
const BASE_RPC_URL = "https://mainnet.base.org"

# Private members: prefix with underscore
var _internal_state: Dictionary
func _private_method() -> void

# Signals: snake_case with descriptive names
signal wallet_connected(address: String)
signal basename_resolved(address: String, name: String)
```

**Code Formatting:**
```gdscript
# Use tabs for indentation
func example_function():
	if condition:
		do_something()
	else:
		do_something_else()

# Space around operators
var result = a + b * c

# No trailing whitespace
# Empty lines to separate logical sections
```

**Documentation:**
```gdscript
## Brief description of the class
##
## Detailed description explaining the purpose,
## usage, and any important considerations.
class_name ExampleClass

## Brief description of the function
##
## Detailed description of what the function does,
## its parameters, return value, and any side effects.
##
## @param address The wallet address to resolve
## @param use_cache Whether to use cached results
## @return The resolved Base Name or empty string
func resolve_base_name(address: String, use_cache: bool = true) -> String:
	pass
```

### File Organization

**Actual Project Structure:**
```
base-kit-godot-sdk/
├── addons/basekit/              # BaseKit Plugin
│   ├── ui/                      # UI components
│   │   ├── basekit_button.gd
│   │   ├── basekit_button.tscn
│   │   ├── user_modal.gd
│   │   └── user_modal.tscn
│   ├── avatar_loader.gd         # Avatar loading
│   ├── base_contract_caller.gd  # Contract interactions
│   ├── basekit_manager.gd       # Main API
│   ├── browser_oauth_connector.gd # Wallet connection
│   ├── config.gd                # Configuration
│   ├── plugin.cfg               # Plugin config
│   ├── plugin.gd                # Plugin script
│   ├── session_manager.gd       # Session handling
│   └── smart_basename_resolver.gd # ENS resolution
├── tests/                       # Test files
│   ├── minimal_test.gd
│   └── minimal_test.tscn
├── simple_demo.gd               # Demo script
├── simple_demo.tscn             # Demo scene
└── project.godot                # Godot project
```

**Import Organization:**
```gdscript
# Built-in imports first
extends Node

# External imports
const HTTPClient = preload("res://addons/http_client/http_client.gd")

# Internal imports
const BaseKitConfig = preload("res://addons/basekit/config.gd")
```

## Development Workflow

### Branch Naming

- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test improvements

### Commit Messages

Follow conventional commit format:

```
type(scope): brief description

Detailed explanation of the change, including:
- What was changed and why
- Any breaking changes
- References to issues

Closes #123
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Build/tooling changes

**Examples:**
```
feat(resolver): add caching for Base Name resolution

Implement LRU cache to improve performance of repeated
Base Name lookups. Cache size is configurable and
defaults to 100 entries.

Closes #45

fix(ui): prevent button double-click during connection

Add disabled state to BaseKit button while connection
is in progress to prevent multiple simultaneous
connection attempts.

Fixes #67
```

### Pull Request Process

1. **Create Feature Branch:**
```bash
git checkout -b feature/your-feature-name
```

2. **Make Changes:**
   - Write code following style guidelines
   - Add tests for new functionality
   - Update documentation as needed

3. **Test Changes:**
```bash
# Run unit tests
godot --headless -s addons/gut/gut_cmdln.gd

# Test manually in demo
# Verify on different platforms
```

4. **Commit Changes:**
```bash
git add .
git commit -m "feat(scope): description"
```

5. **Push and Create PR:**
```bash
git push origin feature/your-feature-name
# Create pull request on GitHub
```

### PR Requirements

**All PRs must:**
- [ ] Pass all existing tests
- [ ] Include tests for new functionality
- [ ] Follow code style guidelines
- [ ] Update documentation if needed
- [ ] Have descriptive commit messages
- [ ] Be reviewed by at least one maintainer

**PR Template:**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Manual testing completed
- [ ] Tested on multiple platforms

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

## Testing Guidelines

### Writing Tests

**Unit Test Structure:**
```gdscript
extends GutTest

var manager: BaseKitManager

func before_each():
	manager = BaseKitManager.new()
	add_child(manager)

func after_each():
	manager.queue_free()

func test_wallet_connection_success():
	# Arrange
	var signal_received = false
	manager.wallet_connected.connect(func(addr): signal_received = true)
	
	# Act
	manager._simulate_connection_success("0x123")
	
	# Assert
	assert_true(signal_received)
	assert_eq(manager.get_connected_address(), "0x123")

func test_wallet_connection_failure():
	# Test error handling
	var error_received = false
	manager.connection_error.connect(func(msg): error_received = true)
	
	manager._simulate_connection_failure("Network error")
	
	assert_true(error_received)
	assert_false(manager.is_wallet_connected())
```

**Integration Test Example:**
```gdscript
extends GutTest

func test_full_connection_flow():
	# Test complete user flow
	BaseKit.connect_wallet()
	await BaseKit.wallet_connected
	
	BaseKit.get_base_name()
	await BaseKit.basename_resolved
	
	BaseKit.get_avatar()
	await BaseKit.avatar_loaded
	
	assert_true(BaseKit.is_wallet_connected())
	assert_false(BaseKit.get_cached_base_name().is_empty())
	assert_not_null(BaseKit.get_cached_avatar())
```

### Test Coverage

Aim for:
- 90%+ code coverage for core functionality
- 100% coverage for critical paths
- Integration tests for all user flows
- Performance tests for bottlenecks

## Documentation Guidelines

### Code Documentation

**Class Documentation:**
```gdscript
## BaseKit Manager - Central coordinator for Web3 identity
##
## The BaseKit Manager serves as the main API interface for developers,
## coordinating between wallet connection, Base Name resolution, and
## session management components.
##
## Usage:
## [codeblock]
## BaseKit.wallet_connected.connect(_on_wallet_connected)
## BaseKit.connect_wallet()
## [/codeblock]
##
## @tutorial: https://basekit.dev/docs/getting-started
class_name BaseKitManager
```

**Method Documentation:**
```gdscript
## Connect to user's wallet using OAuth flow
##
## Initiates browser-based wallet authentication. The connection
## process is asynchronous - use the wallet_connected signal to
## handle successful connections.
##
## @param force_reconnect: Skip session restoration and force new connection
## @throws ConnectionError: When network is unavailable
## @emits wallet_connected: On successful connection
## @emits connection_error: On connection failure
func connect_wallet(force_reconnect: bool = false) -> void:
```

### README Updates

When adding features, update relevant README sections:
- Feature list
- Quick start examples
- API changes
- Breaking changes

### Changelog

Update `CHANGELOG.md` with:
- New features
- Bug fixes
- Breaking changes
- Deprecations

## Reporting Issues

### Bug Reports

Use the bug report template:

```markdown
**Describe the bug**
Clear description of the issue

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen

**Screenshots**
If applicable, add screenshots

**Environment:**
- OS: [e.g. Windows 10]
- Godot Version: [e.g. 4.2]
- BaseKit Version: [e.g. 1.0.0]
- Browser: [e.g. Chrome 120]

**Additional context**
Any other context about the problem
```

### Feature Requests

Use the feature request template:

```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
Clear description of what you want to happen

**Describe alternatives you've considered**
Alternative solutions or features considered

**Additional context**
Any other context or screenshots
```

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different opinions and approaches

### Communication

- **GitHub Issues:** Bug reports and feature requests
- **GitHub Discussions:** General questions and ideas
- **Discord:** Real-time chat and community support
- **Email:** Security issues and private matters

### Recognition

Contributors are recognized in:
- `CONTRIBUTORS.md` file
- Release notes
- Documentation credits
- Community highlights

## Release Process

### Version Numbering

BaseKit follows semantic versioning (SemVer):
- `MAJOR.MINOR.PATCH`
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes (backward compatible)

### Release Checklist

**Pre-release:**
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version numbers bumped
- [ ] Security review completed

**Release:**
- [ ] Create release tag
- [ ] Build distribution packages
- [ ] Update package managers
- [ ] Announce release

**Post-release:**
- [ ] Monitor for issues
- [ ] Update documentation site
- [ ] Plan next release

## Getting Help

### For Contributors

- Check existing issues and PRs
- Read the documentation thoroughly
- Ask questions in GitHub Discussions
- Join the Discord community

### For Maintainers

- Review PRs promptly
- Provide constructive feedback
- Help onboard new contributors
- Maintain project roadmap

Thank you for contributing to BaseKit! 🚀