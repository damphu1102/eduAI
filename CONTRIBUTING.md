# Contributing to SysEdu AI

Thank you for your interest in contributing to SysEdu AI! This document provides guidelines and instructions for contributing.

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone <your-fork-url>`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit with clear messages
7. Push to your fork
8. Create a Pull Request

## 📝 Code Style Guidelines

### TypeScript

- Use TypeScript for all new files
- Define proper types and interfaces
- Avoid using `any` type
- Use meaningful variable and function names

### React Components

- Use functional components with hooks
- Keep components small and focused (< 200 lines)
- Extract reusable logic into custom hooks
- Use proper prop types

### File Organization

```
src/
├── components/
│   ├── layout/          # Layout components
│   ├── features/        # Feature-specific components
│   └── common/          # Reusable components
├── pages/               # Page components
├── hooks/               # Custom hooks
├── utils/               # Utility functions
├── types/               # Type definitions
└── services/            # API services
```

### Naming Conventions

- **Components**: PascalCase (e.g., `UserProfile.tsx`)
- **Hooks**: camelCase with 'use' prefix (e.g., `useAuth.ts`)
- **Utils**: camelCase (e.g., `formatDate.ts`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_URL`)
- **Types/Interfaces**: PascalCase (e.g., `UserData`)

### CSS/Styling

- Use Tailwind CSS utility classes
- Follow mobile-first approach
- Use consistent spacing (4, 6, 8, 12, 16, 24)
- Maintain color consistency with design system

## 🧪 Testing

- Test your changes on different screen sizes
- Verify responsive design works correctly
- Check browser console for errors
- Test authentication flow
- Verify all routes work properly

## 📋 Pull Request Process

1. **Update Documentation**: Update README.md if needed
2. **Clear Description**: Explain what changes you made and why
3. **Screenshots**: Include screenshots for UI changes
4. **Test Results**: Describe how you tested your changes
5. **Breaking Changes**: Clearly mark any breaking changes

### PR Title Format

```
[Type] Brief description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes (formatting)
- refactor: Code refactoring
- perf: Performance improvements
- test: Adding tests
- chore: Maintenance tasks
```

### PR Description Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

Describe how you tested your changes

## Screenshots (if applicable)

Add screenshots here

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tested on multiple screen sizes
```

## 🐛 Reporting Bugs

### Before Submitting

- Check if the bug has already been reported
- Verify it's reproducible
- Collect relevant information

### Bug Report Template

```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:

1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen

**Screenshots**
If applicable, add screenshots

**Environment:**

- OS: [e.g., Windows 11]
- Browser: [e.g., Chrome 120]
- Version: [e.g., 1.0.0]

**Additional context**
Any other relevant information
```

## 💡 Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
Clear description of desired solution

**Describe alternatives you've considered**
Alternative solutions or features

**Additional context**
Mockups, examples, or other context
```

## 🎯 Development Workflow

1. **Pick an Issue**: Choose an open issue or create one
2. **Discuss**: Comment on the issue before starting work
3. **Branch**: Create a feature branch from `main`
4. **Develop**: Make your changes following guidelines
5. **Test**: Thoroughly test your changes
6. **Commit**: Use clear, descriptive commit messages
7. **Push**: Push to your fork
8. **PR**: Create a pull request with clear description

## 📚 Resources

- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Vite Guide](https://vitejs.dev/guide/)

## ❓ Questions?

Feel free to ask questions by:

- Opening an issue with the `question` label
- Reaching out to maintainers
- Checking existing documentation

## 🙏 Thank You!

Your contributions make SysEdu AI better for everyone. We appreciate your time and effort!
