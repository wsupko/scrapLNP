library(rvest)
library(data.table)

gkol <- 1:22
gameData <- data.table()

for (kol in gkol){
    mainLink <- paste('https://www.laczynaspilka.pl/rozgrywki/ekstraklasa,1.html?round=', kol, sep = '')
    
    main <- read_html(mainLink)
    
    mainLinks <- main %>% html_nodes('a.action') %>% html_attr('href')
    
    for (lnk in mainLinks){
        
        gameCode <- read_html(lnk)
        gosp <- gameCode %>% html_nodes("span.team-name.left") %>% html_text(trim = TRUE)
        gosc <- gameCode %>% html_nodes("span.team-name.right") %>% html_text(trim = TRUE)
        frek <- gameCode %>% html_node('div.toggle-content.report-info-content') %>% html_text(trim = TRUE)
        
        gameData <- rbind(gameData, data.table(kol, lnk, gosp, gosc, frek))
    }
}

gameData[, nFrek:= str_extract(frek, '([0-9])+')]

write.csv(gameData, file = './data/out/Frek.csv', row.names = F)
