# Vortragsnotizen 


	
## Folie 3

	- SDRAM: Synchronuos Dynamic Random Access Memory
	- Nicht flüchtiger Speicher: Auch Festspeicher/persistenter Speicher
	- Ethernet: In, Micro-USB: In, Audio: Out, Video: Out, USB: In, HDMI: Out

	### Unterschied Mini-/Micro-USB
		- gleiche Funktion, doch seit 2011 wird fast ausschließlich Micro-USB-Technologie eingesetzt (geringere Größe, langlebiger)
		- RPi: Micro-USB!

## Folie 5

	- RAID Level 1? 
	- Beachte: L2-Cache geteilt zwar offizell geteilt zw. GPU und CPU, aber anscheinend werden CPU-Anfragen daran vorbei geroutet 
	- Beowulf-Cluster: historisch ab ca. 1995
	- Kosten Bramble insgesamt: ca. 2500 Euro 


## Folie 6 

	- Beachte: Prozessor: ARM 11/ARMv6
	- CISC: Complex Instruction Set Computer, variable Instruktionslänge
	- RISC: Reduced Instruction Set Computer 
	- x86 heute: hybride CISC/RISC-Prozessoren (erste Umsetzung: Pentium Pro); seit ca. 2002: 64-Bit-Befehlssatzarchitektur (statt vorher 32 Bit)


## Folie 8 

	### NFS (Network File System) 
		- UNIX-Netzwerkprotokoll zum Dateizugriff über ein Netzwerk
		- die Dateien nicht wie z. B. bei FTP übertragen, sondern die Benutzer können auf Dateien, die sich auf einem entfernten Rechner befinden, so zugreifen, als ob sie auf ihrer lokalen Festplatte abgespeichert wären
		- auch "verteiltes Dateisystem"
		- nfs 3 nutzt IP  
	
	### AUFS (Advanced Multi Layer Unificated File System): 
		- Overlay-Dateisystem zum (scheinbaren) Schreiben von Daten auf nicht beschreibbaren Datenträgern 
		- Dazu werden mind. zwei Dateisysteme übereinander gelegt (ein beschreibbares Dateisystem über ein nicht beschreibbares)
		- Soll eine Datei gelesen werden, wird zunächst versucht, sie auf dem beschreibbaren Dateisystem zu lesen. Ist sie dort nicht vorhanden, wird sie aus dem darunter liegenden, nicht beschreibbaren Dateisystem gelesen
		- Ein Schreibzugriff erfolgt immer auf das beschreibbare Dateisystem

	- Beachte: Unterschiedliche Architekturen Server/Nodes!
	- Resultierende Fragestellung: mündlich 


## Folie 9

	- Thema: Methodisches Vorgehen 
	- Ergänze: Keine MPICH-Implemetierung für Whetstone


## Folie 10

	### HPL.dat 
		- Problemgröße N: 
			Proportionalitätskonstante: k = N^2/Menge HS
			4 RPis: N = 2880
			8 RPis: N = 4032 
			16 RPis: N = 5760

		- Blockgröße NB: Lösung des linearen Gleichungssystems durch L/U-Faktorisierung. Dazu wird eine n × n + 1-Koeffizientenmatrix der Ausgangsmatrix A erzeugt. A wird dazu Blöcke der Größe NB × NB aufgeteilt. 

		- Prozessnetz (P x Q): Die Blöcke werden zur Bearbeitung einem Netz aus Prozessoren übergeben. P bezeichnet die Anzahl von Prozessoren in einer Spalte, Q die Anzahl von Prozessoren in einer Zeile des Netzes. 

		- PFACTs und RFACTs: Zur Unterteilung der Matrix in Submatrizen/Unterteilung der Submatrizen werden drei Algorithmen angeboten: Links-schauende, rechts-schauende und Crout-Faktorisierung. 

	### HPL-Algorithmus 
		- Reziproke: Kehrwert

	### STREAM-Algorithmus 
		- Länge Vektoren: mind. 1000000 Elemente oder 4 x Gesamt-Cachegröße
		- hier: Cache-Gesamtgröße = max. 19 x 16 kB = 1216 kB = 1.1875 MB
		- Standard-Problemgröße = 2000000 Elemente, angemessen f. 4 MB Cache => reicht bei Weitem aus!
		- Modul TRIAD: a[i] = b[i] + q * c[i]


## Folie 13
	
	- mündlich erklären 
	- Ergänze: Einmalige DB-Konfiguration für Benchmark nicht in Diagramm!


## Folie 14

	- mündlich erklären 
	- Beachte: Aufzeichnung der Messwerte wird nicht explizit gestartet, sondern implizit mit Programmaufruf!


## Folie 15

	- Erklärung Tabelle (in Ausarbeitung, falls notwendig): 1. Stromverbrauch im Mittel pro ExperimentSuite; 2. max. Abweichung davon; 3. Zuwachs pro angeschaltetem RPi-Knoten; 4. Stromverbrauch im Mittel pro Messreihe

	- Stromverbrauch RPi idle: ca. 2.3 +- 3 W; GPU verbraucht deutlich mehr Strom als CPU
	- Stromverbrauch Server bei 80-90% CPU-Auslastung (theoretisch): ca. 26 W + 6.5 W (Netzteil-Overhead) 
	- Stromverbrauch Server + Netzteil (real): ca. 43 W
	- Stromverbrauch gesamt idle: ca. 101 W
	=> relativ hoher Stromverbrauch unter Niedriglast
	=> schlechtere Ausbeute als 80-90% des Netzteils unter Niedriglast (gegenüber Herstellerangaben)
	=> Energieeffizienz der RPis kann unter laufendem Setup nicht ausgenutzt werden (größtmögliche theoretische Ausbeute unter Volllast: 50%)


## Folie 16

	- mündlich erklären 


## Folie 17

	- mündlich erklären 	


## Folie 25

	- Netzwerk-Datendurchsatz checken (Erklärung wasserdicht!)

