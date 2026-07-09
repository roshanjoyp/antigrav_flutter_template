# RevenueCat Setup

The template ships with monetization **disabled**: the paywall runs against
`StubSubscriptionRepository` (fake packages, in-memory entitlement) so the
whole flow is explorable with no store accounts. Follow this guide to switch
the paywall to real purchases through
[RevenueCat](https://www.revenuecat.com/docs/getting-started).

## What you get

- `SubscriptionRepository` — vendor-agnostic contract (status stream,
  offering fetch, purchase, restore)
- `RevenueCatSubscriptionRepositoryImpl` — the real implementation, bound
  with one switch
- `subscriptionStatusProvider` — watch it anywhere and check `isSubscribed`
  to gate premium content
- `/paywall` — a ready paywall screen using the core widgets

## Prerequisites

1. Store setup first — RevenueCat sits on top of the stores:
   - **iOS**: an App Store Connect app + signed Paid Applications agreement,
     and your in-app purchase products created.
   - **Android**: a Google Play Console app (at least internal testing
     track) with your subscription products created.
2. A [RevenueCat account](https://app.revenuecat.com) (free up to
   $2.5k MTR).

## Step 1 — Create the RevenueCat project

1. Create one project, then add an **App** per platform (App Store,
   Play Store) and connect the store credentials the dashboard asks for
   (App Store Connect API key / Play service account JSON).
2. Create your **products** in the dashboard (they import from the stores).
3. Create an **entitlement** with identifier `premium` — the id the
   template checks (`RevenueCatConfig.premiumEntitlementId`). Attach your
   products to it.
4. Create an **offering** (the default one is fine) and add packages
   (monthly/annual/lifetime). The paywall screen renders whatever the
   *current* offering contains — no code changes to re-merchandise.

## Step 2 — Paste the SDK keys

In `lib/core/config/revenuecat/revenuecat_config.dart`:

1. Replace `appleApiKey` with the **public Apple SDK key** (`appl_...`)
   from Project settings → API keys.
2. Replace `googleApiKey` with the **public Google SDK key** (`goog_...`).
3. Delete the `// REVENUECAT_KEYS_PLACEHOLDER` marker comment.
4. Flip `enabled` to `true`.

That's the whole switch: `main.dart` sees `RevenueCatConfig.enabled`,
configures the SDK at startup, and applies
`revenueCatServiceOverrides()` (lib/app/config/revenuecat_overrides.dart),
which rebinds `subscriptionRepositoryProvider` to the RevenueCat
implementation. No call sites change. Desktop and web builds keep the stub
automatically (`RevenueCatConfig.isPlatformSupported`).

One key pair serves all flavors: RevenueCat separates sandbox from
production by *store environment* (sandbox testers / license testers vs.
live store), not by API key. If you want separate RevenueCat projects per
flavor anyway, switch on `AppFlavor.instance.env` inside
`RevenueCatConfig.initialize`.

## Step 3 — Identify users (recommended)

By default the SDK generates an anonymous app user id per install, which
means entitlements don't follow a signed-in user across devices. Once
Firebase Auth is enabled, call `Purchases.logIn(user.id)` after sign-in and
`Purchases.logOut()` after sign-out. The natural place is wherever you
handle auth state transitions; see the RevenueCat
[identity docs](https://www.revenuecat.com/docs/customers/user-ids).

## Step 4 — Sandbox testing

**iOS**
1. Create a **Sandbox Apple Account** in App Store Connect → Users and
   Access → Sandbox.
2. On a real device (simulators are unreliable for StoreKit), sign into
   Settings → App Store → Sandbox Account with it.
3. Run a debug build, open `/paywall`, buy — the sheet shows the sandbox
   badge and no real money moves. Renewals are accelerated (a month ≈ 5
   minutes), which is exactly what you want for testing expiration.

**Android**
1. Play Console → Settings → License testing: add your testers' Gmail
   addresses.
2. Upload a build to the **internal testing** track, install it from the
   Play link as a license tester, and purchase — test cards, no charge.

**Both**: debug builds log at `LogLevel.debug`
(`RevenueCatConfig.initialize`), so watch the console for `Purchases` lines
when diagnosing. Purchases made in sandbox appear in the RevenueCat
dashboard's sandbox mode toggle.

### Verifying the wiring

- Paywall shows your real packages with store-localized prices → offering
  + products are wired.
- Buying flips the screen to "You're premium!" → entitlement mapping works.
- Delete + reinstall the app, then "Restore purchases" → restore works.
- `subscriptionStatusProvider` updates without a restart on renewal or
  expiration → the status stream works.

## Errors

Store errors are normalized to `AppException` codes by
`mapRevenueCatError` (`paywall/network`, `paywall/configuration`, …).
`paywall/purchase-cancelled` means the user closed the store sheet — the
paywall screen ignores it silently by design; do the same in your own UI.

## Where things live

| Piece | Path |
| --- | --- |
| Enable switch + API keys | `lib/core/config/revenuecat/revenuecat_config.dart` |
| Override binding | `lib/app/config/revenuecat_overrides.dart` |
| Contract + entities | `lib/features/paywall/domain/` |
| Stub + RevenueCat impls | `lib/features/paywall/data/` |
| Paywall screen + providers | `lib/features/paywall/presentation/` |
