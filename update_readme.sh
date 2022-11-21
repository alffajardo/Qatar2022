#!/bin/bash

# hacer git pull
git pull
# Script para generar mas rapido el Readme.md

# -------------------------Header -----------------------------------------------------------------|
# -------------------------------------------------------------------------------------------------|


echo "# **Quiniela Qatar 2022**
<p align="center">

<img src="media/fifa.jpg" alt="Fifa2022" width="1000"/>

---
## Bienvenidos


Este es el repositorio de la quiniela Qatar 2022. Aqui se publicarán las picks y los resultados de la quiniela.

---


" > 00.tmp_header.md

echo -e "Última actualización: $(date).

" >> 00.tmp_header.md 
### FASE DE GRUPOS
echo "# **Fase de Grupos**

![](flags/matches/matches.gif)

---

" > 01.tmp_Grupos.md

# | ------------------------------------------------------------------------------------------- | 
# PICKS DE LA JORNADA 1

 echo "
 ## <u>**Picks de la Jornada 1**</u>
 
 " >> 01.tmp_Grupos.md

./generate_picks_GS1.R

./gen_markdown_table.sh --csv < GS1_picks.csv >> 01.tmp_Grupos.md

echo "### Gráficos

![](media/01.picks_stage1.png )

### Similitud de las picks
<img src="media/similarities_S1.png" alt="similarities" width="600"/>

---
### **Jugadores notables en esta ronda**

Este es el top 5 de jugadores que más cambiarán su posición en la tabla tras concluir la ronda: 

" >> 01.tmp_Grupos.md
./gen_markdown_table.sh --csv < top_GS1.csv >> 01.tmp_Grupos.md

echo " --- " >> 01.tmp_Grupos.md

# ----------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#  ------------------------- RESULTADOS --------------------------------------------------------------------------------


./score_picks.R

echo "# **Puntuaciones**

" > 02.tmp_Resultados.md

echo "### **Tabla General**

" >> 02.tmp_Resultados.md


./gen_markdown_table.sh --csv < Overall_scores.csv >> 02.tmp_Resultados.md
echo "[Resultados de la Jornada 1](GS1_complete_scores.csv)

--- "  >> 02.tmp_Resultados




# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|
# Gather all the files into the read me

cat 00.tmp_header.md  02.tmp_Resultados.md 01.tmp_Grupos.md > README.md


 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
