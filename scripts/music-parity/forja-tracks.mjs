// La Forja del Alba: its tracks declared as profile + instrument, for the parity adapters.
export const FORJA_TRACKS = {
  "FL SOLO": { profile: "swam/flute-3" }, "OB SOLO": { profile: "swam/oboe-3" }, "EH SOLO": { profile: "swam/english-horn-3" },
  "CL SOLO": { profile: "swam/clarinet-3" }, "BSN SOLO": { profile: "swam/bassoon-3" }, "HN SOLO": { profile: "swam/french-horn-f" },
  "VLN SOLO": { profile: "swam/violin-3" }, "VC SOLO": { profile: "swam/cello-3" },
  "WW LEGATO": { profile: "albion-one/woods-high-legato" }, "WW SHORT": { profile: "albion-one/woods-high-short" },
  "HN LEGATO": { profile: "albion-one/brass-mid-legato" }, "TPT LONG": { profile: "albion-one/trumpets-xl-long" },
  "TPT SHORT": { profile: "albion-one/trumpets-xl-short" }, "LOW BRASS": { profile: "albion-one/brass-low-long" },
  "LOW BRASS SHORT": { profile: "albion-one/brass-low-short-nasty" },
  "TIMP": { profile: "symphony-series/timpani" }, "CYMBALS": { profile: "symphony-series/cymbal-1" },
  "PERC": { profile: "albion-one/darwin-percussion" }, "PIANO": { profile: "arturia/piano-v3" },
  "STR LEGATO": { profile: "albion-one/strings-high-octave-legato" }, "STR LONG": { profile: "albion-one/strings-long" },
  "STR TREM": { profile: "albion-one/strings-long-tremolo" }, "STR SPICC": { profile: "albion-one/strings-short-spiccato" },
  "STR STAC": { profile: "albion-one/strings-short-staccato-combo" }, "STR PIZZ": { profile: "albion-one/strings-short-pizzicato" },
  "LO STR LONG": { profile: "albion-one/strings-low-8ves-long" }, "LO STR SHORT": { profile: "albion-one/strings-low-8ves-short" }
};
// sections that breathe together, in order (La Forja's SHARED)
export const FORJA_BREATH_GROUPS = { melody: ["STR LEGATO", "WW LEGATO", "HN LEGATO", "TPT LONG"] };
