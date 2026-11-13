# Zettelwand

Haftnotizen sammeln, abfotografieren und ordnen – gebaut fürs iPad, funktioniert aber auch auf iPhone, Mac und PC.

- Echte Post-its fotografieren: Die App erkennt die einzelnen Zettel und übernimmt sie als eigene Notizen.
- Mit dem Apple Pencil direkt auf die Zettel schreiben und zeichnen.
- Nach Farbe oder im Raster ordnen, mehrere Boards, Suche.
- Export als Bild (PNG), Tabelle (CSV) oder Sicherungsdatei (JSON).
- Alles bleibt auf dem Gerät. Kein Konto, kein Server.

Es gibt zwei Wege, die App zu nutzen:

| | Web-App über GitHub Pages | App aus dem App Store |
|---|---|---|
| Aufwand | 10 Minuten, kostenlos | Mac mit Xcode, Apple Developer Program (99 € / Jahr) |
| Installation | Safari → „Zum Home-Bildschirm“ | App Store oder TestFlight |
| Offline | ja | ja |
| Handschrift → Text | nein | ja, auf dem Gerät (Apple Vision) |
| Anleitung | unten | [APPSTORE.md](APPSTORE.md) |

Beide Wege nutzen denselben Code im Ordner `docs/`.

---

## Web-App über GitHub Pages veröffentlichen

1. **Repository anlegen:** Auf github.com → „New repository“, z. B. `zettelwand`. Sichtbarkeit „Public“ (GitHub Pages ist bei privaten Repos nur mit bezahltem Konto möglich).
2. **Dateien hochladen:** Im neuen Repository auf „uploading an existing file“ klicken und den **Inhalt** dieses Ordners hineinziehen (also `docs/`, `native/`, `README.md` usw., nicht den Ordner selbst). Unten „Commit changes“.
   Mit Git geht es so:
   ```bash
   git init && git add . && git commit -m "Zettelwand"
   git branch -M main
   git remote add origin https://github.com/DEIN-NAME/zettelwand.git
   git push -u origin main
   ```
3. **GitHub Pages einschalten:** Repository → *Settings* → *Pages* → bei „Build and deployment“ *Source:* „Deploy from a branch“, *Branch:* `main`, Ordner `/docs` → *Save*.
4. Nach ein bis zwei Minuten ist die App erreichbar unter
   `https://DEIN-NAME.github.io/zettelwand/`

### Auf dem iPad installieren

1. Die Adresse in **Safari** öffnen.
2. Teilen-Symbol → **„Zum Home-Bildschirm“** → „Hinzufügen“.
3. Ab jetzt die App über das Symbol starten. Sie läuft im Vollbild und auch ohne Internet.

Andere bekommen die App, indem du ihnen den Link schickst. Jedes Gerät hat seine eigenen, getrennten Boards.

### Daten und Sicherung

- Die Boards liegen im Speicher der App auf dem jeweiligen Gerät (IndexedDB).
- Wichtig: Immer die **Home-Bildschirm-App** benutzen, nicht den normalen Safari-Tab. Safari kann Website-Daten sonst nach längerer Nichtnutzung löschen.
- Wird die App vom Home-Bildschirm gelöscht oder werden die Safari-Daten gelöscht, sind die Boards weg. Deshalb regelmäßig **Export → Alle Boards sichern** (z. B. in iCloud Drive). Der Status oben rechts zeigt beim Antippen das Datum der letzten Sicherung.
- Umzug auf ein anderes iPad: dort **Export → Sicherung laden** und die Sicherungsdatei wählen.

### Updates einspielen

1. Geänderte Dateien in `docs/` hochladen.
2. In `docs/sw.js` die Zeile `const VERSION = 'zettelwand-v1';` hochzählen (`v2`, `v3` …). Sonst behalten installierte Apps die alte Version im Offline-Speicher.
3. Auf dem iPad die App einmal schließen und neu öffnen (eventuell zweimal), dann ist das Update da. Die Boards bleiben erhalten.

---

## Ordnerstruktur

```
docs/                    Die App (wird von GitHub Pages und von der iOS-App benutzt)
  index.html             Die komplette App
  manifest.webmanifest   App-Name, Farben, Symbole
  sw.js                  Offline-Speicher
  datenschutz.html       Datenschutzerklärung (für den App Store nötig)
  icons/                 App-Symbole
native/ios/              Zusatzdateien für die App-Store-Version
  VisionOCRPlugin.swift  Handschrift-Erkennung mit Apple Vision
  ZettelViewController.swift
  Info-plist-Eintraege.xml
  AppIcon-1024.png
package.json             Capacitor (nur für die App-Store-Version)
capacitor.config.json
APPSTORE.md              Schritt-für-Schritt zur App-Store-Version
```

## Hinweis zum Namen

„Post-it“ ist eine eingetragene Marke von 3M. Die App heißt deshalb „Zettelwand“. Bitte „Post-it“ nicht im App-Namen, Symbol oder in der App-Store-Beschreibung verwenden.
