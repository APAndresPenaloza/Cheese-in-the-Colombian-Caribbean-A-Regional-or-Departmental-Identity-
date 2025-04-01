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

## Project Content

- **Data**: Contains the cheese samples with physicochemical variables such as moisture, fat, protein, salt, etc.
- **R Code**: Scripts for data preprocessing, statistical tests, and results visualization.
- **Results**: Interpretation of the analyses, including Principal Component Analysis (PCA) plots and clustering dendrograms.

## Requirements

This project requires **R** and several packages to execute the analyses. The main packages used in this project are:

- **vegan**: For PERMANOVA and SIMPER analysis.
- **MVN**: For multivariate normality tests.
- **ggplot2**: For data visualization.
- **factoextra**: For clustering and PCA analysis.
- **dplyr**: For data manipulation.
- **readxl**: For importing Excel files.
- **car**: For Box's M test.
- **multcomp**: For multiple comparisons.
- **biotools**: Biological analysis utilities.
- **rstatix**: Additional statistical functions.
- **devtools**: To install packages from GitHub.
- **openxlsx**: To read and write Excel files.

### Installing Required Packages in R

To install all the necessary packages, you can run the following code:

```r
install.packages(c("vegan", "MVN", "ggplot2", "factoextra", "dplyr", "readxl", "car", "multcomp", "biotools", "rstatix", "openxlsx"))
install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
```

## Data Import

Data should be stored in an Excel file (`datos.xlsx`) with a sheet named `GLM` containing the required physicochemical data for analysis.

```r
datos <- read_excel("C:/path/to/datos.xlsx", sheet = "GLM", range = "A1:M82")
```

## Analysis
Step 1: Mahalanobis Distance Test
The Mahalanobis test is performed to check for multivariate normality of the data.

```r
hz_result_mahalanobis <- mvn(data = datos[, variables], mvnTest = "mardia")
```

Step 2: Box's M Test
Box's M Test is applied to check the equality of covariance matrices.

```r
box_m_result <- boxM(data = datos[, variables], group = datos$Departamento)
```

Step 3: MANOVA
MANOVA is used to test for significant differences in cheese composition across the different departments and subregions.

```r
manova_result <- manova(as.matrix(datos[, variables]) ~ Departamento * Subregion, data = datos)
```

Step 4: PERMANOVA
The data is standardized and PERMANOVA is run for each factor to assess differences between groups using Manhattan distance.

```r
datos_estandarizados <- scale(datos[, variables])
permanova_departamento <- adonis2(datos_estandarizados ~ Departamento, data = datos, method = "manhattan")
```

Step 5: Post-hoc Analysis with Pairwise Adonis
Pairwise comparisons are done to further investigate differences between departments.

```r
posthoc_departamento <- pairwise.adonis2(datos_estandarizados ~ Departamento, data = datos, method = "manhattan")
```

Step 6: SIMPER Analysis
SIMPER analysis is performed to identify the variables contributing to the differences observed between departments.

```r
simper_result_departamento <- simper(datos_estandarizados, group = datos$Departamento, method = "manhattan")
```

## Results
The results of the statistical tests, including MANOVA, PERMANOVA, and SIMPER, will help determine if the cheeses from different departments are sufficiently homogeneous to justify the implementation of a shared designation of origin.

Results from the SIMPER analysis are saved in the following file:

```r
C:/path/to/simper_results_departamento.csv
```



