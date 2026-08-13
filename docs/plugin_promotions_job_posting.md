# Software Engineer (Flutter + Web) — Plug-In Promotions Inc

> Saved reference copy of the job posting (LinkedIn, promoted by hirer).
> Status at time of saving: **No longer accepting applications.**

- **Company:** Plug-In Promotions Inc (Plugin Promotions)
- **Location:** India · Remote
- **Type:** Full-time
- **Hours:** Overlap with US Eastern hours required
- **Contact:** sumesh@pluginpromotions.com

---

## About Plugin Promotions

Plug-in Promotions builds Plugin OS, the platform powering promotions and connected hardware
inside live venues. The product is deployed across approximately 250 venues with around 700
devices in the field, and it is used every night by real operators and their customers.

We are a venture backed company with a small engineering team and a short path from
decision to production.

## The opportunity

We are looking for a Software Engineer to take ownership of significant parts of the Plugin OS
product surface, working closely with our CTO.

This is a high autonomy role. You will own features from specification through to release across
mobile, web and backend, rather than working from a groomed ticket queue. If you want scope
and visible impact early, this role offers both.

## Responsibilities

- Design, build and ship features across our Flutter mobile applications
- Build web dashboards and internal tooling in React or Vue
- Work across the Firebase stack, including Firestore, Authentication, Cloud Functions, Storage and Cloud Messaging
- Translate product direction into working software quickly, iterating with the CTO as it takes shape
- Manage releases to the App Store and Google Play, and support the product once it is live

## Requirements

- Demonstrable production experience with Flutter, including applications published to the App Store or Google Play
- Strong Firebase experience covering Firestore data modelling, security rules and Cloud Functions
- Working proficiency with React or Vue.js
- The ability to carry a feature from concept through to deployment independently
- Professional working English, spoken and written, sufficient for calls and async collaboration across time zones

## Preferred

- Experience with point of sale, payments, kiosk or other hardware adjacent systems
- Experience at an early stage company with a small engineering team

## How we work

We are an AI native engineering team. Cursor, Claude Code and similar tools are a standard
part of our workflow, and we license them for the whole team.

We are interested in engineers who use these tools deliberately and get more done because of
them. Equally, we expect the engineering judgement to review what is generated, recognise
when it is wrong, and diagnose production issues on devices already deployed in venues.

Please tell us how you work with these tools when you apply.

## Compensation and benefits

- Competitive monthly compensation in USD, benchmarked to experience and market
- Equity participation for early team members
- Flexible time off with no fixed annual allowance
- Health coverage, or a monthly stipend toward a local plan for candidates outside the US
- Full AI tooling and development software licensed by the company
- Meaningful ownership of a product operating at real scale

## Hiring process

We do not run screening calls before seeing code. The build task described below is part of the
application itself.

1. Complete the build task and submit it with your application
2. Application and submission review, with a response either way within one week
3. A technical discussion of your submission with the CTO
4. Offer decision

Every complete submission is reviewed by the CTO and receives a written response. We know
what we are asking for and we will not leave you waiting.

## How to apply

Email sumesh@pluginpromotions.com with the following:

1. Your CV or LinkedIn profile
2. Two or three applications you have shipped, with store links where available
3. Your GitHub or portfolio
4. A short note on how you use AI tooling in your development workflow
5. Your expected monthly compensation in USD
6. Your completed build task, as described below

Applications without a completed build task will not be reviewed.

---

## The build task

This is required. It is how we assess candidates, and it replaces the usual screening call.

**Lightweight POS with remote menu control**

Build a Flutter project containing two applications sharing a single Firebase backend.

### POS application (tablet or web layout)

- Displays the active menu with item name, price, category and availability
- Selecting items builds an order with a running total
- Menu changes made from the manager application appear live, without a restart

### Manager application (phone layout)

- Create, edit and delete menu items
- Toggle items between available and sold out
- Changes propagate to the POS application in real time

### Expectations

- Flutter for both applications, Firestore as the backend
- Shared models and business logic across the two applications rather than duplicated code
- Basic Firestore security rules
- A README covering how to run the project, the reasoning behind your architecture, what you
  would build next with more time, and which AI tools you used and for what

### Scope

Designed to take six to eight hours. How you scope your work is part of what we are assessing,
so a smaller implementation that works correctly is a stronger submission than a larger one left
unfinished. Note in the README anything you deliberately left out and why.

### Submission

Upload to Google Drive and share the link with sumesh@pluginpromotions.com.

Include the repository or an archive, plus a two to three minute screen recording showing both
applications working together.
