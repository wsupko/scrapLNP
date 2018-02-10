library(rvest)
library(data.table)

kol <- 1
mainLink <- paste('https://www.laczynaspilka.pl/rozgrywki/ii-liga,3.html?round=', kol, sep = '')

main <- read_html(mainLink)

mainLinks <- main %>% html_nodes('a.action') %>% html_attr('href')

lnk <- mainLinks[1]

gameData <- data.table()
for (lnk in mainLinks){
    
    gameCode <- read_html(lnk)
    gosp <- gameCode %>% html_nodes("span.team-name.left") %>% html_text(trim = TRUE)
    gosc <- gameCode %>% html_nodes("span.team-name.right") %>% html_text(trim = TRUE)
    frek <- gameCode %>% html_node('div.toggle-content.report-info-content') %>% html_text(trim = TRUE)
    
    gameData <- rbind(gameData, data.table(lnk, gosp, gosc, frek))
}

