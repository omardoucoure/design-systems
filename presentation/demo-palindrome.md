# Demo Live — Palindrome
# "Meme modele, cinq niveaux d'exigence"

---

## 1. JUNIOR

```
verifie si une chaine est un palindrome en swift
```

---

## 2. INTERMEDIAIRE

```
Ecris une fonction Swift qui verifie si une chaine est un palindrome.
Elle doit ignorer la casse, les espaces et la ponctuation,
et gerer les cas limites (chaine vide, un seul caractere).
Utilise un algorithme efficace.
```

---

## 3. EXPERT

```
Ecris une fonction Swift qui verifie si une chaine est un palindrome.

Exigences :
- O(n) en temps, O(1) en memoire supplementaire (aucune copie de la chaine)
- Insensible a la casse via Unicode scalar folding
- Ignorer les scalaires Unicode non alphanumeriques
- Gerer les caracteres combines et les clusters de graphemes etendus
- Travailler directement sur String.UnicodeScalarView pour eviter les lookups d'index en O(n)
- Zero allocation : iterer des deux extremites en une seule passe
- Retour anticipe des le premier mismatch
```

---

## 4. DEVELOPPEUR IA

```
/algorithm Etant donne une chaine s, retourne vrai si c'est un palindrome, faux sinon.
```
