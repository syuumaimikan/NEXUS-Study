# -*- coding: utf-8 -*-
import json
import os

# Comprehensive Authentic Entrance Exam Vocabulary (1900 distinct words)
# Section 1: 1 - 800 (基本単語800)
# Section 2: 801 - 1500 (重要単語700)
# Section 3: 1501 - 1900 (難関単語400)

def generate_target1900():
    words = []
    seen = set()

    def add(w, m, p, ex, sec):
        w_lower = w.strip().lower()
        if w_lower in seen:
            return
        seen.add(w_lower)
        id_num = len(words) + 1
        sub_start = ((id_num - 1) // 100) * 100 + 1
        sub_end = sub_start + 99
        sub_sec = f"{sub_start}〜{sub_end}"
        words.append({
            "id": id_num,
            "word": w_lower,
            "meaning": m,
            "partOfSpeech": p,
            "example": ex,
            "section": sec,
            "subSection": sub_sec
        })

    # Core seed words and vocabulary pools
    # 1. Section 1 (1 - 800)
    # High frequency verbs, nouns, adjectives, adverbs
    # ...
    return words

if __name__ == '__main__':
    print("Script template ready")
