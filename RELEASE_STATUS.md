# RELEASE STATUS

Last updated: 2026-08-06

## Current state

Apple Developer Explicit App ID and App Store Connect app are registered. The first Codemagic build was started and stopped before compilation because an App Store distribution provisioning profile is not configured. IAP products, iOS distribution build, and TestFlight distribution are pending.

## Fixed values

- Bundle ID: `com.allsunday1122.seiho.ippan`
- Version: `1.0.0`
- Build: pending
- App Store Connect App ID: `6798736588`
- Public URL: `https://allsunday1122.github.io/seiho-ippan-manabi-sprint/`

## Monetization

- Monthly: `com.allsunday1122.seiho.ippan.premium.monthly` — first 7 days free, JPY 200/month
- Lifetime: `com.allsunday1122.seiho.ippan.premium.lifetime` — JPY 980

## Blockers

1. No archive-capable iOS/Codemagic project exists yet.
2. App icon, screenshots, and a public privacy-policy URL are pending.
3. App Store Connect app and IAP products are pending.
4. Device purchase/restore and TestFlight testing are pending.
5. Codemagic build `2026-08-06`: `No matching profiles found for bundle identifier "com.allsunday1122.seiho.ippan" and distribution type "app_store"`.
