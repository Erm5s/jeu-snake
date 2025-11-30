# 🐍 Snake Game — Assembleur MIPS32

## 📌 Description
Version du jeu **Snake** développée en **assembleur MIPS32**.  
Le joueur contrôle un serpent qui grandit à chaque bonbon mangé et doit éviter les murs, obstacles et collisions avec lui-même.  
Score final affiché à la fin de la partie.  

---

## 🛠 Technologies et environnement
- **Langage :** Assembleur MIPS32  
- **Émulateur :** MARS MIPS Simulator  
- **Concepts utilisés :** registres MIPS, pile, syscalls, boucles et conditions, sections `.data` et `.text`, frame buffer mémoire  

---

## ⚙️ Fonctionnalités principales
- Déplacement fluide du serpent (ZQSD)  
- Apparition aléatoire des bonbons et détection des collisions  
- Obstacles générés après chaque bonbon mangé  
- Gestion des directions : impossibilité de faire demi-tour  
- Détection des fins de partie et affichage du score  

---

## 🚀 Lancer le jeu
1. Ouvrir **MARS MIPS Simulator**  
2. Télécharger le fichier source (`snake.asm`)  
3. Ouvrir le fichier dans MARS  
4. Assembler le programme (**Assemble**)  
5. Lancer l’exécution (**Run**)  
