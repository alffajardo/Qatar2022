#!/bin/bash

# hacer git pull
git pull
# Script para generar mas rapido el Readme.md

# Titulo

echo "# Quiniela Qatar 2022
<p align="center">

<img src="media/fifa.jpg" alt="Fifa2022" width="1000"/>

---
## Bienvenidos


Este es el repositorio de la quiniela Qatar 2022. Aqui se publicarán las picks y los resultados de la quiniela.

---


" > 00.tmp_header.md

### FASE DE GRUPOS
echo "# **Fase de Grupos**

![](flags/matches/matches.gif)

---

" > 01.tmp_Grupos.md

# Jornada 1

 echo "
 ## <u>**Picks de la Jornada 1**</u>
 
 " >> 01.tmp_Grupos.md

./generate_picks_GS1.R

./gen_markdown_table.sh --csv < GS1_picks.csv >> 01.tmp_Grupos.md

echo "### Gráficos

![](media/01.picks_stage1.png )

### Similitud de las picks
<img src="media/similarities" alt="similaties" width="500"/>

---
### **Jugadores notables en esta ronda**

Este es el top 5 de jugadores que cambiaran su posición en la tabla tras concluir la ronda: 

" >> 01.tmp_Grupos.md
./gen_markdown_table.sh --csv < top_GS1.csv >> 01.tmp_Grupos.md

echo " --- " >> 1.tmp_Grupos.md

# jugadores con mayor positibilidad de cambios


# Gather all the files into the read me

cat 00.tmp_header.md 01.tmp_Grupos.md > README.md


rm *tmp*md

# push to remote

git add "*.md"
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit