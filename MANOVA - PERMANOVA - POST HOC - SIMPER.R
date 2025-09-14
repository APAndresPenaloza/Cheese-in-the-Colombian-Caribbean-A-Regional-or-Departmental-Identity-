
# ===============================
# LIMPIAR ENTORNO Y CARGAR LIBRERÍAS
# ===============================
rm(list = ls())
graphics.off()
cat("\014")

# Librerías básicas
library(dplyr)
library(readxl)
library(vegan)       # PERMANOVA, distancias, SIMPER
library(car)         # Box's M
library(multcomp)    # Comparaciones múltiples
library(psych)       # Mardia test
library(pheatmap)
library(ggplot2)
library(pairwiseAdonis)


# Para pairwiseAdonis: instalar desde GitHub si no está
#
#if(!require(pairwiseAdonis)) {
#  if(!require(remotes)) install.packages("remotes")
#  remotes::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
#  library(pairwiseAdonis)
#}

# ===============================
# CARGAR DATOS
# ===============================
datos <- read_excel(
  "D:/GRUPO/Desktop/Coast Cheese/Downloads/ARTICULO 2/datos.xlsx", 
  sheet = "GLM", 
  range = "A1:M82"
)

# Convertir variables categóricas
datos <- datos %>%
  mutate(
    Departamento = as.factor(Departamento),
    Subregion = as.factor(Subregion)
  )

# Variables continuas
variables <- c("Grasa", "Sal", "Proteina", "Solidos_Totales", 
               "HSMG", "GES", "Carbohidratos_Totales", "Calorias")

# ===============================
# 1. Normalidad multivariante con Mardia
# ===============================
mardia_result <- psych::mardia(datos[, variables])

cat("Skewness:", mardia_result$skew, "\n")
cat("Kurtosis:", mardia_result$kurtosis, "\n")
cat("p-value skewness:", mardia_result$p.skew, "\n")
# Nota: psych::mardia() no calcula p-value para kurtosis

# ===============================
# 2. Homogeneidad de varianzas-covarianzas (Box's M)
# ===============================
box_m_result <- boxM(datos[, variables], group = datos$Departamento)
print(box_m_result)

# ===============================
# 3. MANOVA
# ===============================
manova_result <- manova(as.matrix(datos[, variables]) ~ Departamento * Subregion, data = datos)

cat("Wilks' Lambda:\n")
print(summary(manova_result, test = "Wilks"))

cat("Pillai's Trace:\n")
print(summary(manova_result, test = "Pillai"))

cat("Hotelling-Lawley Trace:\n")
print(summary(manova_result, test = "Hotelling-Lawley"))

cat("Roy's Greatest Root:\n")
print(summary(manova_result, test = "Roy"))

# ===============================
# 4. PERMANOVA con Manhattan
# ===============================
datos_est <- scale(datos[, variables])  # estandarizar

# PERMANOVA
permanova_dep <- adonis2(datos_est ~ Departamento, data = datos, method = "manhattan")
cat("PERMANOVA - Departamento\n")
print(permanova_dep)

permanova_sub <- adonis2(datos_est ~ Subregion, data = datos, method = "manhattan")
cat("PERMANOVA - Subregion\n")
print(permanova_sub)

# ===============================
# 5. Post-hoc PERMANOVA con pairwiseAdonis
# ===============================
posthoc_dep <- pairwise.adonis2(datos_est ~ Departamento, data = datos, method = "manhattan")
print(posthoc_dep)

# ===============================
# 6. SIMPER
# ===============================
simper_result_dep <- simper(datos_est, group = datos$Departamento, method = "manhattan")

extract_simper_df <- function(simper_result){
  comparisons <- names(simper_result)
  df_list <- lapply(comparisons, function(comp){
    res <- simper_result[[comp]]
    df <- data.frame(
      Comparison = comp,
      Species = res$species,
      Average = res$average,
      SD = res$sd,
      Ratio = res$ratio,
      Ava = res$ava,
      Avb = res$avb,
      Cusum = res$cusum,
      P = res$p,
      Significance = cut(res$p, breaks = c(-Inf, 0.001, 0.01, 0.05, 0.1, Inf),
                         labels = c("***","**","*","."," "))
    )
    return(df)
  })
  do.call(rbind, df_list)
}

simper_df_dep <- extract_simper_df(simper_result_dep)
write.csv(simper_df_dep, 
          "D:/GRUPO/Desktop/Coast Cheese/Downloads/ARTICULO 2/simper_results_departamento.csv",
          row.names = FALSE)

# ===============================
# 7. PCoA y gráfico
# ===============================
colnames(datos)[colnames(datos) %in% c("Grasa","Sal","Proteina","Solidos_Totales","HSMG","GES","Carbohidratos_Totales","Calorias")] <- 
  c("Fat","Salt","Protein","Total_Solids","MSNF","FDM","Total_Carbohydrates","Calories")

dist_manhattan <- vegdist(scale(datos[, c("Fat","Salt","Protein","Total_Solids","MSNF","FDM","Total_Carbohydrates","Calories")]), method = "manhattan")
pcoa_result <- cmdscale(dist_manhattan, eig = TRUE, k = 2)

pcoa_df <- data.frame(
  Dim1 = pcoa_result$points[,1],
  Dim2 = pcoa_result$points[,2],
  Department = datos$Departamento
)

ggplot(pcoa_df, aes(x = Dim1, y = Dim2, color = Department)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "PCoA - PERMANOVA (Manhattan)", x = "Axis 1", y = "Axis 2", color = "Department")

# ===============================
# 8. Heatmap
# ===============================
matriz_heat <- as.matrix(scale(datos[, c("Fat","Salt","Protein","Total_Solids","MSNF","FDM","Total_Carbohydrates","Calories")]))
rownames(matriz_heat) <- paste0(datos$Departamento, "_", seq_len(nrow(datos)))

annotation_df <- data.frame(Department = datos$Departamento)
rownames(annotation_df) <- rownames(matriz_heat)

pheatmap(
  matriz_heat,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  annotation_row = annotation_df,
  main = "Heatmap of Physicochemical Parameters",
  fontsize = 10
)
