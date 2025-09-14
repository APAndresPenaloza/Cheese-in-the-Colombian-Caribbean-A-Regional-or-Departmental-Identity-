# Análisis Multivariado de Queso Costeño en la Región Caribe Colombiana

## Descripción del Proyecto

Este estudio analiza las características fisicoquímicas del queso costeño en la región Caribe de Colombia mediante técnicas de análisis multivariado. El objetivo principal es evaluar la estructura de los datos y las diferencias entre los grupos de muestras utilizando herramientas estadísticas avanzadas. Se aplican las siguientes pruebas:

- **Pruebas de normalidad multivariada**: Evaluación de la normalidad univariante y multivariante mediante los test de Anderson-Darling y Mardia. Los resultados indican que las variables no cumplen la normalidad multivariante, sugiriendo utilizar métodos no paramétricos o transformaciones de datos.
- **Prueba de homogeneidad de varianzas-covarianzas (Box's M)**: Verifica la igualdad de matrices de covarianza entre grupos. Los resultados muestran violaciones significativas de homocedasticidad.
- **Análisis multivariado de varianza (MANOVA)**: Evalúa diferencias multivariadas entre departamentos y subregiones, mostrando diferencias significativas entre departamentos y efectos de interacción menores entre subregiones.
- **Análisis de varianza permutacional (PERMANOVA)**: Evalúa la variabilidad de los datos entre grupos usando distancias Manhattan. Se detectan diferencias significativas entre departamentos, pero no entre subregiones.
- **Análisis Post-Hoc (pairwiseAdonis)**: Identifica diferencias específicas entre departamentos, confirmando que Magdalena vs Córdoba y Córdoba vs La Guajira presentan diferencias significativas, mientras que Magdalena vs La Guajira muestra diferencias marginales.
- **Análisis de similitud porcentual (SIMPER)**: Determina qué variables contribuyen a las diferencias entre grupos. Los resultados indican que las diferencias bromatológicas entre departamentos son mínimas, reflejando homogeneidad en los perfiles de queso costeño.

---

## Contenido del Proyecto

- **Datos**: Contiene las muestras de queso costeño con variables fisicoquímicas como grasa, proteína, sal, sólidos totales, MSNF, FDM, carbohidratos y calorías.
- **Código en R**: Scripts para el preprocesamiento de los datos, pruebas estadísticas y visualización de resultados.
- **Resultados**: Interpretación de los análisis realizados, que incluye:
  - Tablas y resultados de MANOVA, PERMANOVA, Post-Hoc y SIMPER.
  - Gráficos de análisis de coordenadas principales (PCoA).
  - Heatmap de parámetros fisicoquímicos estandarizados.

---

## Figuras

- **Figure 1**: Análisis de Coordenadas Principales (PCoA) utilizando distancias Manhattan. Muestra la dispersión de las muestras y el grado de solapamiento entre departamentos.
- **Figure 2**: Heatmap de parámetros fisicoquímicos estandarizados con clustering jerárquico por filas y columnas, ilustrando la relativa homogeneidad de los perfiles entre departamentos.

---

## Requisitos

Este proyecto requiere **R** y varios paquetes para ejecutar los análisis. Los principales paquetes utilizados son:

- **vegan**: Análisis PERMANOVA, SIMPER y distancias  
- **psych**: Pruebas de normalidad multivariante (Mardia)  
- **car**: Prueba de Box's M  
- **pairwiseAdonis**: Comparaciones Post-Hoc  
- **ggplot2**: Visualización de PCoA  
- **pheatmap**: Generación de heatmaps  
- **dplyr**: Manipulación de datos  
- **readxl**: Importación de archivos Excel  
- **multcomp**: Comparaciones múltiples  
- **rstatix**: Funciones estadísticas adicionales  
- **openxlsx**: Leer y escribir archivos Excel  
- **devtools** y **remotes**: Para instalar paquetes desde GitHub  

---

### Instalación de paquetes en R

Para instalar todos los paquetes necesarios, puedes ejecutar el siguiente código:

```r
install.packages(c("vegan", "psych", "ggplot2", "dplyr", "readxl", "car", 
                   "multcomp", "rstatix", "openxlsx", "pheatmap"))

remotes::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
