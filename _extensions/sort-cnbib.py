# Sort Chinese bibliography entries by Pinyin
# Be sure to remove the comment block ```{=comment}```

# Copyright: © 2024 Tom Ben
# License: MIT License

import panflute as pf
from pypinyin import pinyin, Style


def contains_chinese(text):
    return any('\u4e00' <= char <= '\u9fff' for char in text)


def special_pinyin(text):
    # 多音字的姓氏拼音
    surname_map = {
        '葛': 'ge3',
        '阚': 'kan4',
        '任': 'ren2',
        '单': 'shan4',
        '解': 'xie4',
        '燕': 'yan1',
        '尉': 'yu4',
        '乐': 'yue4',
        '曾': 'zeng1',
        '查': 'zha1',
    }

    if contains_chinese(text):
        name = text.split(",")[0] if "," in text else text
        surname = name[0]
        return surname_map.get(surname, "".join([i[0] for i in pinyin(name, style=Style.TONE3)]))
    else:
        return None


def prepare(doc):
    doc.chinese_entries = []
    doc.non_chinese_entries = []


def action(elem, doc):
    if isinstance(elem, pf.Div) and "references" in elem.classes:
        for e in elem.content:
            if isinstance(e, pf.Div) and "csl-entry" in e.classes:
                entry_text = pf.stringify(e)
                if contains_chinese(entry_text):
                    doc.chinese_entries.append(e)
                else:
                    doc.non_chinese_entries.append(e)
        elem.content = []


def finalize(doc):
    doc.chinese_entries.sort(key=lambda x: special_pinyin(pf.stringify(x)))

    # Replace the Div container content with sorted entries
    for elem in doc.content:
        if isinstance(elem, pf.Div) and "references" in elem.classes:
            # Sort the Chinese bibliography entries by Pinyin and append them to the end of the non-Chinese entries
            # Swap the entries below can change the order of Chinese and non-Chinese bibliography entries
            elem.content = doc.non_chinese_entries + doc.chinese_entries
            break


def main(doc=None):
    return pf.run_filter(action, prepare=prepare, finalize=finalize, doc=doc)


if __name__ == '__main__':
    main()
