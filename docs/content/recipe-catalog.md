# Rezeptkatalog

68 Definitionen; alle definiert, nicht im Spiel implementiert. Mengen und Zeiten sind Balancingentwürfe.

| ID | Verfahren | Eingaben → Ergebnisse | Arbeit / passiv (Spielminuten) | Arbeitsplatz |
|---|---|---|---:|---|
| `recipe.dry_malt` | Malz trocknen | 2.5 kg Gekeimtes Malz, 1 kg Scheitholz → 2 kg Getrocknetes Malz | 30 / 720 | station.drying_rack |
| `recipe.ferment_beer` | Bier vergären | 6 l Würze, 1 piece Gärkultur → 5.5 l Jungbier | 20 / 10080 | station.shelter |
| `recipe.ferment_fruit_wine` | Obstwein vergären | 3 l Obstsaft, 1 piece Gärkultur → 2.8 l Junger Obstwein | 15 / 14400 | station.shelter |
| `recipe.ferment_mead` | Met vergären | 6 l Metansatz, 1 piece Gärkultur → 5.7 l Jungmet | 20 / 20160 | station.shelter |
| `recipe.germinate_malt` | Gerste weichen und keimen | 2 kg Gerstengrain, 3 l Aufbereitetes Wasser → 2.5 kg Gekeimtes Malz | 45 / 4320 | station.shelter |
| `recipe.mash_wort` | Malz schroten und maischen | 2 kg Getrocknetes Malz, 8 l Aufbereitetes Wasser, 2 kg Scheitholz → 6 l Würze | 90 / 60 | station.hearth |
| `recipe.mix_mead` | Metansatz mischen | 1.5 kg Honig, 5 l Aufbereitetes Wasser → 6 l Metansatz | 20 / 0 | station.hand |
| `recipe.press_juice` | Obst pressen | 5 kg Obst → 3 l Obstsaft | 60 / 0 | station.press |
| `recipe.dress_flax` | Flachs brechen und hecheln | 2.5 kg Gerösteter Flachs → 0.6 kg Aufbereitete Flachsfaser | 120 / 0 | station.workbench |
| `recipe.lay_rope` | Seil schlagen | 12 m Pflanzenschnur → 3 m Seil | 45 / 0 | station.hand |
| `recipe.ret_flax` | Flachs rösten | 3 kg Flachsstroh, 10 l Unbehandeltes Wasser → 2.5 kg Gerösteter Flachs | 45 / 10080 | station.vat |
| `recipe.sew_tunic` | Tunika nähen | 2 m2 Leinengewebe, 10 m Leinengarn → 1 piece Einfache Tunika | 180 / 0 | station.hand |
| `recipe.spin_linen` | Leinengarn spinnen | 0.3 kg Aufbereitete Flachsfaser → 100 m Leinengarn | 180 / 0 | station.hand |
| `recipe.spin_wool` | Wollgarn spinnen | 0.3 kg Gewaschene Wolle → 100 m Wollgarn | 150 / 0 | station.hand |
| `recipe.twist_cord` | Pflanzenschnur drehen | 0.2 kg Pflanzenfasern → 3 m Pflanzenschnur | 40 / 0 | station.hand |
| `recipe.wash_wool` | Wolle waschen | 1 kg Rohwolle, 5 l Unbehandeltes Wasser → 0.7 kg Gewaschene Wolle | 45 / 1440 | station.shelter |
| `recipe.weave_basket` | Korb flechten | 12 piece Ast, 2 m Pflanzenschnur → 1 piece Flechtkorb | 180 / 0 | station.hand |
| `recipe.weave_linen` | Leinen weben | 300 m Leinengarn → 1 m2 Leinengewebe | 240 / 0 | station.loom |
| `recipe.weave_wool` | Wollstoff weben | 300 m Wollgarn → 1 m2 Wollgewebe | 240 / 0 | station.loom |
| `recipe.bake_flatbread` | Fladenbrot backen | 1.62 kg Brotteig, 0.7 kg Scheitholz → 1.35 kg Fladenbrot | 25 / 15 | station.hearth |
| `recipe.boil_water` | Wasser abkochen | 2 l Unbehandeltes Wasser, 0.3 kg Scheitholz → 1.8 l Aufbereitetes Wasser | 10 / 10 | station.hearth |
| `recipe.cook_meat` | Fleisch garen | 1 kg Rohes Fleisch, 0.5 kg Scheitholz → 0.75 kg Gegartes Fleisch | 25 / 20 | station.hearth |
| `recipe.cook_stew` | Eintopf kochen | 0.3 kg Rohes Fleisch, 0.2 kg Bestimmte essbare Pilze, 1 l Aufbereitetes Wasser, 0.6 kg Scheitholz → 1.25 kg Eintopf | 25 / 45 | station.hearth |
| `recipe.curdle_milk` | Milch dicklegen | 5 l Milch, 1 piece Lab, 0.3 kg Scheitholz → 0.8 kg Käsebruch, 4 l Molke | 25 / 60 | station.hearth |
| `recipe.drain_cheese` | Frischkäse abtropfen lassen | 0.8 kg Käsebruch, 0.02 kg Salz → 0.6 kg Frischkäse, 0.2 l Molke | 15 / 240 | station.shelter |
| `recipe.dry_berries` | Beeren trocknen | 1 kg Beeren → 0.2 kg Getrocknete Beeren | 15 / 2880 | station.drying_rack |
| `recipe.dry_meat` | Fleisch trocknen | 1 kg Rohes Fleisch, 0.05 kg Salz → 0.35 kg Trockenfleisch | 30 / 2880 | station.drying_rack |
| `recipe.grind_flour` | Getreide mahlen | 1 kg Weizengrain → 0.85 kg Mehl | 45 / 0 | station.hand |
| `recipe.make_porridge` | Getreidebrei kochen | 0.3 kg Gerstengrain, 1 l Aufbereitetes Wasser, 0.4 kg Scheitholz → 1.1 kg Getreidebrei | 15 / 25 | station.hearth |
| `recipe.mix_dough` | Teig kneten | 1 kg Mehl, 0.6 l Aufbereitetes Wasser, 0.02 kg Salz → 1.62 kg Brotteig | 20 / 0 | station.hand |
| `recipe.render_fat` | Fett auslassen | 1 kg Rohfett, 0.4 kg Scheitholz → 0.75 kg Ausgelassenes Fett | 20 / 45 | station.hearth |
| `recipe.clean_hide` | Haut reinigen und entfleischen | 1 piece Frische Haut, 3 l Unbehandeltes Wasser → 1 piece Gesäuberte Haut | 90 / 0 | station.hand |
| `recipe.cut_straps` | Lederriemen schneiden | 1 piece Zugerichtetes Leder → 12 m Lederriemen | 45 / 0 | station.hand |
| `recipe.dry_rawhide` | Rohhaut spannen und trocknen | 1 piece Gesäuberte Haut → 1 piece Getrocknete Rohhaut | 30 / 2880 | station.drying_rack |
| `recipe.extract_tannin` | Gerbbrühe ansetzen | 3 kg Gerbstoffreiche Rinde, 15 l Unbehandeltes Wasser → 14 l Gerbbrühe | 45 / 1440 | station.vat |
| `recipe.finish_leather` | Leder fetten und weicharbeiten | 1 piece Nasses gegerbtes Leder, 0.1 kg Ausgelassenes Fett → 1 piece Zugerichtetes Leder | 180 / 0 | station.workbench |
| `recipe.salt_hide` | Haut einsalzen | 1 piece Gesäuberte Haut, 1 kg Salz → 1 piece Gesalzene Haut | 30 / 0 | station.hand |
| `recipe.sew_waterskin` | Wasserschlauch nähen | 1 piece Zugerichtetes Leder, 2 m Pflanzenschnur, 0.1 kg Ausgelassenes Fett → 1 piece Wasserschlauch | 150 / 0 | station.hand |
| `recipe.soak_salted_hide` | Gesalzene Haut einweichen | 1 piece Gesalzene Haut, 10 l Unbehandeltes Wasser → 1 piece Gesäuberte Haut | 20 / 720 | station.vat |
| `recipe.tan_hide` | Haut pflanzlich gerben | 1 piece Gesäuberte Haut, 12 l Gerbbrühe → 1 piece Nasses gegerbtes Leder | 90 / 43200 | station.vat |
| `recipe.burn_charcoal` | Holzkohle brennen | 30 kg Scheitholz, 0.1 kg Trockener Zunder, 1 kg Anzündholz → 6 kg Holzkohle | 180 / 2880 | station.charcoal_clamp |
| `recipe.consolidate_iron` | Luppe ausschmieden | 3 kg Eisenluppe, 3 kg Holzkohle → 2 kg Ausgeschmiedetes Eisen | 180 / 0 | station.forge |
| `recipe.forge_axe_head` | Eisenaxtkopf schmieden | 1 kg Ausgeschmiedetes Eisen, 2 kg Holzkohle → 1 piece Eisenaxtkopf | 180 / 0 | station.forge |
| `recipe.forge_knife` | Eisenmesser schmieden | 0.3 kg Ausgeschmiedetes Eisen, 1 kg Holzkohle, 1 piece Werkzeugstiel → 1 piece Eisenmesser | 120 / 0 | station.forge |
| `recipe.forge_nails` | Nägel schmieden | 0.5 kg Ausgeschmiedetes Eisen, 1 kg Holzkohle → 20 piece Eisennägel | 60 / 0 | station.forge |
| `recipe.smelt_bloom` | Eisenluppe gewinnen | 10 kg Eisenerz, 15 kg Holzkohle → 3 kg Eisenluppe | 360 / 240 | station.bloomery |
| `recipe.dry_bricks` | Lehmziegel trocknen | 4 piece Feuchter Lehmziegel → 4 piece Luftgetrockneter Lehmziegel | 10 / 4320 | station.shelter |
| `recipe.dry_pot` | Topf trocknen | 1 piece Geformter feuchter Topf → 1 piece Getrockneter ungebrannter Topf | 5 / 2880 | station.shelter |
| `recipe.fire_bricks` | Ziegel brennen | 4 piece Luftgetrockneter Lehmziegel, 8 kg Scheitholz → 4 piece Gebrannter Ziegel | 60 / 480 | station.pottery_kiln |
| `recipe.fire_pot` | Topf brennen | 1 piece Getrockneter ungebrannter Topf, 6 kg Scheitholz → 1 piece Gebrannter Topf | 60 / 360 | station.pottery_kiln |
| `recipe.shape_bricks` | Lehmziegel formen | 5 kg Gemagerter Ton, 0.2 kg Stroh → 4 piece Feuchter Lehmziegel | 45 / 0 | station.hand |
| `recipe.shape_pot` | Topf formen | 2 kg Gemagerter Ton → 1 piece Geformter feuchter Topf | 60 / 0 | station.hand |
| `recipe.temper_clay` | Ton magern | 4 kg Ton, 1 kg Sand, 0.5 l Unbehandeltes Wasser → 5 kg Gemagerter Ton | 30 / 0 | station.hand |
| `recipe.grind_axe_head` | Steinaxtkopf formen und schleifen | 1 piece Feldstein, 0.5 l Unbehandeltes Wasser → 1 piece Geschliffener Steinaxtkopf | 240 / 0 | station.hand |
| `recipe.haft_iron_axe` | Eisenaxt schäften | 1 piece Eisenaxtkopf, 1 piece Werkzeugstiel, 1 piece Holzdübel → 1 piece Eisenaxt | 30 / 0 | station.hand |
| `recipe.haft_stone_axe` | Steinaxt schäften | 1 piece Geschliffener Steinaxtkopf, 1 piece Werkzeugstiel, 2 m Pflanzenschnur → 1 piece Steinaxt | 35 / 0 | station.hand |
| `recipe.knap_flake` | Steinabschläge schlagen | 0.4 kg Schlagbarer Feuerstein → 3 piece Steinabschlag | 30 / 0 | station.hand |
| `recipe.make_bone_awl` | Knochenahle herstellen | 0.1 kg Knochen → 1 piece Knochenahle | 35 / 0 | station.hand |
| `recipe.make_bone_needle` | Knochennadel herstellen | 0.05 kg Knochen → 1 piece Knochennadel | 60 / 0 | station.hand |
| `recipe.select_hammerstone` | Geeigneten Schlagstein auswählen | 1 piece Feldstein → 1 piece Schlagstein | 5 / 0 | station.hand |
| `recipe.carve_bowl` | Holzschale schnitzen | 1 piece Stammholz → 2 piece Holzschale | 180 / 0 | station.workbench |
| `recipe.carve_handle` | Werkzeugstiel schnitzen | 1 piece Ast → 1 piece Werkzeugstiel | 35 / 0 | station.hand |
| `recipe.carve_pegs` | Holzdübel schnitzen | 1 piece Ast → 8 piece Holzdübel | 30 / 0 | station.hand |
| `recipe.dry_tinder` | Rinde zu Zunder aufbereiten und trocknen | 0.2 kg Rinde → 0.1 kg Trockener Zunder | 10 / 720 | station.shelter |
| `recipe.saw_planks` | Bretter sägen | 1 piece Stammholz → 4 piece Brett | 120 / 0 | station.workbench |
| `recipe.shelter_kit` | Wetterschutz vorbereiten | 12 piece Ast, 6 m Pflanzenschnur, 3 kg Rinde → 1 piece Wetterschutz-Bausatz | 90 / 0 | station.hand |
| `recipe.split_firewood` | Brennholz spalten | 1 piece Stammholz → 12 kg Scheitholz | 45 / 0 | station.hand |
| `recipe.split_kindling` | Anzündholz spalten | 1 kg Scheitholz → 0.9 kg Anzündholz | 15 / 0 | station.hand |
