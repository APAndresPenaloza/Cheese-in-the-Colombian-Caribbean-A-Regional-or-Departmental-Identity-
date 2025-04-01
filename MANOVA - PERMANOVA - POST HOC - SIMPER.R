
# LIMPIAR ENTORNO Y DESCARGAR-CARGAR LIBRERÍAS
rm(list = ls())  
graphics.off()   
cat("\014")  

# Cargar las librerías necesarias
library(dplyr)
library(readxl)
library(MVN)
library(vegan)
library(car)  # Para la prueba de Box's M
library(remotes)
library(vegan)
library(multcomp)
library(biotools)
library(rstatix)
library(devtools)
library(openxlsx)

install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")

library(pairwiseAdonis)

# Cargar los datos desde un archivo Excel
datos <- read_excel("D:/GRUPO/Desktop/Coast Cheese/Downloads/ARTICULO 2/datos.xlsx", sheet = "GLM", range = "A1:M82")

# Convertir las variables categóricas en factores
datos <- datos %>%
  mutate(
    Departamento = as.factor(Departamento),
    Subregion = as.factor(Subregion),
  )

# Seleccionar variables continuas
variables <- c("Grasa", "Sal", "Proteina", "Solidos_Totales", "HSMG", "GES", "Carbohidratos_Totales", "Calorias")

# 1. Verificar normalidad multivariada usando Mahalanobis
hz_result_mahalanobis <- mvn(data = datos[, variables], mvnTest = "mardia")
print(hz_result_mahalanobis$multivariateNormality)
print(hz_result_mahalanobis$univariateNormality)

# 2. Verificar la homogeneidad de varianzas-covarianzas usando Box's M
box_m_result <- boxM(data = datos[, variables], group = datos$Departamento)
print(box_m_result)

# 3. Ejecutar MANOVA
manova_result <- manova(as.matrix(datos[, variables]) ~ Departamento * Subregion, data = datos)

# Mostrar resultados de las pruebas multivariadas
print("Wilks' Lambda:")
print(summary(manova_result, test = "Wilks"))

print("Pillai's Trace:")
print(summary(manova_result, test = "Pillai"))

print("Hotelling-Lawley Trace:")
print(summary(manova_result, test = "Hotelling-Lawley"))

print("Roy's Greatest Root:")
print(summary(manova_result, test = "Roy"))

# 4. Estandarizar los datos y ejecutar PERMANOVA con desglose de factores e interacciones

# Estandarizar los datos
datos_estandarizados <- scale(datos[, variables])

# 4.1. PERMANOVA para cada factor individualmente con Manhattan
permanova_departamento <- adonis2(datos_estandarizados ~ Departamento, 
                                  data = datos, 
                                  method = "manhattan")
print("PERMANOVA - Departamento")
print(permanova_departamento)

permanova_subregion <- adonis2(datos_estandarizados ~ Subregion, 
                               data = datos, 
                               method = "manhattan")
print("PERMANOVA - Subregion")
print(permanova_subregion)

# 5. Análisis POST-HOC con el paquete pairwiseAdonis

# Análisis post-hoc para el factor 'Departamento'
posthoc_departamento <- pairwise.adonis2(
  datos_estandarizados ~ Departamento, 
  data = datos, 
  method = "manhattan"
)
print(posthoc_departamento)


# 6. Análisis SIMPER para los grupos de 'Municipio' y 'Departamento'
# Función para extraer y convertir resultados SIMPER en un data.frame
extract_simper_df <- function(simper_result) {
  # Obtener los nombres de las comparaciones
  comparisons <- names(simper_result)
  
  # Crear una lista para almacenar los data.frames de cada comparación
  simper_list <- lapply(comparisons, function(comp) {
    result <- simper_result[[comp]]
    
    # Crear un data.frame con las variables y sus valores para cada comparación
    df <- data.frame(
      Comparison = comp,
      Species = result$species,
      Average = result$average,
      SD = result$sd,
      Ratio = result$ratio,
      Ava = result$ava,
      Avb = result$avb,
      Cusum = result$cusum,
      P = result$p,
      # Añadir columna de significancia con símbolos
      Significance = cut(result$p,
                         breaks = c(-Inf, 0.001, 0.01, 0.05, 0.1, Inf),
                         labels = c("***", "**", "*", ".", " "),
                         right = FALSE),
      row.names = NULL
    )
    return(df)
  })
  
  # Combinar todos los data.frames en uno solo
  combined_df <- do.call(rbind, simper_list)
  return(combined_df)
}

# Realizar el análisis SIMPER para Departamentos
simper_result_departamento <- simper(datos_estandarizados, group = datos$Departamento, method = "manhattan")

# Convertir los resultados de SIMPER para Departamentos a data.frame
simper_df_departamento <- extract_simper_df(simper_result_departamento)

# Exportar los resultados de SIMPER para Departamentos a un archivo CSV
write.csv(simper_df_departamento, file = "D:/GRUPO/Desktop/Coast Cheese/Downloads/ARTICULO 2/simper_results_departamento.csv", row.names = FALSE)

