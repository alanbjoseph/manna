import requests
from bs4 import BeautifulSoup
import json
import os
from tqdm import tqdm

# Base URL for topical verses
BASE_URL = "https://www.openbible.info/topics/"

# Read topics from topics.txt
with open("topics_list.txt", "r", encoding="utf-8") as f:
    topics = [line.strip() for line in f if line.strip()]

# Output file
json_file = "verses_dataset.json"

# Load existing verses if file exists and is not empty
if os.path.exists(json_file) and os.path.getsize(json_file) > 0:
    with open(json_file, "r", encoding="utf-8") as f:
        all_verses = json.load(f)
else:
    all_verses = []

# Use dict for deduplication (key = (reference, text))
verse_dict = {(v["reference"], v["text"]): v for v in all_verses}

# Stats counters
duplicate_count = 0
success_urls = 0
failed_topics = []

# Crawl topics with a single progress bar
for topic in tqdm(topics, desc="Crawling topics", unit="topic"):
    url = BASE_URL + topic
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
    except Exception:
        failed_topics.append(topic)
        continue

    soup = BeautifulSoup(response.text, "html.parser")
    verses_on_page = soup.find_all("div", class_="verse")

    if verses_on_page:
        success_urls += 1

    for div in verses_on_page:
        ref = div.find("a", class_="bibleref").get_text(strip=True)
        text = div.find("p").get_text(strip=True)
        key = (ref, text)

        if key in verse_dict:
            duplicate_count += 1
            verse_dict[key].setdefault("tags", [])
            if topic not in verse_dict[key]["tags"]:
                verse_dict[key]["tags"].append(topic)
        else:
            verse_dict[key] = {
                "reference": ref,
                "text": text,
                "tags": [topic]
            }

# Convert dict back to list
all_verses = list(verse_dict.values())

# Save final JSON
with open(json_file, "w", encoding="utf-8") as f:
    json.dump(all_verses, f, ensure_ascii=False, indent=2)

# Final stats report
print("\n=== Crawl Summary ===")
print(f"* Total verses saved: {len(all_verses)}")
print(f"* Duplicate verses skipped: {duplicate_count}")
print(f"* Successfully crawled: {success_urls} URLs")
print(f"* Failed to crawl: {len(failed_topics)} URLs")

if failed_topics:
    print("   Failed topics:", ", ".join(failed_topics))
