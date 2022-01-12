library(hexSticker)
library(tidyverse)

imgurl <- "logo/dots.png"

sticker(imgurl,
        package = "icoscp",
        p_size = 40,
        p_color = "white",
        h_color = "#e41c64",
        h_fill = "#2596be",
        filename = "logo.png",
        s_y = 1.3,
        s_x = 1,
        p_y = 0.9
        )
