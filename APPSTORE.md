# Zettelwand in den App Store bringen

Die App-Store-Version verpackt die Web-App aus `docs/` mit **Capacitor** in eine echte iOS-App und ergänzt eine native Funktion: **Handschrift-Erkennung direkt auf dem Gerät** mit Apple Vision. Exportieren läuft über das normale iOS-Teilen-Menü.

> Dieses Projekt ist vorbereitet, aber noch nicht in Xcode gebaut worden. Rechne beim ersten Build mit kleinen Anpassungen (z. B. Versionsnummern von Capacitor). Die Fehlermeldungen von Xcode sind dabei meist eindeutig.

---

## 1. Voraussetzungen

- **Mac** mit aktuellem **Xcode** (kostenlos im Mac App Store)
- **Node.js** (LTS-Version von nodejs.org)
- **Apple Developer Program** – 99 € pro Jahr, Anmeldung unter developer.apple.com/programs. Zum Testen auf dem eigenen iPad reicht anfangs auch eine kostenlose Apple-ID; für TestFlight und App Store ist die Mitgliedschaft Pflicht.
- Ein **iPad** mit iPadOS 16 oder neuer zum Testen

## 2. Projekt einrichten (einmalig)

Im Terminal im Projektordner:

```bash
npm install
npx cap add ios
```

Es entsteht der Ordner `ios/` mit dem Xcode-Projekt.

## 3. Native Dateien einbinden

```bash
npx cap open ios
```

In Xcode:

1. **Swift-Dateien hinzufügen:** Die beiden Dateien `native/ios/VisionOCRPlugin.swift` und `native/ios/ZettelViewController.swift` aus dem Finder in Xcode auf den Ordner **App → App** ziehen. Im Dialog „Copy items if needed“ und das Target **App** anhaken.
2. **Eigenen View Controller setzen:** `Main.storyboard` öffnen → „Bridge View Controller“ auswählen → rechts *Identity Inspector* → *Custom Class*: `ZettelViewController`, *Module*: `App`.
3. **Info.plist ergänzen:** Die vier Einträge aus `native/ios/Info-plist-Eintraege.xml` in `App/Info.plist` übernehmen (Kamera, Fotos, Verschlüsselungs-Angabe).
4. **App-Symbol:** `Assets` → `AppIcon` → `native/ios/AppIcon-1024.png` in das 1024er-Feld ziehen.
5. **Target „App“ → General:**
   - *Display Name:* Zettelwand
   - *Bundle Identifier:* eindeutig, z. B. `de.deinname.zettelwand`. Denselben Wert in `capacitor.config.json` bei `appId` eintragen.
   - *Minimum Deployments:* iOS 16.0. Ab dieser Version erkennt Apple Vision auch deutsche Texte.
   - *Supported Destinations:* Für den Anfang nur **iPad** (dann brauchst du keine iPhone-Screenshots). iPhone funktioniert technisch auch.
   - *Orientation:* alle vier Richtungen erlauben (für iPad Pflicht).
6. **Signing & Capabilities:** *Team* auswählen (dein Developer-Konto), „Automatically manage signing“ anlassen.

## 4. Auf dem iPad testen

iPad per Kabel verbinden (oder im selben WLAN), oben in Xcode als Ziel auswählen, **▶ Run**.

Beim ersten Mal auf dem iPad: *Einstellungen → Datenschutz & Sicherheit → Entwicklermodus* einschalten.

Testen solltest du vor allem:

- **Erfassen:** Foto aufnehmen. Kommt die Kamera-Abfrage? Werden die Zettel erkannt?
- **Handschrift:** Häkchen „Handschrift in Text umwandeln (auf dem Gerät)“. Taucht der Text in der Suche auf?
- **Export:** Bild, CSV und Sicherung. Öffnet sich das Teilen-Menü?
- **Daten bleiben erhalten:** App komplett beenden und neu starten.

## 5. Änderungen an der App übernehmen

Nach jeder Änderung in `docs/`:

```bash
npx cap sync ios
```

Danach in Xcode neu bauen. Für Updates im App Store außerdem unter *General* die **Version** (z. B. 1.1) oder den **Build** (2, 3 …) erhöhen.

## 6. In App Store Connect anlegen

Auf appstoreconnect.apple.com → *Apps* → **+** → *Neue App*:

- **Plattform:** iOS · **Name:** Zettelwand (falls vergeben: z. B. „Zettelwand – Ideen sortieren“)
- **Primäre Sprache:** Deutsch · **Bundle-ID:** wie in Xcode · **SKU:** beliebig, z. B. `zettelwand1`

Auszufüllen:

| Feld | Vorschlag |
|---|---|
| Untertitel (max. 30 Zeichen) | Haftnotizen erfassen & ordnen |
| Kategorie | Produktivität |
| Beschreibung | Was die App kann; siehe README. Ohne das Wort „Post-it“. |
| Schlüsselwörter | haftnotizen,notizzettel,brainstorming,ideen,whiteboard,workshop,klebezettel,pinnwand |
| Datenschutz-URL | `https://DEIN-NAME.github.io/zettelwand/datenschutz.html` |
| App-Datenschutz | „Keine Daten erfasst“ |
| Altersfreigabe | Fragebogen überall „Nein“ → 4+ |
| Preis | Kostenlos (oder ein Preis deiner Wahl) |
| Screenshots | iPad 13 Zoll: **2064 × 2752** px (Hochformat) oder 2752 × 2064 (Querformat), 3 bis 10 Stück |

**Vorher erledigen:** In `docs/datenschutz.html` die Platzhalter `[Vor- und Nachname]`, Anschrift und E-Mail ausfüllen und hochladen. Ohne erreichbare Datenschutzerklärung lehnt Apple ab.

**Screenshots** gehen am einfachsten im iPad-Simulator von Xcode (*iPad Pro 13-inch*): App starten → `Cmd + S` speichert ein Bildschirmfoto in passender Größe.

## 7. Hochladen und einreichen

1. In Xcode als Ziel **Any iOS Device (arm64)** wählen → Menü *Product → Archive*.
2. Im Organizer **Distribute App** → *App Store Connect* → *Upload*.
3. Nach ca. 15–30 Minuten erscheint der Build in App Store Connect. Optional zuerst über **TestFlight** an Kolleginnen und Kollegen verteilen.
4. Build der Version zuordnen → **Zur Prüfung einreichen**. Die Prüfung dauert meist 1–3 Tage.

## Worauf Apple bei der Prüfung achtet

- **Mindestfunktionalität (Richtlinie 4.2):** Reine „Website in einer Hülle“ wird abgelehnt. Zettelwand bringt eigene Funktionen mit: Kamera-Erfassung, Apple-Pencil-Zeichnen, Texterkennung auf dem Gerät, Offline-Betrieb und das native Teilen-Menü. Diese Punkte im Feld *Notizen für die Prüfung* kurz nennen.
- **Marken (Richtlinie 5.2):** „Post-it“ nirgends verwenden, auch nicht in Schlüsselwörtern.
- **Kamera-Begründung:** Die Texte in der Info.plist müssen erklären, wofür die Kamera genutzt wird. Das ist vorbereitet.
- **Abstürze:** Vorher auf einem echten iPad testen, auch im Querformat und mit Split View.

## Wenn etwas nicht klappt

- **`npm install` meldet Versionskonflikte:** In `package.json` alle `@capacitor/…`-Pakete auf dieselbe aktuelle Hauptversion setzen (z. B. alle `^8.0.0`) und erneut installieren.
- **Texterkennung tut nichts:** Prüfen, ob in `Main.storyboard` wirklich `ZettelViewController` eingetragen ist und beide Swift-Dateien zum Target „App“ gehören (Datei anklicken → rechts *Target Membership*).
- **Teilen-Menü öffnet sich nicht:** `npx cap sync ios` ausführen, damit die Plugins `@capacitor/filesystem` und `@capacitor/share` eingebunden werden.
