import json
import re
from pathlib import Path
from indic_transliteration import sanscript
from indic_transliteration.sanscript import transliterate

# Folder containing CountryData1.json ... CountryData6.json
DATA_FOLDER = Path("assets/data")

# Common Sant Mat fixes
WORD_FIXES = {
    "prema": "prem",
    "nama": "naam",
    "mana": "man",
    "radhasvami": "radhaswami",
    "svami": "swami",
    "sataguru": "satguru",
    "gurudeva": "gurudev",
    "gurujii": "guruji",
    "guruji": "guruji",
    "surata": "surat",
    "nirata": "nirat",
    "mayaa": "maya",
    "kaala": "kaal",
    "bhagati": "bhakti",
    "bhaktii": "bhakti",
    "aatmaa": "atma",
    "paramaatmaa": "paramatma",
    "kripaa": "kripa",
    "dayaala": "dayal",
    "satsaMga": "satsang",
    "sarana": "saran",
    "pyaare": "pyare",
    "liye": "liye",
    "lijiye": "lijiye",
    "mem": "mein",
    "mai": "main",
    "nahim": "nahi",
    "kaham": "kahan",
    "kahim": "kahin",
    "haim": "hain",
    "ham": "hum",
}

CHAR_FIXES = [
    ("RRi", "ri"),
    ("R^i", "ri"),
    ("~N", "n"),
    ("JN", "gy"),
    ("Ch", "chh"),
]


def clean(text: str) -> str:

    text = text.replace("|", " ")
    text = text.replace("\n", " ")
    text = text.replace("'", "")
    text = text.replace("^", "")
    text = text.replace(".", "")

    for a, b in CHAR_FIXES:
        text = text.replace(a, b)

    text = text.lower()

    # remove everything except letters and spaces
    text = re.sub(r"[^a-z ]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()

    words = []

    for word in text.split():

        if word in WORD_FIXES:
            words.append(WORD_FIXES[word])
            continue

        # remove ending 'a'
        if len(word) > 3 and word.endswith("a"):
            word = word[:-1]

        # common endings
        if word.endswith("am"):
            word = word[:-2] + "an"

        if word.endswith("ah"):
            word = word[:-2]

        # remove repeated letters
        word = re.sub(r"(.)\1+", r"\1", word)

        # final dictionary check
        word = WORD_FIXES.get(word, word)

        words.append(word)

    return " ".join(words)


files = sorted(DATA_FOLDER.glob("CountryData*.json"))

total = 0

for file in files:

    print(f"Processing {file.name}")

    with open(file, "r", encoding="utf-8") as f:
        data = json.load(f)

    for item in data:

        bani = item.get("bani", "")

        roman = transliterate(
            bani,
            sanscript.DEVANAGARI,
            sanscript.ITRANS,
        )

        item["roman"] = clean(roman)

        total += 1

    with open(file, "w", encoding="utf-8") as f:
        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2,
        )

print()
print("=" * 50)
print(f"Processed {len(files)} files")
print(f"Generated roman text for {total} banis")
print("DONE ✅")