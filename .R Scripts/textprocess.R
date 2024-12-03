library(rvest)
library(tidyverse)
library(tidytext)

# Article Scraper

scrape_page <- function(url) {
  page <- read_html(url)
  
  links <- page %>%
    html_nodes("a.Link") %>%
    html_attr("href")
  
  links <- ifelse(grepl("^https://", links), links, paste0("https://apnews.com", links))
  
  return(links)
}

scrape_article <- function(link) {
  page <- read_html(link)
  
  title <- page %>%
    html_node(".Page-headline") %>%  
    html_text(trim = TRUE)
  
  content <- page %>%
    html_nodes("p") %>%  
    html_text(trim = TRUE) %>%
    paste(collapse = " ")  
  
  return(tibble(Title = title, Content = content, Link = link))
}

base_url <- "https://apnews.com/search?q=%22Community%20Eligibility%20Provision%22%20OR%20%22school%20lunch%20programs%22%20&s=0&p="
all_links <- c()

for (i in 1:5) {
  page_url <- paste0(base_url, i)
  message("Scraping page: ", i)
  
  links <- scrape_page(page_url)
  all_links <- c(all_links, links)
}

all_links <- unique(all_links)

articles <- tibble()
for (link in all_links) {
  message("Scraping article: ", link)
  
  article <- tryCatch(scrape_article(link), error = function(e) NULL)
  
  if (!is.null(article)) {
    articles <- bind_rows(articles, article)
  }
}

write_csv(articles, "Articles/AP_News_Articles.csv")

# Sentiment Analysis


# Data Cleaning

articles <- articles %>% 
  mutate(
    Content = str_replace_all(Content,
                              "Copyright 2024 The Associated Press. All Rights Reserved.", "")
  )

articles <- articles %>% 
  mutate(
    Content = str_replace_all(Content,
                              "\\bAP\\b", "")
  )

articles <- articles %>% 
  mutate(
    Content = str_replace_all(Content,
                              "Photo", "")
  )

articles <- articles %>% 
  mutate(
    Content = str_replace_all(Content,
                              "FILE", "")
  )

tidy_article <- articles %>% 
  unnest_tokens(word, Content) %>% 
  anti_join(stop_words, by = "word") %>% 
  filter(!str_detect(word, "^\\d+$"))

# Word Frequency Analysis

word_freq <- tidy_article %>%
  count(word, sort = TRUE)

text_plot1 <- word_freq %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(reorder(word, n), n)) +
  geom_bar(stat = "identity", fill = "blue") +
  coord_flip() +
  labs(title = "Most Common Words in Articles",
       x = "Words",
       y = "Frequency")

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot1_text_analys.png", text_plot1)

# Sentiment Analysis

sentiment_analysis <- tidy_article %>% 
  inner_join(get_sentiments("bing"), by = "word") %>% 
  count(sentiment, sort = TRUE)

text_plot2 <- sentiment_analysis %>%
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(title = "Sentiment Analysis of Articles",
       x = "Sentiment",
       y = "Count")

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot2_text_analys.png", text_plot2)
