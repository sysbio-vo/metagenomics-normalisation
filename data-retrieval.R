library("curatedMetagenomicData")
library("dplyr")

# ====== Retrieve metadata & counts  ======
crc_meta <- sampleMetadata[sampleMetadata$study_condition%in%c("CRC"),]
select(crc_meta, c(study_name, sequencing_platform))
crc_studies <- c('GuptaA_2019', 'ThomasAM_2018b')

# filter stusies and return TreeSummarizedExperiment
tse <- sampleMetadata |>
  #filter(disease == 'healthy') |>
  filter(study_name%in%crc_studies) |>
  filter(age_category == 'adult') |>
  filter(body_site == 'stool') |>
  #filter(pregnant != 'yes') |>
  #filter(lactating != 'yes') |>
  returnSamples("relative_abundance", rownames = "NCBI")

# obtain the data as dfs
counts <- as.data.frame(assays(tse)[[1]])
meta <- data.frame(colData(tse))

# ====== Balance the dataset ======
# ommitted the step to retrieve all the data for two studies
# Find the counts per study name
study_counts <- table(meta$study_name)

# Determine the minimum count of samples across all study names
## either select the minimum of study counts
#min_count <- min(study_counts)
## or a constant
#min_count <- 10

# Randomly sample that number of samples from each study name
#sampled_data <- lapply(names(study_counts), function(study) {
#  subset(meta, study_name == study)[sample(1:nrow(subset(meta, study_name == study)), min_count), ]
#})

# Combine sampled datasets into a single balanced dataset
#balanced_meta <- do.call(rbind, sampled_data)
#table(balanced_meta$study_name)

# filter the counts
#counts <- counts[, rownames(balanced_meta)]

# to check the number of unique values in each column
#sapply(meta, function(x) length(unique(x)))
write.csv(meta, "data/otutable_metadata.csv")
write.csv(counts, "data/otutable.csv")

# ====== Table 2: Studies ======
table2 <- meta %>% 
  group_by('Назва дослідження' = study_name) %>% 
  summarise('PMID' = first(PMID),
            'Платформа секвенування' = toString(unique(sequencing_platform)),
            'Набор для екстракції ДНК' = toString(unique(DNA_extraction_kit)),
            'Здорових зразків' = sum(disease == 'healthy'),
            'Ракових зразків' = sum(disease == 'CRC'))

write.csv(table2, "docs/table2.csv")