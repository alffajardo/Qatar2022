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




# ---------------------------------------------------------------------------------------------!
#   Fase eliminatoria

echo "# **Fase Eliminatoria**

" > 02.tmp_Eliminatoria.md

# --------------------------------------------------------
# ------------- FINAL------------------------------

Rscript generate_picks_KOFinal.R
echo "
 # <u>**Picks de la GRAN FINAL**</u>

![](flags/matches/Match64.png)
 
 " >> 02.tmp_Eliminatoria.md
 
 echo "
 ![](media/final.gif)

" >> 02.tmp_Eliminatoria.md

./gen_markdown_table.sh --csv < KOFinal_picks.csv >> 02.tmp_Eliminatoria.md

echo "

![](media/picks_KOFinal.png)" >> 02.tmp_Eliminatoria.md

echo "
 ## <u>**Predicción de Marcadores**</u>

 " >> 02.tmp_Eliminatoria.md
./gen_markdown_table.sh --csv < KOFinal_predicted_scores.csv >> 02.tmp_Eliminatoria.md
echo "
![](media/predicted_scores_KOFinal.png)

- - - " >> 02.tmp_Eliminatoria.md

# --------------------------------------------------------
# ------------- SEMIFINALES ------------------------------

echo "
 ## <u>**Picks de las Semifinales**</u>

 ![](flags/matches/semifinals.png)
 
 " >> 02.tmp_Eliminatoria.md

./gen_markdown_table.sh --csv < KO2_picks.csv >> 02.tmp_Eliminatoria.md

echo "
![](media/picks_KO2.png)

" >> 02.tmp_Eliminatoria.md

echo "
 ## <u>**Predicción de Marcadores**</u>

 " >> 02.tmp_Eliminatoria.md
./gen_markdown_table.sh --csv < KO2_predicted_scores.csv >> 02.tmp_Eliminatoria.md
echo "
![](media/predicted_scores_KO2.png)

- - - " >> 02.tmp_Eliminatoria.md

# -------------------------------------------------------------------------------

# --------------------------------------------------------
# ------------- Fase de cuartos --------------------------

# -------------------------------------------------------------------------------

Rscript generate_picks_kO4.R


echo "
 ## <u>**Picks de la fase de cuartos**</u>

 ![](flags/matches/quarters.png)
 
 " >> 02.tmp_Eliminatoria.md

./gen_markdown_table.sh --csv < KO4_picks.csv >> 02.tmp_Eliminatoria.md

echo "
![](media/picks_KO4.png)

" >> 02.tmp_Eliminatoria.md

echo "
 ## <u>**Predicción de Marcadores**</u>
 
 " >> 02.tmp_Eliminatoria.md

./gen_markdown_table.sh --csv < KO4_predicted_scores.csv >> 02.tmp_Eliminatoria.md

echo "
![](media/predicted_scores_KO4.png)

- - - " >> 02.tmp_Eliminatoria.md





# ------------------------------------------------------
#  ----------Fase de octavos
#------------------------------------------------------
Rscript generate_picks_kO8.R


echo "
 ## <u>**Picks de la fase de octavos**</u>

 ![](flags/matches/octaves.gif)
 
 " >> 02.tmp_Eliminatoria.md
./gen_markdown_table.sh --csv < KO8_picks.csv >> 02.tmp_Eliminatoria.md

echo "
![](media/picks_K08.png)

" >> 02.tmp_Eliminatoria.md

echo "
 ## <u>**Predicción de Marcadores**</u>
 
 " >> 02.tmp_Eliminatoria.md

./gen_markdown_table.sh --csv < KO8_predicted_scores.csv >> 02.tmp_Eliminatoria.md

echo "
![](media/predicted_scores_K08.png)

- - - " >> 02.tmp_Eliminatoria.md


##------------------------------------------------------------------------------------------------|
### FASE DE GRUPOS
# -----------------------------------------------------------------------------------------------|
echo "# **Fase de Grupos**

![](flags/matches/matches.gif)

---

" > 01.tmp_Grupos.md




## ---------------------------------------------------------------------------------------------|
# PICKS DE LA JORNADA 3

echo "
 ## <u>**Picks de la Jornada 3**</u>
 
 " >> 01.tmp_Grupos.md

Rscript generate_picks_GS3.R

./gen_markdown_table.sh --csv < GS3_picks.csv >> 01.tmp_Grupos.md

echo "### Gráficos

![](media/picks_GS3.png )

### Similitud de las picks
<img src="media/similarities_GS3.png" alt="similarities" width="600"/>

---
### **Jugadores notables en esta ronda**

Este es el top 5 de jugadores que más cambiarán su posición en la tabla tras concluir la ronda: 

" >> 01.tmp_Grupos.md
./gen_markdown_table.sh --csv < top_GS3.csv >> 01.tmp_Grupos.md

echo " --- " >> 01.tmp_Grupos.md






# ----------------------------------------------------------------------------------------------|
## ---------------------------------------------------------------------------------------------|
# PICKS DE LA JORNADA 2
# -----------------------------------------------------------------------------------------------|

echo "
 ## <u>**Picks de la Jornada 2**</u>
 
 " >> 01.tmp_Grupos.md

Rscript generate_picks_GS2.R

./gen_markdown_table.sh --csv < GS2_picks.csv >> 01.tmp_Grupos.md


# | ------------------------------------------------------------------------------------------- | 
# PICKS DE LA JORNADA 1

 echo "
 ## <u>**Picks de la Jornada 1**</u>
 
 " >> 01.tmp_Grupos.md

Rscript generate_picks_GS1.R

./gen_markdown_table.sh --csv < GS1_picks.csv >> 01.tmp_Grupos.md

echo "### Gráficos

![](media/picks_GS1.png )

### Similitud de las picks
<img src="media/similarities_GS1.png" alt="similarities" width="600"/>

---
### **Jugadores notables en esta ronda**

Este es el top 5 de jugadores que más cambiarán su posición en la tabla tras concluir la ronda: 

" >> 01.tmp_Grupos.md
./gen_markdown_table.sh --csv < top_GS1.csv >> 01.tmp_Grupos.md

echo " --- " >> 01.tmp_Grupos.md

# ----------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#  ------------------------- RESULTADOS --------------------------------------------------------------------------------


Rscript score_picks.R

echo "# **Puntuaciones**

" > 02.tmp_Resultados.md

echo "### **Tabla General**

" >> 02.tmp_Resultados.md


./gen_markdown_table.sh --csv < Overall_scores.csv >> 02.tmp_Resultados.md


echo "---

# **Puntuaciones por Jornada**

[Resultados de la Jornada 1](GS1_complete_scores.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la Jornada 2](GS2_complete_scores.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la Jornada 3](GS3_complete_scores.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la fase de Octavos](KO8_complete_scores.csv)

[Marcadores de la fase de Octavos](KO8_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la fase de Cuartos](KO4_complete_scores.csv)

[Marcadores de la fase de  Cuartos](KO4_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de las Semifinales](KO2_complete_scores.csv)

[Marcadores de las Seminales ](KO2_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md

echo " 

[Resultados de la Final](KOFinal_complete_scores.csv)

[Marcadores de Final ](KOFinal_complete_bonus.csv)
 
--- "  >> 02.tmp_Resultados.md
#### --------------------------------------------------------------------------------------------------------
## ELIMININATORIAS

# ----------------------------------------------------------------------------------------------------- |
# .-----------------------------------------------------------------------------------------------------|
# Gather all the files into the read me

cat 00.tmp_header.md  02.tmp_Resultados.md 02.tmp_Eliminatoria.md 01.tmp_Grupos.md > README.md


 rm *tmp*md

# push to remote

git add .
git add "update_readme.sh"
git commit -m "automatic README update"
git push

exit
