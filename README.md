# "Analysis of Costeño Cheese Homogeneity in the Colombian Caribbean Region"
## author:
## - Andres Mauricio Penaloza Fernandez
## - Edwin Causado Rodriguez
## - Felix de Jesus Cuello

## Description

This project aims to evaluate the homogeneity of Costeño cheese produced in the departments of Magdalena, Córdoba, and La Guajira, in the context of a potential Denomination of Origin (DO) implementation for these regions. A total of 54 cheese samples were analyzed, coming from 27 municipalities. We measured physicochemical parameters including fat, moisture, salt, protein, total solids, HSMG, GES, total carbohydrates, and calories.

The statistical analysis includes **MANOVA** to test for significant differences in the cheese composition across departments and **SIMPER** to identify which variables contribute to the observed differences. The results suggest that, despite some regional variations, the cheeses share enough similarities to justify a shared Denomination of Origin across the three departments.

## Required Packages
- **Pruebas de normalidad multivariada**: Para verificar si las variables siguen distribuciones normales.
- **Análisis de varianza permutacional (PERMANOVA)**: Para evaluar la variabilidad de los datos entre diferentes grupos.
- **Análisis de similitud porcentual (SIMPER)**: Para identificar qué variables contribuyen significativamente a las diferencias entre grupos.

## Contenido del Proyecto

- **Datos**: Contiene las muestras de queso costeño con variables fisicoquímicas como humedad, grasa, proteína, sal, entre otras.
- **Código en R**: Scripts para el preprocesamiento de los datos, pruebas estadísticas, y visualización de los resultados.
- **Resultados**: Interpretación de los análisis realizados, que incluye gráficos de análisis de componentes principales (PCA) y dendrogramas de agrupamiento.

## Requisitos

Este proyecto requiere **R** y varios paquetes para ejecutar los análisis. Los principales paquetes utilizados en este proyecto son:

- **vegan**: Para realizar el análisis de PERMANOVA y SIMPER.
- **MVN**: Para pruebas de normalidad multivariada.
- **ggplot2**: Para visualización de los resultados.
- **factoextra**: Para realizar análisis de clustering y PCA.
- **dplyr**: Para manipulación de datos.
- **readxl**: Para importar archivos Excel.
- **car**: Para la prueba de Box's M.
- **multcomp**: Para comparaciones múltiples.
- **biotools**: Utilidades para análisis biológicos.
- **rstatix**: Funciones estadísticas adicionales.
- **devtools**: Para instalar paquetes desde GitHub.
- **openxlsx**: Para leer y escribir archivos Excel.

### Instalación de paquetes en R

Para instalar todos los paquetes necesarios, puedes ejecutar el siguiente código:

```r
install.packages(c("vegan", "MVN", "ggplot2", "factoextra", "dplyr", "readxl", "car", "multcomp", "biotools", "rstatix", "openxlsx"))
install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")


