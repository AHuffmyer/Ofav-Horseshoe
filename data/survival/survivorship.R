library("tidyverse"); library("janitor"); library("readxl")

path <- "data/scoring_data.xlsx"
data <- path %>%
  excel_sheets() %>%
  set_names() %>% 
  map_df(~ read_excel(path = path, sheet = .x)%>%mutate(across(.fns = as.character)))
# can create df versions for 'resurrection' and 'lemon' analysis from "data" when/if desired

# remove rows (larvae) with specific ambiguous phenotype (lemons), allocation errors (miss), and pipet/handling process death (died_dried) to make clean ready to analyze survivorship dataset
good <-data %>% filter (miss=="0",lemon=="0", died_dried=="0") %>% 
  select(-miss, -resurrection, -lemon, -died_dried)%>%
  select(-score_0,-row,-column) %>% #initial allocation, not actual assessment
  filter(score_1!=0)%>%
  pivot_longer(cols=-c("plate","well"),names_to ="session", values_to ="score")%>%
  mutate(plate=as.factor(plate)) 

write_rds(good, "output/survivorship")
