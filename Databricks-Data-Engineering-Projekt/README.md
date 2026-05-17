# Databricks E-Commerce Data Engineering Projekt

## Überblick

Dieses Projekt simuliert ein realistisches Enterprise-Data-Engineering-Szenario nach der Übernahme eines schnell wachsenden Startups durch einen großen Sportartikelhersteller.

Ziel des Projekts ist der Aufbau einer skalierbaren und zuverlässigen Analyseplattform, welche fragmentierte und inkonsistente Datenquellen in eine einheitliche Reporting- und Analytics-Schicht integriert.

Die Lösung wurde mit Databricks umgesetzt und basiert auf der Medallion Architecture (Bronze, Silver, Gold).

---

# Business-Szenario

Atlon, ein internationaler Hersteller von Sportequipment, übernimmt das schnell wachsende Startup SportsBar im Bereich Sporternährung und Energy Bars.

Während Atlon über strukturierte ERP-basierte Systeme verfügt, bestehen die Datenquellen von SportsBar aus:

- Excel-Dateien
- Cloud-Exporten
- uneinheitlichen APIs
- inkonsistenten Datenformaten
- fehlenden historischen Daten

Nach der Übernahme entstehen erhebliche Probleme:

- widersprüchliche Reports
- inkonsistente KPIs
- fehlende Datenqualität
- keine zentrale Analytics-Plattform

Das Data-Engineering-Team erhält die Aufgabe, eine skalierbare und zuverlässige Datenplattform aufzubauen, um beide Unternehmen analytisch zusammenzuführen.

---

# Projektziele

- Aufbau einer skalierbaren Datenplattform
- Vereinheitlichung fragmentierter Datenquellen
- Erstellung zuverlässiger Analyse-Datensätze
- Ermöglichung zentraler Business-Reports
- Unterstützung langfristiger Skalierung
- Einfache Erweiterbarkeit für zukünftige Data-Teams

---

# Architektur

Das Projekt basiert auf der Medallion Architecture:

```text
Rohdaten
   ↓
Bronze Layer
   ↓
Silver Layer
   ↓
Gold Layer
   ↓
Analytics Dashboard
