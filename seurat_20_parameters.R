# Load required library
library(dplyr)

# Read data 
df <- read.csv("/Users/princegolakiya/Downloads/Parameters - Sheet1.csv", header = TRUE, stringsAsFactors = FALSE)  # If using Excel, use readxl::read_excel("your_data.xlsx")

# Ensure silhouette_score is numeric
df$silhouette_score <- as.numeric(df$silhouette_score)

colnames(df)
# Sort dataset by silhouette score (descending)
df_sorted <- df %>% arrange(desc(silhouette_score))

# Remove the top 10 parameters
df_remaining <- df_sorted[-c(1:10), ]

# Select next top 10 parameters
top_10 <- df_remaining %>% slice(1:10)

# Find the median silhouette score
median_score <- median(df_remaining$silhouette_score, na.rm = TRUE)

# Select 5 parameters closest to the median score
moderate_5 <- df_remaining %>%
  mutate(abs_diff = abs(silhouette_score - median_score)) %>%
  arrange(abs_diff) %>%  # Sort by closeness to median
  slice(1:5) %>%
  select(-abs_diff)  # Remove temporary column

# Select 5 lowest parameters
bottom_5 <- df_remaining %>% slice_tail(n = 5)

# Combine all selected parameters
selected_20 <- bind_rows(top_10, moderate_5, bottom_5)

print(selected_20)



#############################################################
#############################################################

# Select 20 additional parameters using tier-based selection
top_tier <- df_remaining %>% slice(1:7)   # Best scores
mid_tier <- df_remaining %>% slice(8:14)  # Medium scores
low_tier <- df_remaining %>% slice(15:20) # Lower scores

# Combine all selected
selected_20 <- bind_rows(top_tier, mid_tier, low_tier)

# Display the selected parameters
print(selected_20)

# Save selection for reference
write.csv(selected_20, "selected_20_seurat_params.csv", row.names = FALSE)


colnames(df)

