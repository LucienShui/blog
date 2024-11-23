---
title: "Codeforces-1008A - Romaji - 水题"
date: 2018-07-14 00:55:00 +0800
last_modified_at: 2018-07-14 01:09:02 +0800
math: true
render_with_liquid: false
categories: ["ACM", "题解"]
tags: ["题解"]
---

### 题目链接

https://codeforces.com/contest/1008/problem/A

---
### 题目

Vitya has just started learning Berlanese language. It is known that Berlanese uses the Latin alphabet. Vowel letters are "a", "o", "u", "i", and "e". Other letters are consonant.

In Berlanese, there has to be a vowel after every consonant, but there can be any letter after any vowel. The only exception is a consonant "n"; after this letter, there can be any letter (not only a vowel) or there can be no letter at all. For example, the words "harakiri", "yupie", "man", and "nbo" are Berlanese while the words "horse", "king", "my", and "nz" are not.

Help Vitya find out if a word $s$ is Berlanese.

#### Input
The first line of the input contains the string $s$ consisting of $|s|$ ($1\leq |s|\leq 100$) lowercase Latin letters.

#### Output
Print "YES" (without quotes) if there is a vowel after every consonant except "n", otherwise print "NO".

You can print each letter in any case (upper or lower).

#### Input
```
sumimasen
```
#### Output
```
YES
```
#### Input
```
ninja
```
#### Output
```
YES
```
#### Input
```
codeforces
```
#### Output
```
NO
```
#### Note
In the first and second samples, a vowel goes after each consonant except "n", so the word is Berlanese.

In the third sample, the consonant "c" goes after the consonant "r", and the consonant "s" stands on the end, so the word is not Berlanese.

---
### 题意

&emsp;&emsp;问是否除了`n`以外的辅音字母后面都有一个元音字母。

---
### 实现

```cpp
## include <bits/stdc++.h>
char str[1007];
bool vis[1007];
int main() {
    std::cin >> str;
    vis['a'] = vis['e'] = vis['i'] = vis['o'] = vis['u'] = true;
    for (int i = 0; str[i]; i++) {
        if (!vis[str[i]] && str[i] != 'n') {
            if (!vis[str[i + 1]]) return 0 * puts("NO");
        }
    }
    puts("YES");
    return 0;
}
```