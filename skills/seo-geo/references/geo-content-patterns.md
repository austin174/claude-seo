# GEO Content Patterns & Platform Citation Factors

Content structure patterns optimized for AI citation, plus platform-specific ranking signals. Use alongside the main seo-geo SKILL.md for content optimization recommendations.

---

## Citation Boost Research Data

From Princeton GEO study (KDD 2024), SE Ranking domain authority study, and ZipTie content-answer fit analysis:

| Optimization | Citation Visibility Boost |
|---|---|
| Authoritative citations (named sources with data) | +132% |
| Authoritative tone (not salesy) | +89% |
| Statistics with source attribution | +15-30% per stat |
| Schema markup (FAQPage, Article, HowTo) | +30-40% |
| Content updated within 30 days (ChatGPT) | +320% vs older content |
| Content-answer format match (ChatGPT) | 55% of citation likelihood |

---

## Answer Engine Optimization (AEO) Patterns

### Definition Block
For "What is [X]?" queries:
```
## What is [Term]?

[Term] is [concise 1-sentence definition]. [Expanded 1-2 sentence explanation].
[Brief context on why it matters].
```

### Step-by-Step Block
For "How to [X]" queries (list snippets):
```
## How to [Action/Goal]

[1-sentence overview]

1. **[Step Name]**: [Action in 1-2 sentences]
2. **[Step Name]**: [Action in 1-2 sentences]
3. **[Step Name]**: [Action in 1-2 sentences]
```

### Comparison Table Block
For "[X] vs [Y]" queries (table snippets):
```
| Feature | [Option A] | [Option B] |
|---------|-----------|-----------|
| [Criteria] | [Value] | [Value] |
| Best For | [Use case] | [Use case] |

**Bottom line**: [1-2 sentence recommendation]
```

### FAQ Block
For topic pages with multiple questions (triggers FAQ schema):
```
### [Question phrased as users search]?

[Direct answer in first sentence]. [Supporting context in 2-3 sentences].
```
Keep answers 50-100 words. Match "People Also Ask" phrasing.

---

## Generative Engine Optimization (GEO) Patterns

### Statistic Citation Block
```
[Claim]. According to [Source/Organization], [specific statistic with number
and timeframe]. [Why this matters].
```

### Expert Quote Block
```
"[Direct quote]," says [Name], [Title] at [Organization]. [Context].
```

### Self-Contained Answer Block
```
**[Topic/Question]**: [Complete answer that makes sense without additional
context. 2-3 sentences with specific details or numbers.]
```

### Evidence Sandwich Block
```
[Opening claim].

Evidence:
- [Data point 1 with source]
- [Data point 2 with source]
- [Data point 3 with source]

[Concluding actionable insight].
```

---

## Third-Party Presence Checklist

AI platforms cite third-party mentions heavily. For maximum GEO visibility:

| Platform | Why It Matters | Action |
|---|---|---|
| **Wikipedia** | 7.8% of all ChatGPT citations | Ensure brand has accurate Wikipedia mention (or relevant topic article) |
| **Reddit** | 1.8% of ChatGPT citations, Perplexity indexes heavily | Authentic community presence in relevant subreddits |
| **YouTube** | Google AIO cites video transcripts | Create video content for key topics |
| **LinkedIn** | Copilot boosts LinkedIn-present brands | Publish articles, maintain company page |
| **GitHub** | Copilot boosts GitHub-present brands | Open-source tools, public repos if relevant |
| **Forbes/major publications** | 1.1% of ChatGPT citations | Earned media, guest posts, HARO |
| **Industry directories** | Perplexity curated domain lists | Get listed in relevant authoritative directories |

---

## Platform-Specific Optimization Summary

### Google AI Overviews (45% of searches)
- Schema markup is the single biggest lever (FAQPage, Article, HowTo, Product)
- Content clusters with strong internal linking
- Named, sourced citations in content
- Author bios with real credentials
- Target "how to" and "what is" query patterns

### ChatGPT (Bing-based index)
- Domain authority: 40% of citation weight
- Content freshness: update monthly for competitive topics
- Content-answer fit: 55% of citation likelihood — structure content like ChatGPT answers
- High referring domain count correlates with more citations

### Perplexity (own index + Google)
- FAQ Schema (JSON-LD) strongly preferred
- Public PDFs (whitepapers, reports) prioritized
- Publishing velocity matters
- Self-contained paragraphs for clean extraction
- Allow PerplexityBot in robots.txt

### Microsoft Copilot (Bing index)
- Submit to Bing Webmaster Tools
- IndexNow protocol for faster indexing
- Page speed under 2 seconds
- LinkedIn and GitHub presence provides ranking boost
- Clear entity definitions

### Claude (Brave Search index)
- Verify content appears in Brave Search (search.brave.com)
- Allow ClaudeBot and anthropic-ai user agents
- Maximize factual density — specific numbers, named sources
- Precision rewarded over volume

---

## Domain-Specific GEO Tactics

| Content Domain | Key Authority Signals |
|---|---|
| Technology | Technical precision, version numbers, official docs references, code examples |
| Health/Medical | Peer-reviewed studies, expert credentials (MD, RN), "last reviewed" dates |
| Financial | Regulatory body references (SEC, FTC), specific numbers with timeframes |
| Legal | Specific statutes/regulations, jurisdiction clarity, professional disclaimers |
| Business/Marketing | Case studies with measurable results, industry research, % changes with timeframes |

---

## AI Bot Access (robots.txt)

```
User-agent: GPTBot
User-agent: ChatGPT-User
User-agent: PerplexityBot
User-agent: ClaudeBot
User-agent: anthropic-ai
User-agent: Google-Extended
User-agent: Bingbot
Allow: /
```

**Safe to block** (training only, no search citations): CCBot (Common Crawl)
