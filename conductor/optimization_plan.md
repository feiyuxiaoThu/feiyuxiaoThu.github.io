# Blog Optimization Plan: Efficiency & Aesthetics

This plan aims to streamline the publishing process and enhance the visual/reading experience of the blog.

## Overview
The optimization is divided into three phases: 
1. **Efficiency Foundation**: Automating the navigation and optimizing the CI/CD.
2. **Reading Experience**: Enhancing Chinese typography and site responsiveness.
3. **Visual Polish**: Adding modern UI elements like social cards and grid layouts.

## Task List

### Phase 1: Efficiency Foundation (Automated Workflow)

#### Task 1: Implement Automated Navigation
**Description:** Replace the manual `nav` maintenance in `mkdocs.yml` with `mkdocs-awesome-pages-plugin`. This will allow the sidebar to update automatically based on the folder structure.
**Acceptance criteria:**
- [ ] `mkdocs-awesome-pages-plugin` added to `requirements.txt`.
- [ ] `mkdocs.yml` cleaned up (manual `nav` removed or simplified).
- [ ] Local build confirms all pages are still accessible and correctly nested.
**Verification:**
- [ ] Run `mkdocs serve` and verify the sidebar structure.
**Files likely touched:** `mkdocs.yml`, `requirements.txt`.

#### Task 2: Optimize CI/CD Pipeline
**Description:** Simplify the GitHub Actions workflow by moving the statistics plugin to a direct git reference in `requirements.txt`.
**Acceptance criteria:**
- [ ] `requirements.txt` updated with `git+https://...` for the statistics plugin.
- [ ] `.github/workflows/ci.yml` simplified (removal of `git clone` steps).
- [ ] Successful deployment via GitHub Actions.
**Files likely touched:** `requirements.txt`, `.github/workflows/ci.yml`.

### Phase 2: Reading Experience & Responsiveness

#### Task 3: Enable Heti (Typography) & Instant Loading
**Description:** Activate the `heti` plugin for better Chinese layout and enable Material's `instant` loading features for a SPA-like feel.
**Acceptance criteria:**
- [ ] `heti` plugin added to `mkdocs.yml` plugins.
- [ ] `navigation.instant`, `navigation.instant.progress`, and `navigation.instant.prefetch` enabled.
**Verification:**
- [ ] Check page transitions for progress bars.
- [ ] Verify Chinese text spacing (especially between Chinese and English/Numbers).
**Files likely touched:** `mkdocs.yml`.

### Phase 3: Visual Polish

#### Task 4: Enable Social Cards & Blog Grid Layout
**Description:** Configure the `social` plugin for better link previews and explore card-based layouts for the blog index.
**Acceptance criteria:**
- [ ] `social` plugin enabled in `mkdocs.yml`.
- [ ] Blog index page updated to use a more visual layout if applicable.
**Files likely touched:** `mkdocs.yml`.

## Risks and Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| Auto-nav reorders pages unexpectedly | Med | Use `.pages` files to maintain specific ordering where necessary. |
| Instant loading breaks custom JS | Low | Your custom JS (MathJax, TOC) seems standard; test carefully after activation. |

## Open Questions
- Do you have specific pages where the order *must* be strictly controlled, or is alphabetical/date-based okay?
- Should I proceed with Phase 1 immediately?
