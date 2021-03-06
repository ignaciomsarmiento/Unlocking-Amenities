##########################################################
# author: Ignacio Sarmiento-Barbieri
#
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo



#Load Packages
pkg<-list("dplyr", "ggplot2", "ggmap")
lapply(pkg, require, character.only=T)
rm(pkg)


#Wd
setwd("~/Dropbox/Phd Illinois/Research/Neigh_crime/Unlocking_amenities/github/Unlocking-Amenities/")

#Get map form google maps (needs a KEY)
# oz <-get_map(location=c(-87.700625, 41.767845),maptype='hybrid', zoom = 14) 
# saveRDS(oz,"stores/marquette_park.rds")
oz<-readRDS("~/Dropbox/Phd\ Illinois/Research/Neigh_crime/Unlocking_amenities/stores/marquette_park.rds")
# TD2<-readRDS("stores/shift_share/data_ready_v5.rds")
# TD2<-data.frame(TD2)
TD2<-readRDS(paste0("~/Dropbox/Phd\ Illinois/Research/Neigh_crime/Unlocking_amenities/stores/shift_share/house_by_park_fe/house_by_park_fe_","Chicago",".rds"))
TD2<-do.call(rbind,TD2)

#Keep Marquette Park
oz.db<-TD2[grepl("Marquette",TD2$park_name),]



#Fix Lables
oz.db$dist2<-as.character(oz.db$dist)
oz.db$dist2[oz.db$dist2=="100"]<-'0 to 1/16'
oz.db$dist2[oz.db$dist2=="200"]<-'1 to 2/16'
oz.db$dist2[oz.db$dist2=="300"]<-'3 to 5/16'
oz.db$dist2[oz.db$dist2=="400"]<-'3 to 5/16'
oz.db$dist2[oz.db$dist2=="500"]<-'3 to 5/16'
oz.db$dist2[oz.db$dist2=="600"]<-'5 to 6/16'
oz.db$dist2<-factor(oz.db$dist2,levels=c('0 to 1/16','1 to 2/16','3 to 5/16','5 to 6/16'),ordered=TRUE)
  

z<-ggmap(oz) +
  geom_point(data=oz.db, aes(x=PropertyAddressLongitude, y=PropertyAddressLatitude, group=dist2, col=dist2), alpha=1, size=.3) +
  scale_color_manual(values=c("#1a9850",
                              #"#91cf60",
                              "#d9ef8b",
                              #"#fee08b",
                              #"#fc8d59",
                              "#fc4e2a",
                              "#808080")) + #,"#fb6a4a","#fc9272","#fcbba1")) +
  labs(color = "Distance to Park \n (miles)") +
  theme(plot.margin=grid::unit(c(0,0,0,0), "cm"), 
        legend.position="right",#c(.95,.95), 
        legend.key = element_rect(fill = "white"),
        text = element_text(size=10,family="Times"),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()
        ) +
  guides(colour = guide_legend(override.aes = list(size=2, alpha=1, nrow=2))) 
z

z+ coord_fixed(xlim = c(-87.685, -87.721),  ylim = c(41.756, 41.779), ratio = 1.3)

ggsave("views/fig1a.jpg", height = 5, width = 5, units="in")

  
  

